import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../data/models/models.dart';
import 'android_usage.dart';

const _newPipe = MethodChannel('veronica/youtube');

/// One way of finding a YouTube video's audio stream.
typedef YouTubeResolver = Future<Uri> Function(String link);

/// The Dart extractor, asking as [client].
YouTubeResolver _explode(YoutubeApiClient client) => (link) async {
  final yt = YoutubeExplode();
  try {
    final manifest = await yt.videos.streamsClient.getManifest(
      VideoId(link),
      ytClients: [client],
    );
    return manifest.audioOnly.withHighestBitrate().url;
  } finally {
    yt.close();
  }
};

/// NewPipe's extractor, on the Android side (`YouTubeChannel.kt`).
Future<Uri> _newPipeAudio(String link) async {
  final m = await _newPipe.invokeMapMethod<String, Object?>('audio', link);
  final url = m?['url'] as String?;
  if (url == null) throw StateError('NewPipe found no audio');
  return Uri.parse(url);
}

/// The ways a YouTube stream is found, tried in order, as yt-dlp and NewPipe
/// do: clients whose links need no decoding first (fast), then NewPipe's
/// extractor, which its team keeps working when YouTube changes.
final List<YouTubeResolver> youTubeResolvers = [
  _explode(YoutubeApiClient.androidVr),
  _explode(YoutubeApiClient.androidSdkless),
  _explode(YoutubeApiClient.tv),
  _explode(YoutubeApiClient.safari),
  _newPipeAudio,
];

/// Where the listening session is.
class ListeningState {
  const ListeningState({
    this.queue = const [],
    this.index = 0,
    this.loading = false,
    this.finished = false,
  });

  final List<AudioMantra> queue;
  final int index;

  /// Opening the current mantra (finding a YouTube stream).
  final bool loading;

  /// Every mantra in the queue has played.
  final bool finished;

  AudioMantra? get current => index < queue.length ? queue[index] : null;
  bool get hasNext => index + 1 < queue.length;

  ListeningState copyWith({int? index, bool? loading, bool? finished}) =>
      ListeningState(
        queue: queue,
        index: index ?? this.index,
        loading: loading ?? this.loading,
        finished: finished ?? this.finished,
      );
}

/// Plays a listening session as a media service, as NewPipe does: it keeps
/// playing with the screen off or the app in the background, with a
/// notification, lock-screen controls and headset buttons.
///
/// Files play from the phone. YouTube videos stream as audio only, found by
/// [youTubeResolvers] in turn; when a stream fails (a lookup error, or
/// YouTube refusing it midway), the next way is tried and playback resumes
/// where it stopped. Only when every way fails does the video open in the
/// YouTube app, and the session moves on.
class MantraAudioHandler extends BaseAudioHandler with SeekHandler {
  MantraAudioHandler({List<YouTubeResolver>? resolvers})
    : _resolvers = resolvers ?? youTubeResolvers {
    player.playbackEventStream.listen(
      (_) => playbackState.add(_state()),
      onError: (Object e, StackTrace _) => unawaited(_recover(e)),
    );
    player.playerStateStream.listen((s) {
      if (s.processingState == ProcessingState.completed) {
        unawaited(skipToNext());
      }
    });
  }

  final AudioPlayer player = AudioPlayer();
  final List<YouTubeResolver> _resolvers;

  /// The session, for the player page.
  final ValueNotifier<ListeningState> session = ValueNotifier(
    const ListeningState(),
  );

  /// Called with a mantra's length once known (to store it).
  void Function(String id, Duration length)? onLength;

  /// Which resolver found the current YouTube stream.
  int _attempt = 0;
  bool _recovering = false;

  ListeningState get _s => session.value;
  set _s(ListeningState v) => session.value = v;

  /// Starts a session of [queue] from the first mantra.
  Future<void> start(List<AudioMantra> queue) async {
    if (queue.isEmpty) return;
    _s = ListeningState(queue: queue);
    await _open();
  }

  Future<void> _open({int attempt = 0, Duration at = Duration.zero}) async {
    final m = _s.current;
    if (m == null) return;
    _attempt = attempt;
    _s = _s.copyWith(loading: true, finished: false);
    mediaItem.add(
      MediaItem(
        id: m.id,
        title: m.title,
        album: 'Veronica',
        artist: m.youTube ? 'Mantra · YouTube' : 'Mantra',
        duration: m.length > Duration.zero ? m.length : null,
      ),
    );
    try {
      final Duration? length;
      if (m.youTube) {
        length = await _openYouTube(m.source, at);
      } else {
        length = await player.setFilePath(m.source, initialPosition: at);
      }
      if (length != null) {
        if (m.length == Duration.zero) onLength?.call(m.id, length);
        mediaItem.add(mediaItem.value?.copyWith(duration: length));
      }
      _s = _s.copyWith(loading: false);
      unawaited(player.play());
    } on Object catch (e) {
      debugPrint('Mantra playback failed: $e');
      await _giveUp(m);
    }
  }

  /// Tries each resolver from [_attempt] until one plays.
  Future<Duration?> _openYouTube(String link, Duration at) async {
    Object? last;
    for (var i = _attempt; i < _resolvers.length; i++) {
      try {
        final url = await _resolvers[i](link);
        final length = await player.setAudioSource(
          AudioSource.uri(url),
          initialPosition: at,
        );
        _attempt = i;
        return length;
      } on Object catch (e) {
        debugPrint('YouTube way ${i + 1} failed: $e');
        last = e;
      }
    }
    throw StateError('No way to stream it: $last');
  }

  /// A stream broke while playing: fetch it another way, carry on from the
  /// same second.
  Future<void> _recover(Object error) async {
    final m = _s.current;
    if (m == null || _recovering) return;
    debugPrint('Mantra stream error: $error');
    if (!m.youTube || _attempt + 1 >= _resolvers.length) {
      await _giveUp(m);
      return;
    }
    _recovering = true;
    try {
      await _open(attempt: _attempt + 1, at: player.position);
    } finally {
      _recovering = false;
    }
  }

  /// Can't play [m]: a YouTube video opens in YouTube; then the next one.
  Future<void> _giveUp(AudioMantra m) async {
    if (m.youTube) {
      await launchUrl(
        Uri.parse(m.source),
        mode: LaunchMode.externalApplication,
      );
    }
    await skipToNext();
  }

  /// Plays or pauses; after the end, starts the session again.
  Future<void> toggle() async {
    if (player.playing) {
      await pause();
    } else if (_s.finished) {
      await start(_s.queue);
    } else {
      await play();
    }
  }

  @override
  Future<void> play() => player.play();

  @override
  Future<void> pause() => player.pause();

  @override
  Future<void> seek(Duration position) => player.seek(position);

  /// The next mantra, or the end of the session.
  @override
  Future<void> skipToNext() async {
    if (_s.hasNext) {
      _s = _s.copyWith(index: _s.index + 1);
      await _open();
    } else {
      await player.stop();
      _s = _s.copyWith(loading: false, finished: true);
    }
  }

  @override
  Future<void> stop() async {
    await player.stop();
    _s = const ListeningState();
    await super.stop();
  }

  PlaybackState _state() => PlaybackState(
    controls: [
      if (player.playing) MediaControl.pause else MediaControl.play,
      if (_s.hasNext) MediaControl.skipToNext,
      MediaControl.stop,
    ],
    systemActions: const {MediaAction.seek},
    androidCompactActionIndices: _s.hasNext ? const [0, 1] : const [0],
    processingState: switch (player.processingState) {
      ProcessingState.idle => AudioProcessingState.idle,
      ProcessingState.loading => AudioProcessingState.loading,
      ProcessingState.buffering => AudioProcessingState.buffering,
      ProcessingState.ready => AudioProcessingState.ready,
      ProcessingState.completed => AudioProcessingState.completed,
    },
    playing: player.playing,
    updatePosition: player.position,
    bufferedPosition: player.bufferedPosition,
    speed: player.speed,
  );
}

/// Starts the media service (Android only) and returns its handler; other
/// platforms and tests get a plain handler.
Future<MantraAudioHandler> initMantraAudio() async {
  if (!isAndroid) return MantraAudioHandler();
  try {
    return await AudioService.init(
      builder: MantraAudioHandler.new,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.isg32.veronica.mantra',
        androidNotificationChannelName: 'Mantra',
        androidNotificationIcon: 'drawable/ic_notify_mantra',
        androidStopForegroundOnPause: true,
      ),
    );
  } on Object catch (e) {
    debugPrint('Media service unavailable: $e');
    return MantraAudioHandler();
  }
}

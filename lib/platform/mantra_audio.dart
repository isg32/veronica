import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../core/ids.dart';
import '../data/models/models.dart';
import '../data/providers.dart';

part 'mantra_audio.g.dart';

/// Audio formats an audio mantra can be.
const mantraExtensions = ['mp3', 'flac', 'm4a', 'aac', 'ogg', 'opus', 'wav'];

/// Picks audio files and copies them into the app: (title, path, length).
Future<List<(String, String, Duration)>> pickMantraFiles() async {
  final files = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: mantraExtensions,
  );
  final dir = Directory(
    '${(await getApplicationSupportDirectory()).path}/mantras',
  );
  await dir.create(recursive: true);
  final out = <(String, String, Duration)>[];
  for (final picked in files) {
    final source = picked.path;
    if (source == null) continue;
    final dot = source.lastIndexOf('.');
    final ext = dot < 0 ? '' : source.substring(dot);
    final copy = await File(source).copy('${dir.path}/${newId('mantra')}$ext');
    final player = AudioPlayer();
    Duration length;
    try {
      length = await player.setFilePath(copy.path) ?? Duration.zero;
    } on Object {
      length = Duration.zero;
    } finally {
      await player.dispose();
    }
    final name = picked.name;
    final nameDot = name.lastIndexOf('.');
    out.add((
      nameDot < 0 ? name : name.substring(0, nameDot),
      copy.path,
      length,
    ));
  }
  return out;
}

/// YouTube clients whose audio links Android's player can stream.
const _clients = [YoutubeApiClient.androidVr, YoutubeApiClient.androidSdkless];

/// Looks up YouTube [links]: (title, link, length) for each video; a
/// playlist link adds every video in it. Links that aren't YouTube are
/// skipped. Without a network, a video is kept with a plain title.
Future<List<(String, String, Duration)>> lookUpYouTube(
  List<String> links,
) async {
  final yt = YoutubeExplode();
  final out = <(String, String, Duration)>[];
  try {
    for (final raw in links) {
      final link = raw.trim();
      if (link.isEmpty) continue;
      final videoId = VideoId.parseVideoId(link);
      final playlistId = PlaylistId.parsePlaylistId(link);
      if (videoId == null && playlistId != null) {
        try {
          await for (final v in yt.playlists.getVideos(playlistId)) {
            out.add((v.title, v.url, v.duration ?? Duration.zero));
          }
        } on Object catch (e) {
          debugPrint('YouTube playlist lookup failed: $e');
        }
        continue;
      }
      if (videoId == null) continue;
      final url = 'https://www.youtube.com/watch?v=$videoId';
      try {
        final v = await yt.videos.get(videoId);
        out.add((v.title, url, v.duration ?? Duration.zero));
      } on Object catch (e) {
        debugPrint('YouTube lookup failed: $e');
        out.add(('YouTube video', url, Duration.zero));
      }
    }
  } finally {
    yt.close();
  }
  return out;
}

/// A YouTube video found by search: (title, channel, link, length).
typedef YouTubeResult = ({
  String title,
  String channel,
  String link,
  Duration length,
});

/// Searches YouTube for videos matching [query] (the first page).
Future<List<YouTubeResult>> searchYouTube(String query) async {
  final yt = YoutubeExplode();
  try {
    final results = await yt.search.search(query);
    return [
      for (final v in results)
        (
          title: v.title,
          channel: v.author,
          link: 'https://www.youtube.com/watch?v=${v.id}',
          length: v.duration ?? Duration.zero,
        ),
    ];
  } finally {
    yt.close();
  }
}

/// The audio-only stream of a YouTube video, for streaming.
Future<Uri> youTubeAudio(String link) async {
  final yt = YoutubeExplode();
  try {
    final manifest = await yt.videos.streamsClient.getManifest(
      VideoId(link),
      ytClients: _clients,
    );
    return manifest.audioOnly.withHighestBitrate().url;
  } finally {
    yt.close();
  }
}

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

  /// Opening the current mantra (resolving a YouTube stream).
  final bool loading;

  /// Every mantra in the queue has played.
  final bool finished;

  AudioMantra? get current => index < queue.length ? queue[index] : null;
  bool get hasNext => index + 1 < queue.length;
}

/// Plays a listening session: the chosen mantra, or all of them in order.
///
/// Files play from the phone. YouTube videos stream as audio only; when a
/// video can't be streamed, it opens in the YouTube app instead and the
/// session moves on.
@Riverpod(keepAlive: true)
class MantraPlayer extends _$MantraPlayer {
  final AudioPlayer player = AudioPlayer();
  StreamSubscription<PlayerState>? _done;

  @override
  ListeningState build() {
    _done = player.playerStateStream.listen((s) {
      if (s.processingState == ProcessingState.completed) unawaited(next());
    });
    ref.onDispose(() {
      unawaited(_done?.cancel());
      unawaited(player.dispose());
    });
    return const ListeningState();
  }

  /// Starts a session of [queue] from the first mantra.
  Future<void> start(List<AudioMantra> queue) async {
    if (queue.isEmpty) return;
    state = ListeningState(queue: queue);
    await _open();
  }

  Future<void> _open() async {
    final mantra = state.current;
    if (mantra == null) return;
    state = ListeningState(
      queue: state.queue,
      index: state.index,
      loading: true,
    );
    try {
      final Duration? length;
      if (mantra.youTube) {
        length = await player.setAudioSource(
          AudioSource.uri(await youTubeAudio(mantra.source)),
        );
      } else {
        length = await player.setFilePath(mantra.source);
      }
      if (length != null && mantra.length == Duration.zero) {
        unawaited(
          ref.read(listeningRepositoryProvider).setLength(mantra.id, length),
        );
      }
      state = ListeningState(queue: state.queue, index: state.index);
      unawaited(player.play());
    } on Object catch (e) {
      debugPrint('Mantra playback failed: $e');
      if (mantra.youTube) {
        // Can't stream it: hand it to YouTube, then carry on.
        await launchUrl(
          Uri.parse(mantra.source),
          mode: LaunchMode.externalApplication,
        );
      }
      await next();
    }
  }

  Future<void> toggle() async {
    if (player.playing) {
      await player.pause();
    } else if (state.finished) {
      await start(state.queue);
    } else {
      unawaited(player.play());
    }
  }

  /// The next mantra, or the end of the session.
  Future<void> next() async {
    if (state.hasNext) {
      state = ListeningState(queue: state.queue, index: state.index + 1);
      await _open();
    } else {
      await player.stop();
      state = ListeningState(
        queue: state.queue,
        index: state.index,
        finished: true,
      );
    }
  }

  Future<void> stop() async {
    await player.stop();
    state = const ListeningState();
  }
}

/// What a session plays: the chosen mantra, or all in the order added.
List<AudioMantra> sessionQueue(
  List<AudioMantra> all,
  ListeningSettings settings,
) {
  final chosen = all.where((m) => m.id == settings.playId).toList();
  return chosen.isNotEmpty ? chosen : all;
}

import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../core/ids.dart';
import '../data/models/models.dart';
import '../data/providers.dart';
import 'mantra_service.dart';

export 'mantra_service.dart' show ListeningState;

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

/// The media service playing listening sessions; [initMantraAudio] makes
/// it in main(), which overrides this.
@Riverpod(keepAlive: true)
MantraAudioHandler mantraHandler(Ref ref) => MantraAudioHandler();

/// The listening session, for the pages (see [MantraAudioHandler]).
@Riverpod(keepAlive: true)
class MantraPlayer extends _$MantraPlayer {
  MantraAudioHandler get _handler => ref.read(mantraHandlerProvider);

  AudioPlayer get player => _handler.player;

  @override
  ListeningState build() {
    final handler = ref.watch(mantraHandlerProvider);
    final repo = ref.read(listeningRepositoryProvider);
    handler.onLength = (id, length) => unawaited(repo.setLength(id, length));
    void changed() => state = handler.session.value;
    handler.session.addListener(changed);
    ref.onDispose(() => handler.session.removeListener(changed));
    return handler.session.value;
  }

  Future<void> start(List<AudioMantra> queue) => _handler.start(queue);
  Future<void> toggle() => _handler.toggle();
  Future<void> next() => _handler.skipToNext();
  Future<void> stop() => _handler.stop();
}

/// What a session plays: the chosen mantra, or all in the order added.
List<AudioMantra> sessionQueue(
  List<AudioMantra> all,
  ListeningSettings settings,
) {
  final chosen = all.where((m) => m.id == settings.playId).toList();
  return chosen.isNotEmpty ? chosen : all;
}

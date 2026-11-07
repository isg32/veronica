import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/format.dart';
import '../../core/icons/v_icons.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_controls.dart';
import '../../core/widgets/v_glass.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_page.dart';
import '../../core/widgets/v_pickers.dart';
import '../../core/widgets/v_progress.dart';
import '../../core/widgets/v_surface.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../../platform/mantra_audio.dart';
import '../prompts/prompt_widgets.dart';

/// Audio mantras (files and YouTube links) and the daily listening session.
class ListeningLibraryPage extends ConsumerStatefulWidget {
  const ListeningLibraryPage({super.key});

  @override
  ConsumerState<ListeningLibraryPage> createState() =>
      _ListeningLibraryPageState();
}

class _ListeningLibraryPageState extends ConsumerState<ListeningLibraryPage> {
  bool _adding = false;

  Future<void> _busy(Future<void> Function() work) async {
    setState(() => _adding = true);
    try {
      await work();
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  Future<void> _addYouTube() async {
    final text = await showVSheet<String>(
      context,
      title: 'Add from YouTube',
      builder: (_) => const _LinksPrompt(),
    );
    if (text == null) return;
    final links = text.split(RegExp(r'[\s,]+'));
    await _busy(() async {
      final added = await ref
          .read(listeningRepositoryProvider)
          .addYouTube(links);
      if (added == 0 && mounted) {
        await showVSheet<void>(
          context,
          title: 'Nothing added',
          builder: (_) => const VFootnote(
            'Those don\'t look like YouTube video or playlist links.',
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final audio =
        ref.watch(audioMantrasProvider).value ?? const <AudioMantra>[];
    final s = ref.watch(listeningSettingsProvider).value;
    final repo = ref.read(listeningRepositoryProvider);
    if (s == null) return const SizedBox.shrink();
    void save(ListeningSettings next) => repo.saveSettings(next);

    return VDetailPage(
      backLabel: 'Care',
      title: 'Mantras',
      children: [
        if (audio.isNotEmpty)
          VButton.primary(
            'Listen now',
            onPressed: () => context.push(Routes.listen),
          ),
        VListSection(
          header: const VEyebrow('Listening session'),
          children: [
            VListRow(
              title: 'Remind me',
              trailing: VSwitch(
                value: s.enabled,
                onChanged: (on) => save(s.copyWith(enabled: on)),
              ),
            ),
            VListRow(
              title: 'At',
              value: s.time.label,
              onTap: () async {
                final t = await showTimePickerSheet(
                  context,
                  title: 'Mantra time',
                  initial: s.time,
                );
                if (t != null) save(s.copyWith(time: t));
              },
            ),
          ],
        ),
        VDayPicker(
          days: s.days,
          onChanged: (days) => save(s.copyWith(days: days)),
        ),
        VSegmented<bool>(
          segments: const {true: 'Play all in order', false: 'Play one'},
          value: s.playId == null,
          onChanged: (all) => save(
            s.copyWith(
              playId: () => all || audio.isEmpty ? null : audio.first.id,
            ),
          ),
        ),
        if (audio.isNotEmpty)
          VListSection(
            header: const VEyebrow('Yours'),
            children: [
              for (final m in audio)
                VListRow(
                  leading: VIconView(
                    m.youTube ? VIcon.focus : VIcon.care,
                    size: 18,
                  ),
                  title: m.title,
                  subtitle: [
                    if (m.youTube) 'YouTube' else 'On this phone',
                    if (m.length > Duration.zero) VFormat.length(m.length),
                  ].join(' · '),
                  trailing: m.id == s.playId
                      ? const VPill.badge('Plays')
                      : null,
                  onTap: () => _actions(m, s),
                ),
            ],
          ),
        if (_adding)
          Center(child: Text('Adding…', style: VText.secondary))
        else ...[
          VButton.secondary(
            'Add audio files',
            onPressed: () => _busy(repo.importFiles),
          ),
          VButton.secondary('Add from YouTube', onPressed: _addYouTube),
        ],
        const VFootnote(
          'MP3, FLAC, M4A, OGG or WAV from your phone, or YouTube videos and '
          'playlists, played as audio. A video that can\'t be streamed opens '
          'in YouTube instead.',
        ),
      ],
    );
  }

  void _actions(AudioMantra m, ListeningSettings s) {
    final repo = ref.read(listeningRepositoryProvider);
    unawaited(
      showVSheet<void>(
        context,
        title: m.title,
        builder: (sheet) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VButton.primary(
              'Play',
              onPressed: () {
                Navigator.of(sheet).pop();
                unawaited(ref.read(mantraPlayerProvider.notifier).start([m]));
                context.push(Routes.listen);
              },
            ),
            const SizedBox(height: 10),
            VButton.secondary(
              m.id == s.playId ? 'Play all in sessions' : 'Use for sessions',
              onPressed: () {
                Navigator.of(sheet).pop();
                repo.saveSettings(
                  s.copyWith(playId: () => m.id == s.playId ? null : m.id),
                );
              },
            ),
            const SizedBox(height: 10),
            VButton.secondary(
              'Rename',
              onPressed: () async {
                Navigator.of(sheet).pop();
                final name = await showTextSheet(
                  context,
                  title: 'Rename',
                  initial: m.title,
                );
                if (name != null) await repo.rename(m.id, name);
              },
            ),
            const SizedBox(height: 10),
            VButton.ghost(
              'Remove',
              onPressed: () {
                Navigator.of(sheet).pop();
                repo.delete(m.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// One or more YouTube links, one per line.
class _LinksPrompt extends StatefulWidget {
  const _LinksPrompt();

  @override
  State<_LinksPrompt> createState() => _LinksPromptState();
}

class _LinksPromptState extends State<_LinksPrompt> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      VTextField(
        controller: _text,
        placeholder: 'Paste video or playlist links',
        maxLines: 4,
        autofocus: true,
      ),
      const SizedBox(height: 8),
      const VFootnote('One link per line. A playlist adds all its videos.'),
      const SizedBox(height: 14),
      VButton.primary(
        'Add',
        onPressed: () => Navigator.of(context).pop(_text.text),
      ),
    ],
  );
}

/// The listening session: what plays, how far along, play and next.
class ListeningSessionPage extends ConsumerStatefulWidget {
  const ListeningSessionPage({super.key});

  @override
  ConsumerState<ListeningSessionPage> createState() =>
      _ListeningSessionPageState();
}

class _ListeningSessionPageState extends ConsumerState<ListeningSessionPage> {
  @override
  void initState() {
    super.initState();
    // Opened from a reminder or "Listen now": start the session, unless a
    // mantra was just picked to play.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final player = ref.read(mantraPlayerProvider);
      if (player.current != null) return;
      final audio = await ref.read(audioMantrasProvider.future);
      final settings = await ref.read(listeningSettingsProvider.future);
      await ref
          .read(mantraPlayerProvider.notifier)
          .start(sessionQueue(audio, settings));
    });
  }

  Future<void> _close() async {
    await ref.read(mantraPlayerProvider.notifier).stop();
    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.care);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(mantraPlayerProvider);
    final notifier = ref.read(mantraPlayerProvider.notifier);
    final player = notifier.player;
    final m = session.current;

    return PromptScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                VTappable(
                  onTap: _close,
                  child: Text('Close', style: VText.inter(13)),
                ),
                const Spacer(),
                if (session.queue.length > 1)
                  Text(
                    '${session.index + 1} OF ${session.queue.length}',
                    style: VText.eyebrow,
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    m?.youTube ?? false ? 'MANTRA · YOUTUBE' : 'MANTRA',
                    style: VText.eyebrow,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    m?.title ?? 'Nothing to play yet',
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: VText.inter(28, weight: 300, height: 1.2),
                  ),
                  const SizedBox(height: 40),
                  if (m != null)
                    StreamBuilder<Duration>(
                      stream: player.positionStream,
                      builder: (context, snap) {
                        final at = snap.data ?? Duration.zero;
                        final total = player.duration ?? m.length;
                        return Column(
                          children: [
                            Text(
                              session.loading ? '··:··' : VFormat.length(at),
                              style: VText.doto(56, weight: 900),
                            ),
                            if (total > Duration.zero) ...[
                              const SizedBox(height: 14),
                              VBar(
                                value:
                                    (at.inMilliseconds / total.inMilliseconds)
                                        .clamp(0.0, 1.0),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'of ${VFormat.length(total)}',
                                style: VText.inter(12, weight: 300),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  const SizedBox(height: 40),
                  if (session.loading)
                    Text('Opening…', style: VText.secondary)
                  else if (session.finished)
                    Text('Session done.', style: VText.inter(15))
                  else if (m == null)
                    VLink(
                      'Add a mantra',
                      onTap: () => context.go(Routes.listening),
                    ),
                ],
              ),
            ),
          ),
          if (m != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: StreamBuilder<bool>(
                stream: player.playingStream,
                builder: (context, snap) {
                  final playing = snap.data ?? false;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      VButton.primary(
                        session.finished
                            ? 'Play again'
                            : (playing ? 'Pause' : 'Play'),
                        onPressed: session.loading ? null : notifier.toggle,
                      ),
                      if (session.hasNext) ...[
                        const SizedBox(height: 10),
                        VButton.secondary(
                          'Next',
                          onPressed: session.loading ? null : notifier.next,
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// Care: the listening session, its time and what plays.
class ListeningCard extends ConsumerWidget {
  const ListeningCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(listeningSettingsProvider).value;
    final audio =
        ref.watch(audioMantrasProvider).value ?? const <AudioMantra>[];
    if (s == null) return const SizedBox.shrink();
    final queue = sessionQueue(audio, s);

    return VCard(
      radius: 24,
      padding: const EdgeInsets.all(18),
      onTap: () => context.push(Routes.listening),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VEyebrow(
            s.enabled ? 'Mantra · ${s.time.label}' : 'Mantra',
            trailing: VEyebrowNote(
              s.enabled ? VFormat.daysWord(s.days) : 'Reminder off',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            switch (queue.length) {
              0 => 'Add an audio mantra to listen to.',
              1 => queue.single.title,
              final n => '$n mantras, in order',
            },
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: VText.inter(22, height: 1.25),
          ),
          const SizedBox(height: 12),
          VPill(
            queue.isEmpty ? 'Add' : 'Listen now',
            style: VText.inter(13, weight: 600),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onTap: () =>
                context.push(queue.isEmpty ? Routes.listening : Routes.listen),
          ),
        ],
      ),
    );
  }
}

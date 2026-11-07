import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/format.dart';
import '../../core/theme/v_colors.dart';
import '../../core/theme/v_palette.dart';
import '../../core/widgets/v_ink.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_breathe.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_glass.dart';
import '../../core/widgets/v_surface.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../../platform/reminders.dart';
import '../selectors.dart';
import 'prompt_widgets.dart';

void _leave(BuildContext context) =>
    context.canPop() ? context.pop() : context.go(Routes.today);

/// "Medicine due": name and dose with Taken / Snooze 15 min / Skip.
class MedicineDuePage extends ConsumerWidget {
  const MedicineDuePage({super.key, required this.medicineId});

  final String medicineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meds = ref.watch(medicinesProvider).value ?? const <Medicine>[];
    final doses = ref.watch(dosesProvider).value ?? const <DoseLog>[];
    final now = ref.watch(currentTimeProvider);
    final med = meds.where((m) => m.id == medicineId).firstOrNull;
    if (med == null) return const PromptScaffold(child: SizedBox.shrink());
    final repo = ref.read(medicineRepositoryProvider);

    bool today(DoseLog d) =>
        d.medicineId == med.id &&
        d.scheduledAt.year == now.year &&
        d.scheduledAt.month == now.month &&
        d.scheduledAt.day == now.day;
    final todays = doses.where(today).toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    final due = todays.where((d) => d.status == DoseStatus.due).firstOrNull;
    final index = due == null ? todays.length : todays.indexOf(due) + 1;
    final total = med.times.length;
    final time = due?.scheduledAt ?? now;

    return PromptScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PromptHeadline(
            eyebrow: '${VFormat.time(time)} · DOSE $index OF $total TODAY',
            title: splitForHeadline(med.name),
            size: 52,
            body: '${med.dose.replaceAll(' · ', ', ')}, with water.',
          ),
          Expanded(
            child: Center(
              child: SizedBox.square(
                dimension: 180,
                child: VOutlined(
                  radius: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${med.refillCount}',
                        style: VText.doto(56, weight: 900, height: 1),
                      ),
                      const SizedBox(height: 4),
                      Text('tablets left', style: VText.inter(12)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
            child: Column(
              children: [
                VButton.primary(
                  'Taken',
                  onPressed: () async {
                    if (due != null) {
                      await repo.setDoseStatus(due, DoseStatus.taken);
                      await snoozeMedicine(ref.read(databaseProvider), null);
                    }
                    if (context.mounted) _leave(context);
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: VButton.secondary(
                        'Snooze 15 min',
                        onPressed: () async {
                          await snoozeMedicine(
                            ref.read(databaseProvider),
                            med.id,
                          );
                          if (context.mounted) _leave(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: VButton.ghost(
                        'Skip',
                        onPressed: () async {
                          if (due != null) {
                            await repo.setDoseStatus(due, DoseStatus.skipped);
                            await snoozeMedicine(
                              ref.read(databaseProvider),
                              null,
                            );
                          }
                          if (context.mounted) _leave(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "Alarm ringing": huge time, a fade-in meter, tap to snooze, slide to stop.
class AlarmRingingPage extends ConsumerStatefulWidget {
  const AlarmRingingPage({super.key, required this.alarmId});

  final String alarmId;

  @override
  ConsumerState<AlarmRingingPage> createState() => _AlarmRingingPageState();
}

class _AlarmRingingPageState extends ConsumerState<AlarmRingingPage> {
  late final DateTime _started = ref.read(currentTimeProvider);
  final AudioPlayer _player = AudioPlayer();
  Timer? _fade;

  @override
  void initState() {
    super.initState();
    unawaited(_play());
  }

  /// Plays the alarm's sound on a loop, fading in over its fade-in time.
  Future<void> _play() async {
    // Read once: the page may close while this is still loading.
    final repo = ref.read(sleepRepositoryProvider);
    final alarms = await repo.watchAlarms().first;
    final alarm = alarms.where((a) => a.id == widget.alarmId).firstOrNull;
    final soundId = alarm?.soundId;
    if (!mounted || alarm == null || soundId == null) return;
    final path = await repo.soundPath(soundId);
    if (path == null || path.isEmpty || !mounted) return;
    try {
      await _player.setFilePath(path);
      await _player.setLoopMode(LoopMode.one);
      await _player.setVolume(0);
      unawaited(_player.play());
    } on Object {
      return;
    }
    final fade = Duration(minutes: alarm.fadeInMin);
    final start = DateTime.now();
    _fade = Timer.periodic(const Duration(seconds: 1), (t) {
      final p =
          DateTime.now().difference(start).inMilliseconds / fade.inMilliseconds;
      unawaited(_player.setVolume(p.clamp(0.05, 1.0)));
      if (p >= 1) t.cancel();
    });
  }

  Future<void> _stop() async {
    _fade?.cancel();
    await _player.stop();
  }

  @override
  void dispose() {
    _fade?.cancel();
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = ref.watch(currentTimeProvider);
    final alarms = ref.watch(alarmsProvider).value ?? const <Alarm>[];
    final sounds = ref.watch(soundsProvider).value ?? const <AlarmSound>[];
    final name = ref.watch(profileProvider).value?.name ?? '';
    final alarm = alarms.where((a) => a.id == widget.alarmId).firstOrNull;
    final sound = sounds.where((s) => s.id == alarm?.soundId).firstOrNull;

    final fade = Duration(minutes: alarm?.fadeInMin ?? 4);
    final elapsed = now.difference(_started);
    final level = (elapsed.inSeconds / fade.inSeconds).clamp(0.0, 1.0);
    final fadedMin = (elapsed.inSeconds / 60).ceil().clamp(1, fade.inMinutes);
    final shownTime = alarm == null ? VFormat.time(now) : alarm.time.label;

    return PromptScaffold(
      child: Column(
        children: [
          const SizedBox(height: 80),
          Text(
            VFormat.eyebrowDate(now),
            style: VText.inter(11, weight: 500, letterSpacing: 1.5),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              shownTime,
              style: VText.doto(
                112,
                weight: 900,
                height: 0.9,
                letterSpacing: -2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name.isEmpty ? 'Good morning.' : 'Good morning, $name.',
            style: VText.inter(18, weight: 300),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FadeMeter(level: level),
              const SizedBox(width: 8),
              Text(
                level >= 1
                    ? '${sound?.name ?? 'Alarm'} · full volume'
                    : '${sound?.name ?? 'Alarm'} · fading in, $fadedMin of ${fade.inMinutes} min',
                style: VText.inter(12),
              ),
            ],
          ),
          const Spacer(),
          VLink(
            'Tap to snooze · ${alarm?.snoozeMin ?? 9} min',
            onTap: () async {
              await _stop();
              await snoozeAlarm(
                ref.read(databaseProvider),
                widget.alarmId,
                alarm?.snoozeMin ?? 9,
              );
              if (context.mounted) _leave(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 44),
            child: SizedBox(
              width: double.infinity,
              child: VSlideToStop(
                onComplete: () async {
                  await _stop();
                  await ref
                      .read(databaseProvider)
                      .writePref(snoozePrefKey, null);
                  if (context.mounted) _leave(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FadeMeter extends StatelessWidget {
  const _FadeMeter({required this.level});

  final double level;

  @override
  Widget build(BuildContext context) {
    const heights = [4.0, 6.0, 8.0, 10.0, 12.0];
    final lit = (level * heights.length).ceil();
    return SizedBox(
      height: 12,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < heights.length; i++) ...[
            if (i > 0) const SizedBox(width: 2),
            SizedBox(
              width: 3,
              height: heights[i],
              child: VOutlined(
                radius: 0,
                outline: i < lit ? VOutline.none : VOutline.solid,
                fill: i < lit ? VInk.of(context) : VColors.transparent,
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The 1-minute mantra session with a breathing circle.
class MantraSessionPage extends ConsumerWidget {
  const MantraSessionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mantra = ref.watch(todayMantraProvider);
    final voice = ref.watch(voiceSettingsProvider).value;
    final voiceOn =
        (voice?.enabled ?? false) &&
        (voice?.moments.contains(VoiceMoment.mantra) ?? false);
    final text = (mantra?.text ?? '').replaceAll('. ', '.\n');

    return PromptScaffold(
      child: Countdown(
        seconds: 60,
        builder: (context, left) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  VTappable(
                    onTap: () => _leave(context),
                    child: Text('Close', style: VText.inter(13)),
                  ),
                  const Spacer(),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: voiceOn ? VInk.of(context) : VColors.transparent,
                      border: Border.all(color: VInk.of(context)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    voiceOn ? 'Voice on' : 'Voice off',
                    style: VText.inter(13),
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
                      text,
                      textAlign: TextAlign.center,
                      style: VText.inter(
                        34,
                        weight: 300,
                        height: 1.2,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 56),
                    _BreathRing(left: left),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: left == 0
                  ? VLink('Done', onTap: () => _leave(context))
                  : Text(
                      'In for 4 · out for 6',
                      style: VText.inter(12, weight: 300),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreathRing extends StatelessWidget {
  const _BreathRing({required this.left});

  final int left;

  @override
  Widget build(BuildContext context) {
    return VBreathing(
      running: left > 0,
      builder: (context, t, inhaling) => SizedBox.square(
        dimension: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned.fill(
              child: VOutlined(
                radius: 100,
                outline: VOutline.dashed,
                child: SizedBox.expand(),
              ),
            ),
            Transform.scale(
              scale: 0.8 + 0.2 * t,
              child: const SizedBox.square(
                dimension: 150,
                child: VOutlined(
                  radius: 75,
                  width: 1.5,
                  child: SizedBox.expand(),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  left == 0
                      ? 'DONE'
                      : (inhaling ? 'BREATHE IN' : 'BREATHE OUT'),
                  style: VText.inter(11, weight: 500, letterSpacing: 1.5),
                ),
                const SizedBox(height: 4),
                Text(
                  VFormat.clock(Duration(seconds: left)).padLeft(5, '0'),
                  style: VText.doto(22),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// "Mantra time": a gentle glass card with Start or Later.
class MantraTimePage extends ConsumerWidget {
  const MantraTimePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mantra = ref.watch(todayMantraProvider);
    final settings = ref.watch(mantraSettingsProvider).value;
    final name = ref.watch(profileProvider).value?.name ?? '';

    return PromptScaffold(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: VGlass(
            radius: 28,
            tint: VPalette.of(context).glassCard,
            blur: 16,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${settings?.time.label ?? ''} · MANTRA TIME',
                    style: VText.eyebrow,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    name.isEmpty
                        ? 'One minute for yourself.'
                        : 'One minute for yourself, $name.',
                    style: VText.inter(22, weight: 300, height: 1.3),
                  ),
                  const SizedBox(height: 18),
                  const VDivider(),
                  const SizedBox(height: 16),
                  Text(mantra?.text ?? '', style: VText.inter(16)),
                  const SizedBox(height: 18),
                  VButton.primary(
                    'Start',
                    onPressed: () =>
                        context.pushReplacement(Routes.mantraSession),
                  ),
                  const SizedBox(height: 10),
                  VButton.secondary('Later', onPressed: () => _leave(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/format.dart';
import '../../core/icons/v_icons.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_controls.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_page.dart';
import '../../core/widgets/v_pickers.dart';
import '../../core/widgets/v_progress.dart';
import '../../core/widgets/v_surface.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';

/// Tab 5: bedtime, wind-down, alarms and the last seven nights.
class SleepPage extends StatelessWidget {
  const SleepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const VTabPage(
      title: 'Sleep',
      children: [_TonightCard(), _WindDownCard(), _AlarmsCard(), _NightsCard()],
    );
  }
}

class _TonightCard extends ConsumerWidget {
  const _TonightCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(sleepScheduleProvider).value;
    if (s == null) return const SizedBox.shrink();
    final repo = ref.read(sleepRepositoryProvider);

    Widget end(String label, DayTime time, {required bool bed}) {
      return VTappable(
        onTap: () async {
          final t = await showTimePickerSheet(
            context,
            title: bed ? 'Bedtime' : 'Wake',
            initial: time,
          );
          if (t == null) return;
          await repo.saveSchedule(
            bed ? s.copyWith(bedtime: t) : s.copyWith(wake: t),
          );
        },
        child: Column(
          crossAxisAlignment: bed
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Text(label, style: VText.inter(12, weight: 300)),
            const SizedBox(height: 2),
            Text(time.label, style: VText.doto(34, weight: 900, height: 1)),
          ],
        ),
      );
    }

    return VCard(
      radius: 24,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VEyebrow('Tonight'),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              end('Bed', s.bedtime, bed: true),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      const VDashedRule(),
                      Transform.translate(
                        offset: const Offset(0, -12),
                        child: SizedBox(
                          height: 22,
                          child: OverflowBox(
                            maxWidth: 120,
                            maxHeight: 22,
                            child: VPill.badge(VFormat.hm(s.sleepLength)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              end('Wake', s.wake, bed: false),
            ],
          ),
        ],
      ),
    );
  }
}

class _WindDownCard extends ConsumerWidget {
  const _WindDownCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(sleepScheduleProvider).value;
    if (s == null) return const SizedBox.shrink();
    return VCard(
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Wind-down', style: VText.inter(14, weight: 500)),
              ),
              VSegmented<int>(
                compact: true,
                segments: const {15: '15', 30: '30', 60: '60'},
                value: s.windDownMin,
                onChanged: (v) => ref
                    .read(sleepRepositoryProvider)
                    .saveSchedule(s.copyWith(windDownMin: v)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'From ${s.windDownStart.label}: greyscale, Do Not Disturb, '
            'and Veronica says goodnight.',
            style: VText.inter(12, weight: 300, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _AlarmsCard extends ConsumerWidget {
  const _AlarmsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarms = ref.watch(alarmsProvider).value ?? const <Alarm>[];
    final sounds = {
      for (final s in ref.watch(soundsProvider).value ?? const <AlarmSound>[])
        s.id: s.name,
    };
    final repo = ref.read(sleepRepositoryProvider);

    return VCard(
      radius: 24,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: VEyebrow(
              'Alarms',
              trailing: VTappable(
                onTap: () => context.push(Routes.alarm(Routes.newId)),
                child: const VIconView(VIcon.plus, size: 18, strokeWidth: 1.6),
              ),
            ),
          ),
          if (alarms.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('No alarms yet.', style: VText.secondary),
            ),
          for (final (i, a) in alarms.indexed) ...[
            if (i > 0) const VDivider(),
            VTappable(
              onTap: () => context.push(Routes.alarm(a.id)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.time.label,
                            style: VText.doto(
                              28,
                              weight: a.enabled ? 700 : 500,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            [
                              VFormat.days(a.days),
                              ?sounds[a.soundId],
                              if (a.glyphSunrise) 'sunrise',
                            ].join(' · '),
                            style: VText.inter(12, weight: 300),
                          ),
                        ],
                      ),
                    ),
                    VSwitch(
                      value: a.enabled,
                      onChanged: (v) => repo.saveAlarm(a.copyWith(enabled: v)),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _NightsCard extends ConsumerWidget {
  const _NightsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nights = ref.watch(nightsProvider).value ?? const <NightLog>[];
    if (nights.isEmpty) return const SizedBox.shrink();
    final avg =
        nights.fold<int>(0, (s, n) => s + n.actual.inMinutes) ~/ nights.length;

    return VCard(
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VEyebrow('Last 7 nights', trailing: VPairLegend()),
          const SizedBox(height: 12),
          VPairChart(
            planned: [for (final n in nights) n.planned.inMinutes.toDouble()],
            actual: [for (final n in nights) n.actual.inMinutes.toDouble()],
            labels: [for (final n in nights) VFormat.dayLetter(n.date)],
          ),
          const SizedBox(height: 12),
          Text(
            'Average ${VFormat.minutes(avg)} · estimated from screen-off time',
            style: VText.inter(12, weight: 300),
          ),
        ],
      ),
    );
  }
}

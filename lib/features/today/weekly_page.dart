import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_page.dart';
import '../../core/widgets/v_progress.dart';
import '../../core/widgets/v_surface.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';

/// "This week": screen time, water, sleep and nudges for the last 7 days.
class WeeklyPage extends ConsumerWidget {
  const WeeklyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(watchedAppsProvider).value ?? const <WatchedApp>[];
    final water = ref.watch(waterWeekProvider).value ?? const <WaterDay>[];
    final nights = ref.watch(nightsProvider).value ?? const <NightLog>[];
    final nudges = ref.watch(weekNudgesProvider).value;

    final perDay = List<int>.generate(
      7,
      (i) => apps.fold<int>(
        0,
        (s, a) => s + (i < a.lastSevenDays.length ? a.lastSevenDays[i] : 0),
      ),
    );
    final total = perDay.fold<int>(0, (s, m) => s + m);
    final limit = apps.fold<int>(0, (s, a) => s + a.dailyLimitMin);
    final labels = water.length == 7
        ? water.map((d) => VFormat.dayLetter(d.date)).toList()
        : const ['S', 'S', 'M', 'T', 'W', 'T', 'F'];

    return VDetailPage(
      backLabel: 'Today',
      title: 'This week',
      children: [
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VEyebrow(
                'Screen time',
                trailing: VEyebrowNote(
                  'avg ${VFormat.minutes(total ~/ 7)} a day',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                VFormat.minutes(total),
                style: VText.doto(44, weight: 900, height: 1),
              ),
              const SizedBox(height: 12),
              VBarChart(
                values: perDay.map((m) => m.toDouble()).toList(),
                labels: labels,
                limit: limit.toDouble(),
                highlight: 6,
              ),
              const SizedBox(height: 12),
              Text(
                'Dashed line is your ${VFormat.minutes(limit)} limit',
                style: VText.secondary,
              ),
            ],
          ),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VEyebrow(
                'Water',
                trailing: VEyebrowNote(
                  '${water.fold<int>(0, (s, d) => s + d.glasses)} of '
                  '${water.fold<int>(0, (s, d) => s + d.goal)} glasses',
                ),
              ),
              const SizedBox(height: 12),
              for (final (i, day) in water.indexed) ...[
                if (i > 0) const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Text(
                        VFormat.dayAbbrev(day.date),
                        style: VText.inter(12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    VDots(
                      filled: day.glasses,
                      total: day.goal,
                      size: 10,
                      gap: 5,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (nights.isNotEmpty)
          VCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VEyebrow(
                  'Sleep',
                  trailing: VEyebrowNote(
                    'avg ${VFormat.hm(_average(nights.map((n) => n.actual)))}',
                  ),
                ),
                const SizedBox(height: 12),
                VPairChart(
                  planned: [
                    for (final n in nights) n.planned.inMinutes.toDouble(),
                  ],
                  actual: [
                    for (final n in nights) n.actual.inMinutes.toDouble(),
                  ],
                  labels: [for (final n in nights) VFormat.dayLetter(n.date)],
                ),
              ],
            ),
          ),
        if (nudges != null)
          VCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VEyebrow('Nudges'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${nudges.accepted}/${nudges.shown}',
                        style: VText.doto(36, weight: 900, height: 1),
                      ),
                    ),
                    VDots(
                      filled: nudges.accepted,
                      total: nudges.shown,
                      size: 12,
                      gap: 4,
                      square: true,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'You put the phone down ${nudges.accepted} times when asked.',
                  style: VText.secondary,
                ),
                const SizedBox(height: 4),
                Text(
                  nudges.overrides == 0
                      ? 'No emergency overrides used.'
                      : '${nudges.overrides} emergency '
                            '${nudges.overrides == 1 ? 'override' : 'overrides'} used.',
                  style: VText.secondary,
                ),
              ],
            ),
          ),
      ],
    );
  }

  static Duration _average(Iterable<Duration> values) {
    if (values.isEmpty) return Duration.zero;
    final total = values.fold<int>(0, (s, d) => s + d.inMinutes);
    return Duration(minutes: total ~/ values.length);
  }
}

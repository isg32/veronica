import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_controls.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_page.dart';
import '../../core/widgets/v_progress.dart';
import '../../core/widgets/v_surface.dart';
import '../../core/widgets/v_tiles.dart';
import '../../core/widgets/v_wheel.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import 'watch_apps_list.dart';

/// One watched app: its week, daily limit, nudge point and block rules.
class AppDetailPage extends ConsumerWidget {
  const AppDetailPage({super.key, required this.packageName});

  final String packageName;

  static final _limits = [for (var m = 5; m <= 240; m += 5) m];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(watchedAppsProvider).value ?? const <WatchedApp>[];
    final app = apps.where((a) => a.packageName == packageName).firstOrNull;
    final water = ref.watch(waterWeekProvider).value ?? const <WaterDay>[];
    if (app == null) {
      return const VDetailPage(
        backLabel: 'Focus',
        title: 'App',
        children: [VFootnote('This app is no longer watched.')],
      );
    }
    final repo = ref.read(usageRepositoryProvider);
    final labels = water.length == 7
        ? water.map((d) => VFormat.dayLetter(d.date)).toList()
        : const ['S', 'S', 'M', 'T', 'W', 'T', 'F'];

    return VDetailPage(
      backLabel: 'Focus',
      title: app.name,
      action: VAppTile(app.name),
      children: [
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Text(
                      '${app.minutesToday} min',
                      style: VText.doto(44, weight: 900, height: 1),
                    ),
                  ),
                  Text(
                    'of ${app.dailyLimitMin} today',
                    style: VText.inter(13, weight: 300),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (app.lastSevenDays.length == 7)
                VBarChart(
                  values: app.lastSevenDays.map((m) => m.toDouble()).toList(),
                  labels: labels,
                  limit: app.dailyLimitMin.toDouble(),
                  highlight: 6,
                ),
            ],
          ),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VEyebrow('Daily limit', trailing: VEyebrowNote('minutes')),
              const SizedBox(height: 12),
              VWheelFrame(
                child: VWheel(
                  values: _limits,
                  selected: app.dailyLimitMin,
                  format: (v) => '$v',
                  width: 120,
                  onChanged: (v) => repo.update(app.copyWith(dailyLimitMin: v)),
                ),
              ),
            ],
          ),
        ),
        VListSection(
          children: [
            VListRow(
              title: 'Nudge at',
              subtitle: 'A soft notification',
              trailing: VSegmented<int>(
                compact: true,
                segments: const {50: '50', 80: '80', 90: '90%'},
                value: app.nudgeAtPercent,
                onChanged: (v) => repo.update(app.copyWith(nudgeAtPercent: v)),
              ),
            ),
            VListRow(
              title: 'Hard block',
              subtitle: 'Close the app at 100%',
              trailing: VSwitch(
                value: app.hardBlock,
                onChanged: (v) => repo.update(app.copyWith(hardBlock: v)),
              ),
            ),
            VListRow(
              title: '5 more minutes',
              subtitle: 'Allowed per day',
              trailing: VSegmented<int>(
                compact: true,
                segments: const {0: '0', 1: '1', 2: '2'},
                value: app.extensionsPerDay,
                onChanged: (v) =>
                    repo.update(app.copyWith(extensionsPerDay: v)),
              ),
            ),
          ],
        ),
        if (app.hardBlock)
          const VFootnote(
            'Long-press "Put it down" for an emergency 5 minutes. '
            'It is logged in your weekly summary.',
          ),
        VButton.ghost(
          'Remove app',
          onPressed: () async {
            await repo.unwatch(app.packageName);
            if (context.mounted) context.pop();
          },
        ),
      ],
    );
  }
}

/// "Add app": pick more apps to watch.
class AppPickerPage extends StatelessWidget {
  const AppPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const VDetailPage(
      backLabel: 'Focus',
      title: 'Watch apps',
      children: [
        WatchAppsList(),
        VFootnote('New apps start with a 30 min daily limit.'),
      ],
    );
  }
}

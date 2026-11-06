import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/format.dart';
import '../../core/theme/v_colors.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_ink.dart';
import '../../core/widgets/v_progress.dart';
import '../../core/widgets/v_tiles.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../selectors.dart';

part 'home_widget_views.g.dart';

/// The six home-screen widgets, on Nothing's 4-column grid of 76 dp cells.
///
/// The same views are drawn in the Settings preview and, rendered to
/// transparent PNGs, shown by the native Android widgets.
enum HomeWidgetKind {
  screenTime(2, 2, 'ScreenTimeWidget', 'Screen time'),
  water(2, 1, 'WaterWidget', 'Water'),
  nextAlarm(2, 1, 'NextAlarmWidget', 'Next alarm'),
  modeSwitch(4, 1, 'ModeSwitchWidget', 'Mode switch'),
  oldestTasks(4, 2, 'OldestTasksWidget', 'Oldest tasks'),
  mantra(4, 1, 'MantraWidget', 'Mantra');

  const HomeWidgetKind(this.cols, this.rows, this.androidClass, this.label);

  final int cols;
  final int rows;

  /// The AppWidgetProvider class in `com.isg32.veronica.widgets`.
  final String androidClass;
  final String label;

  static const double cell = 76;
  static const double gap = 8;

  static double span(int cells) => cells * cell + (cells - 1) * gap;

  Size get size => Size(span(cols), span(rows));

  /// Shared-preferences key for the rendered image path.
  String get imageKey => 'widget_${name}_image';

  String get qualifiedAndroidName => 'com.isg32.veronica.widgets.$androidClass';

  /// `2×1`.
  String get sizeLabel => '$cols×$rows';
}

/// One mode pill on the mode-switch widget.
class WidgetMode {
  const WidgetMode({
    required this.id,
    required this.label,
    required this.active,
    this.left,
  });

  final String id;
  final String label;
  final bool active;

  /// Time left for a timed mode, e.g. "38 min".
  final String? left;
}

/// One row on the oldest-tasks widget.
class WidgetTask {
  const WidgetTask({
    required this.id,
    required this.title,
    required this.ageDays,
  });

  final String id;
  final String title;
  final int ageDays;
}

/// Everything the widgets show, taken from the repositories at one moment.
class HomeWidgetSnapshot {
  const HomeWidgetSnapshot({
    required this.usedMin,
    required this.limitMin,
    required this.water,
    required this.waterGoal,
    required this.alarmTime,
    required this.alarmIn,
    required this.modes,
    required this.tasks,
    required this.mantra,
  });

  final int usedMin;
  final int limitMin;
  final int water;
  final int waterGoal;

  /// `07:00`, or null when no alarm is on.
  final String? alarmTime;

  /// `9h 56m`.
  final String? alarmIn;
  final List<WidgetMode> modes;
  final List<WidgetTask> tasks;
  final String? mantra;

  /// Compared to decide whether the widgets need re-rendering.
  String get signature => [
    usedMin,
    limitMin,
    water,
    waterGoal,
    alarmTime,
    alarmIn,
    for (final m in modes) '${m.id}:${m.active}:${m.left}',
    for (final t in tasks) '${t.id}:${t.title}:${t.ageDays}',
    mantra,
  ].join('|');
}

/// The widget data right now. Times are rounded to the minute so the native
/// widgets don't need re-rendering every second.
@riverpod
HomeWidgetSnapshot homeWidgetSnapshot(Ref ref) {
  final apps = ref.watch(watchedAppsProvider).value ?? const <WatchedApp>[];
  final now = ref.watch(currentTimeProvider);
  final next = ref.watch(nextAlarmProvider);
  final modes = ref.watch(modesProvider).value ?? const <Mode>[];
  final active = ref.watch(activeModeProvider).value;

  String? left(Mode m) {
    if (active?.modeId != m.id || active?.endsAt == null) return null;
    final d = active!.endsAt!.difference(now);
    return d.isNegative ? 'ended' : '${(d.inSeconds / 60).ceil()} min';
  }

  return HomeWidgetSnapshot(
    usedMin: apps.fold<int>(0, (s, a) => s + a.minutesToday),
    limitMin: apps.fold<int>(0, (s, a) => s + a.dailyLimitMin),
    water: ref.watch(waterTodayProvider).value?.length ?? 0,
    waterGoal: ref.watch(waterSettingsProvider).value?.goalGlasses ?? 8,
    alarmTime: next?.alarm.time.label,
    alarmIn: next == null ? null : VFormat.hm(next.at.difference(now)),
    modes: [
      for (final m in modes.where((m) => m.isPreset))
        WidgetMode(
          id: m.id,
          label: m.name.replaceAll(' Time', ''),
          active: m.id == active?.modeId,
          left: left(m),
        ),
    ],
    tasks: [
      for (final t in ref.watch(openTasksOldestFirstProvider).take(3))
        WidgetTask(id: t.id, title: t.title, ageDays: t.ageDays(now)),
    ],
    mantra: ref.watch(todayMantraProvider)?.text,
  );
}

/// Draws one home-screen widget at its grid size in tinted glass: black at
/// 40 % with white ink ([light] false), or white at 50 % with black ink.
class HomeWidgetView extends StatelessWidget {
  const HomeWidgetView({
    super.key,
    required this.kind,
    required this.data,
    required this.light,
  });

  final HomeWidgetKind kind;
  final HomeWidgetSnapshot data;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final ink = light ? VColors.black : VColors.white;
    return VInkScope(
      ink: ink,
      child: SizedBox.fromSize(size: kind.size, child: _content()),
    );
  }

  Color get _tint => light ? VColors.widgetLight : VColors.widgetDark;

  /// The solid fill that marks the action or the active state.
  Color get _solid => light ? VColors.white : VColors.black;

  Widget _box(
    double radius,
    Widget child, {
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _tint,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }

  Widget _content() {
    switch (kind) {
      case HomeWidgetKind.screenTime:
        final size = kind.size.width;
        return Container(
          decoration: BoxDecoration(color: _tint, shape: BoxShape.circle),
          child: VRing(
            value: data.limitMin == 0 ? 0 : data.usedMin / data.limitMin,
            size: size,
            strokeWidth: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SCREEN TIME',
                  style: VText.inter(10, weight: 500, letterSpacing: 1),
                ),
                Text(
                  VFormat.minutes(data.usedMin),
                  style: VText.doto(28, weight: 900, height: 1.1),
                ),
                Text(
                  'of ${VFormat.minutes(data.limitMin)}',
                  style: VText.inter(11),
                ),
              ],
            ),
          ),
        );

      case HomeWidgetKind.water:
        return _box(
          38,
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data.water}/${data.waterGoal}',
                      style: VText.doto(16, height: 1),
                    ),
                    const SizedBox(height: 7),
                    VDots(
                      filled: data.water,
                      total: data.waterGoal,
                      size: 9,
                      gap: 4,
                      columns: 4,
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _solid,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text('+1', style: VText.doto(20, weight: 900)),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(18, 0, 8, 0),
        );

      case HomeWidgetKind.nextAlarm:
        return _box(
          30,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.alarmTime ?? '--:--',
                style: VText.doto(28, weight: 900, height: 1),
              ),
              const SizedBox(height: 3),
              Text(
                data.alarmIn == null ? 'No alarm' : 'Alarm · ${data.alarmIn}',
                style: VText.inter(11),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
        );

      case HomeWidgetKind.modeSwitch:
        return _box(
          38,
          Row(
            children: [
              for (final m in data.modes)
                Expanded(
                  flex: m.active ? 12 : 10,
                  child: Container(
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: m.active ? _solid : VColors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          m.label,
                          style: VText.inter(13, weight: m.active ? 600 : 500),
                        ),
                        if (m.left != null)
                          Text(m.left!, style: VText.doto(13)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          padding: const EdgeInsets.all(5),
        );

      case HomeWidgetKind.oldestTasks:
        return _box(
          44,
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'OLDEST TASKS',
                style: VText.inter(10, weight: 500, letterSpacing: 1),
              ),
              if (data.tasks.isEmpty)
                Text('Nothing waiting.', style: VText.inter(14)),
              for (final t in data.tasks)
                Row(
                  children: [
                    VTaskCheck(ageDays: t.ageDays, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        t.title,
                        style: VText.inter(14, weight: 500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(VFormat.ageShort(t.ageDays), style: VText.doto(15)),
                  ],
                ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
        );

      case HomeWidgetKind.mantra:
        return _box(
          38,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MANTRA',
                style: VText.inter(10, weight: 500, letterSpacing: 1),
              ),
              const SizedBox(height: 3),
              Text(
                data.mantra ?? 'Add a mantra in Care',
                style: VText.inter(16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 26),
        );
    }
  }
}

import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/format.dart';
import '../../core/icons/v_icons.dart';
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

  /// Shared-preferences key for the rendered image path. Both variants are
  /// rendered; Android shows the one matching the system theme.
  String imageKey({required bool light}) =>
      'widget_${name}_${light ? 'light' : 'dark'}_image';

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
    this.endsAt,
  });

  final String id;
  final String label;
  final bool active;

  /// When a timed mode (Binge Time) ends.
  final DateTime? endsAt;

  /// "38 min" left at [now], or "ended".
  String? leftAt(DateTime now) {
    final end = endsAt;
    if (!active || end == null) return null;
    final d = end.difference(now);
    return d.isNegative ? 'ended' : '${(d.inSeconds / 60).ceil()} min';
  }
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
    required this.alarmAt,
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

  /// When the next alarm rings.
  final DateTime? alarmAt;

  /// "in 9 h" (whole hours from two hours out), else "in 1h 35m" to the
  /// 5 minutes, at [now]; frames are rendered at those steps.
  String? alarmInAt(DateTime now) {
    final at = alarmAt;
    if (at == null) return null;
    final d = at.difference(now);
    if (d.isNegative) return 'now';
    if (d.inHours >= 2) return 'in ${d.inHours} h';
    final m = (d.inMinutes ~/ 5) * 5;
    return 'in ${VFormat.minutes(m)}';
  }

  final List<WidgetMode> modes;
  final List<WidgetTask> tasks;
  final String? mantra;

  /// The same moment with [water] glasses, or [active] as the running
  /// mode (its index, or -1 for none): states the widget can reach from a
  /// tap before the app has drawn it again.
  HomeWidgetSnapshot variant({int? water, int? active}) => HomeWidgetSnapshot(
    usedMin: usedMin,
    limitMin: limitMin,
    water: water ?? this.water,
    waterGoal: waterGoal,
    alarmTime: alarmTime,
    alarmAt: alarmAt,
    modes: active == null
        ? modes
        : [
            for (final (i, m) in modes.indexed)
              WidgetMode(
                id: m.id,
                label: m.label,
                active: i == active,
                // Only the mode really running knows when it ends.
                endsAt: i == active && m.active ? m.endsAt : null,
              ),
          ],
    tasks: tasks,
    mantra: mantra,
  );

  /// Compared to decide whether the widgets need re-rendering.
  String get signature => [
    usedMin,
    limitMin,
    water,
    waterGoal,
    alarmTime,
    alarmAt?.millisecondsSinceEpoch,
    for (final m in modes)
      '${m.id}:${m.active}:${m.endsAt?.millisecondsSinceEpoch}',
    for (final t in tasks) '${t.id}:${t.title}:${t.ageDays}',
    mantra,
  ].join('|');
}

/// The widget data right now. Times are rounded to the minute so the native
/// widgets don't need re-rendering every second.
@riverpod
HomeWidgetSnapshot homeWidgetSnapshot(Ref ref) {
  final apps = ref.watch(watchedAppsProvider).value ?? const <WatchedApp>[];
  final now = ref.watch(currentMinuteProvider);
  final next = ref.watch(nextAlarmProvider);
  final modes = ref.watch(modesProvider).value ?? const <Mode>[];
  final active = ref.watch(activeModeProvider).value;

  return HomeWidgetSnapshot(
    usedMin: apps.fold<int>(0, (s, a) => s + a.minutesToday),
    limitMin: apps.fold<int>(0, (s, a) => s + a.dailyLimitMin),
    water: ref.watch(waterTodayProvider).value?.length ?? 0,
    waterGoal: ref.watch(waterSettingsProvider).value?.goalGlasses ?? 8,
    alarmTime: next?.alarm.time.label,
    alarmAt: next?.at,
    modes: [
      for (final m in modes.where((m) => m.isPreset))
        WidgetMode(
          id: m.id,
          label: m.name.replaceAll(' Time', ''),
          active: m.id == active?.modeId,
          endsAt: m.id == active?.modeId ? active?.endsAt : null,
        ),
    ],
    tasks: [
      for (final t
          in ref.watch(openTasksOldestFirstProvider).take(TaskRows.rendered))
        WidgetTask(id: t.id, title: t.title, ageDays: t.ageDays(now)),
    ],
    mantra: ref.watch(todayMantraProvider)?.text,
  );
}

/// The wallpaper behind a widget, for the fake frosted-glass blur.
class WidgetBackdrop {
  const WidgetBackdrop({
    required this.wallpaper,
    required this.screen,
    required this.topLeft,
  });

  /// The wallpaper as the launcher shows it, covering the whole screen.
  final ui.Image wallpaper;

  /// Screen size in logical pixels.
  final Size screen;

  /// Where the widget's top-left corner sits on the screen, logical pixels.
  final Offset topLeft;

  static const double sigma = 22;
}

/// Draws one home-screen widget at its grid size in glass: black at 40 %
/// with white ink ([light] false), or white at 50 % with black ink. With a
/// [backdrop], the wallpaper behind the widget is blurred under the tint.
class HomeWidgetView extends StatelessWidget {
  const HomeWidgetView({
    super.key,
    required this.kind,
    required this.data,
    required this.light,
    this.backdrop,
    this.now,
    this.tasksBackgroundOnly = false,
  });

  /// Oldest tasks without its rows: Android lays the rows (rendered one by
  /// one with [HomeWidgetTaskRow]) over it, so finishing a task from the
  /// widget can hide its row straight away.
  final bool tasksBackgroundOnly;

  final HomeWidgetKind kind;
  final HomeWidgetSnapshot data;
  final bool light;
  final WidgetBackdrop? backdrop;

  /// The moment to draw for (a future frame), or the current time.
  final DateTime? now;

  DateTime get at => now ?? DateTime.now();

  @override
  Widget build(BuildContext context) {
    final ink = light ? VColors.black : VColors.white;
    return VInkScope(
      ink: ink,
      child: SizedBox.fromSize(size: kind.size, child: _content()),
    );
  }

  Color get _ink => light ? VColors.black : VColors.white;

  Color get _tint => light ? VColors.widgetLight : VColors.widgetDark;

  /// The solid fill that marks the action or the active state.
  Color get _solid => light ? VColors.white : VColors.black;

  Widget _box(
    double radius,
    Widget child, {
    EdgeInsets padding = EdgeInsets.zero,
  }) => _glass(BorderRadius.circular(radius), child, padding: padding);

  /// Tinted glass in a rounded rectangle, or a circle when [radius] is null,
  /// over the blurred wallpaper when there is a [backdrop].
  Widget _glass(
    BorderRadius? radius,
    Widget child, {
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    final glass = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _tint,
        borderRadius: radius,
        shape: radius == null ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: child,
    );
    final b = backdrop;
    if (b == null) return glass;

    final layers = Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          left: -b.topLeft.dx,
          top: -b.topLeft.dy,
          width: b.screen.width,
          height: b.screen.height,
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(
              sigmaX: WidgetBackdrop.sigma,
              sigmaY: WidgetBackdrop.sigma,
              tileMode: TileMode.clamp,
            ),
            child: RawImage(image: b.wallpaper, fit: BoxFit.fill),
          ),
        ),
        glass,
      ],
    );
    return radius == null
        ? ClipOval(child: layers)
        : ClipRRect(borderRadius: radius, child: layers);
  }

  Widget _content() {
    switch (kind) {
      case HomeWidgetKind.screenTime:
        final size = kind.size.width;
        return _glass(
          null,
          VRing(
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
                data.alarmAt == null
                    ? 'No alarm'
                    : 'Alarm · ${data.alarmInAt(at)}',
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
                        if (m.leftAt(at) case final left?)
                          Text(left, style: VText.doto(13)),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: TaskRows.header,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'OLDEST TASKS',
                          style: VText.inter(10, weight: 500, letterSpacing: 1),
                        ),
                      ),
                      // Add a task, from the widget.
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _ink),
                        ),
                        alignment: Alignment.center,
                        child: const VIconView(
                          VIcon.plus,
                          size: 14,
                          strokeWidth: 1.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (data.tasks.isEmpty)
                SizedBox(
                  height: TaskRows.row,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Nothing waiting.', style: VText.inter(14)),
                    ),
                  ),
                ),
              if (!tasksBackgroundOnly)
                for (final t in data.tasks.take(TaskRows.shown))
                  HomeWidgetTaskRow(task: t),
            ],
          ),
        );

      case HomeWidgetKind.mantra:
        return _box(
          38,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TODAY'S QUOTE",
                style: VText.inter(10, weight: 500, letterSpacing: 1),
              ),
              const SizedBox(height: 3),
              Text(
                data.mantra ?? 'Add a quote in Care',
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

/// The geometry of the oldest-tasks widget (4×2, 160 tall): a header band,
/// three rows and a bottom margin. The native layout uses the same
/// proportions to place the rows and their tap areas.
abstract final class TaskRows {
  static const double header = 40;
  static const double row = 36;
  static const double footer = 12;
  static const int shown = 3;

  /// Rows rendered for Android: when some are finished from the widget, the
  /// next ones move up without waiting for the app.
  static const int rendered = 6;
}

/// One task row of the oldest-tasks widget, on a transparent background.
class HomeWidgetTaskRow extends StatelessWidget {
  const HomeWidgetTaskRow({super.key, required this.task});

  final WidgetTask task;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: HomeWidgetKind.oldestTasks.size.width,
    height: TaskRows.row,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          VTaskCheck(ageDays: task.ageDays, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.title,
              style: VText.inter(14, weight: 500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(VFormat.ageShort(task.ageDays), style: VText.doto(15)),
        ],
      ),
    ),
  );
}

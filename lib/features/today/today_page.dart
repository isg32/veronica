import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/format.dart';
import '../../core/icons/v_icons.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_page.dart';
import '../../core/widgets/v_progress.dart';
import '../../core/widgets/v_surface.dart';
import '../../core/widgets/v_tiles.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../focus/setup_banner.dart';
import '../selectors.dart';
import 'mode_switch_sheet.dart';

/// Tab 1: the day at a glance.
class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(currentMinuteProvider);
    final name = ref.watch(profileProvider).value?.name ?? '';
    final greeting = VFormat.greeting(now);

    return VTabPage(
      eyebrow: VFormat.eyebrowDate(now),
      title: name.isEmpty ? greeting : '$greeting, $name',
      trailing: VCircleButton(
        icon: VIcon.gear,
        onTap: () => context.push(Routes.settings),
      ),
      children: const [
        SetupBanner(),
        _ModeCard(),
        _ScreenTimeCard(),
        _WaterCard(),
        _NextUpCard(),
        _OldestTasksCard(),
        _MantraStrip(),
        _WeeklyLink(),
      ],
    );
  }
}

class _ModeCard extends ConsumerWidget {
  const _ModeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeModeProvider).value;
    final modes = ref.watch(modesProvider).value ?? const <Mode>[];
    final now = ref.watch(currentTimeProvider);
    final mode = active == null
        ? null
        : modes.where((m) => m.id == active.modeId).firstOrNull;

    final String status;
    if (mode == null || active == null) {
      status = 'No mode running';
    } else if (active.endsAt != null) {
      final left = active.endsAt!.difference(now);
      status = left.isNegative
          ? "Time's up · put it down"
          : '${VFormat.clock(left)} left · then put it down';
    } else {
      status = 'Since ${VFormat.time(active.startedAt)}';
    }

    return VCard(
      inverted: mode != null,
      onTap: mode == null ? null : () => context.push(Routes.activeMode),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MODE', style: VText.eyebrow),
                const SizedBox(height: 4),
                Text(
                  (mode?.name ?? 'None').toUpperCase(),
                  style: VText.doto(26, weight: 900, height: 1),
                ),
                const SizedBox(height: 4),
                Text(status, style: VText.inter(13)),
              ],
            ),
          ),
          VPill(
            'Switch',
            style: VText.inter(13, weight: 600),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            onTap: () => showModeSwitchSheet(context, ref),
          ),
        ],
      ),
    );
  }
}

class _ScreenTimeCard extends ConsumerWidget {
  const _ScreenTimeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(watchedAppsProvider).value ?? const <WatchedApp>[];
    final used = apps.fold<int>(0, (s, a) => s + a.minutesToday);
    final limit = apps.fold<int>(0, (s, a) => s + a.dailyLimitMin);
    final top = [...apps]
      ..sort((a, b) => b.minutesToday.compareTo(a.minutesToday));

    return VCard(
      onTap: () => context.go(Routes.focus),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VRing(value: limit == 0 ? 0 : used / limit, size: 96),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SCREEN TIME', style: VText.eyebrow),
                    const SizedBox(height: 4),
                    Text(
                      VFormat.minutes(used),
                      style: VText.doto(38, height: 1),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'of ${VFormat.minutes(limit)} across ${VFormat.count(apps.length, 'app')}',
                      style: VText.inter(13, weight: 300),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (top.isNotEmpty) ...[
            const SizedBox(height: 14),
            const VDivider(),
            const SizedBox(height: 14),
            for (final (i, app) in top.take(3).indexed) ...[
              if (i > 0) const SizedBox(height: 10),
              _AppBarRow(app),
            ],
          ],
        ],
      ),
    );
  }
}

class _AppBarRow extends StatelessWidget {
  const _AppBarRow(this.app);

  final WatchedApp app;

  @override
  Widget build(BuildContext context) {
    final label = '${app.minutesToday}/${app.dailyLimitMin}';
    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            app.name,
            style: VText.inter(13, weight: 500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: VBar(value: app.progress)),
        const SizedBox(width: 10),
        app.isOver
            ? VPill.badge(label)
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                child: Text(label, style: VText.inter(12)),
              ),
      ],
    );
  }
}

class _WaterCard extends ConsumerWidget {
  const _WaterCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(waterTodayProvider).value ?? const <WaterLog>[];
    final goal = ref.watch(waterSettingsProvider).value?.goalGlasses ?? 8;

    return VCard(
      onTap: () => context.go(Routes.care),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(child: Text('WATER', style: VText.eyebrow)),
              Text('${logs.length}/$goal', style: VText.doto(22)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: VDots(
                  filled: logs.length,
                  total: goal,
                  size: 16,
                  gap: 8,
                ),
              ),
              const SizedBox(width: 8),
              VPill(
                '+1 glass',
                fill: VFill.filled,
                style: VText.inter(13, weight: 600),
                onTap: () => ref.read(waterRepositoryProvider).logGlass(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextUpCard extends ConsumerWidget {
  const _NextUpCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(nextUpProvider);
    if (items.isEmpty) return const SizedBox.shrink();
    return VCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Text('NEXT UP', style: VText.eyebrow),
          ),
          for (final (i, item) in items.indexed) ...[
            if (i > 0) const VDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(child: Text(item.label, style: VText.inter(14))),
                  Text(VFormat.time(item.at), style: VText.doto(16)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OldestTasksCard extends ConsumerWidget {
  const _OldestTasksCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final open = ref.watch(openTasksOldestFirstProvider);
    final now = ref.watch(currentMinuteProvider);
    if (open.isEmpty) return const SizedBox.shrink();

    return VCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      onTap: () => context.go(Routes.tasks),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: VEyebrow(
              'Oldest tasks',
              trailing: Text('All ${open.length} ›', style: VText.inter(11)),
            ),
          ),
          for (final (i, task) in open.take(3).indexed) ...[
            if (i > 0) const VDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  VTaskCheck(ageDays: task.ageDays(now), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.title, style: VText.inter(14, weight: 500)),
                        const SizedBox(height: 2),
                        Text(
                          VFormat.added(task.ageDays(now)),
                          style: VText.inter(12, weight: 300),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MantraStrip extends ConsumerWidget {
  const _MantraStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mantra = ref.watch(todayMantraProvider);
    if (mantra == null) return const SizedBox.shrink();
    return VCard(
      outline: VOutline.dashed,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: () => context.push(Routes.mantraSession),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("TODAY'S QUOTE", style: VText.eyebrow),
                const SizedBox(height: 3),
                Text(mantra.text, style: VText.inter(15)),
              ],
            ),
          ),
          const VIconView(VIcon.chevron, size: 16, strokeWidth: 1.6),
        ],
      ),
    );
  }
}

class _WeeklyLink extends ConsumerWidget {
  const _WeeklyLink();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accepted = ref.watch(weekNudgesProvider).value?.accepted ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: VLink(
                'Weekly summary',
                onTap: () => context.push(Routes.weekly),
              ),
            ),
          ),
          Text(
            '$accepted nudges accepted',
            style: VText.inter(12, weight: 300),
          ),
        ],
      ),
    );
  }
}

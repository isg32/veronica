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
import '../../core/widgets/v_progress.dart';
import '../../core/widgets/v_surface.dart';
import '../../core/widgets/v_tiles.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../selectors.dart';
import 'mode_labels.dart';
import 'setup_banner.dart';

enum _FocusView { usage, modes }

/// Tab 2: watched apps and modes.
class FocusPage extends StatefulWidget {
  const FocusPage({super.key, this.showModes = false});

  /// Open on Modes (from the quick-settings tile).
  final bool showModes;

  @override
  State<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  late _FocusView _view = widget.showModes
      ? _FocusView.modes
      : _FocusView.usage;

  @override
  void didUpdateWidget(FocusPage old) {
    super.didUpdateWidget(old);
    if (widget.showModes && !old.showModes) _view = _FocusView.modes;
  }

  @override
  Widget build(BuildContext context) {
    return VTabPage(
      title: 'Focus',
      header: VSegmented<_FocusView>(
        segments: const {_FocusView.usage: 'Usage', _FocusView.modes: 'Modes'},
        value: _view,
        onChanged: (v) => setState(() => _view = v),
      ),
      children: _view == _FocusView.usage
          ? const [_UsageView()]
          : const [_ModesView()],
    );
  }
}

class _UsageView extends ConsumerWidget {
  const _UsageView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(watchedAppsProvider).value ?? const <WatchedApp>[];
    final used = apps.fold<int>(0, (s, a) => s + a.minutesToday);
    final limit = apps.fold<int>(0, (s, a) => s + a.dailyLimitMin);
    final left = limit - used;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(padding: EdgeInsets.only(top: 16), child: SetupBanner()),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 24, 4, 16),
          child: Column(
            children: [
              Text('WATCHED APPS TODAY', style: VText.eyebrow),
              const SizedBox(height: 6),
              Text(
                VFormat.minutes(used),
                style: VText.doto(64, weight: 900, height: 1),
              ),
              const SizedBox(height: 6),
              Text(
                left >= 0
                    ? '${VFormat.minutes(left)} left in your limits'
                    : '${VFormat.minutes(-left)} over your limits',
                style: VText.inter(13, weight: 300),
              ),
            ],
          ),
        ),
        VListSection(
          children: [
            for (final app in apps)
              VTappable(
                onTap: () => context.push(Routes.app(app.packageName)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      VAppTile(app.name),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Expanded(
                                  child: Text(
                                    app.name,
                                    style: VText.inter(14, weight: 500),
                                  ),
                                ),
                                Text(
                                  '${app.minutesToday} / ${app.dailyLimitMin} min',
                                  style: VText.inter(12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            VBar(value: app.progress),
                          ],
                        ),
                      ),
                      if (app.isOver) ...[
                        const SizedBox(width: 12),
                        VPill.badge('+${app.minutesOver}'),
                      ],
                    ],
                  ),
                ),
              ),
            VTappable(
              onTap: () => context.push(Routes.addApp),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const VAppTile(
                      '',
                      dashed: true,
                      child: VIconView(VIcon.plus, size: 16, strokeWidth: 1.6),
                    ),
                    const SizedBox(width: 10),
                    Text('Add app', style: VText.inter(14, weight: 500)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const VFootnote('Soft nudge at 80%. "Put it down" card at 100%.'),
      ],
    );
  }
}

class _ModesView extends ConsumerWidget {
  const _ModesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modes = ref.watch(modesProvider).value ?? const <Mode>[];
    final active = ref.watch(activeModeProvider).value;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final mode in modes) ...[
            _ModeCard(
              mode: mode,
              active: active?.modeId == mode.id ? active : null,
            ),
            const SizedBox(height: 12),
          ],
          VCard(
            outline: VOutline.dashed,
            radius: 24,
            padding: const EdgeInsets.all(18),
            onTap: () => context.push(Routes.mode(Routes.newModeId)),
            child: Row(
              children: [
                const VIconView(VIcon.plus, size: 18, strokeWidth: 1.6),
                const SizedBox(width: 10),
                Text('New mode', style: VText.inter(15, weight: 500)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const VFootnote(
            'Tap to start. Long-press to edit. Sleep wind-down overrides any mode.',
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends ConsumerWidget {
  const _ModeCard({required this.mode, this.active});

  final Mode mode;
  final ActiveMode? active;

  Future<void> _start(BuildContext context, WidgetRef ref) async {
    await ref
        .read(modeRepositoryProvider)
        .start(
          mode.id,
          minutes: mode.timer == ModeTimer.fixed ? mode.timerMin : null,
        );
    if (context.mounted) await context.push(Routes.activeMode);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final running = active != null;
    final now = ref.watch(currentTimeProvider);
    final progress = running ? ModeProgress.of(mode, active!, now) : null;
    final total = running && active!.endsAt != null
        ? active!.endsAt!.difference(active!.startedAt)
        : null;

    return VCard(
      inverted: running,
      radius: 24,
      padding: const EdgeInsets.all(18),
      onTap: running
          ? () => context.push(Routes.activeMode)
          : () => _start(context, ref),
      onLongPress: () => context.push(Routes.mode(mode.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mode.name.toUpperCase(),
                      style: VText.doto(30, weight: 900, height: 1),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      running
                          ? total != null
                                ? 'Running · ${progress!.display} left of ${VFormat.clock(total)}'
                                : 'Running · ${progress!.display}'
                          : ModeLabels.subtitle(mode),
                      style: VText.inter(13, weight: running ? 400 : 300),
                    ),
                  ],
                ),
              ),
              running
                  ? const VPill.badge('On')
                  : VPill(
                      'Start',
                      style: VText.inter(12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      onTap: () => _start(context, ref),
                    ),
            ],
          ),
          if (running && total != null) ...[
            const SizedBox(height: 14),
            VBar(value: 1 - progress!.ringValue),
          ],
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final chip in ModeLabels.chips(mode))
                VPill(
                  chip.label,
                  fill: chip.off ? VFill.dashed : VFill.outline,
                  style: VText.chip,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/v_ink.dart';
import '../../app/routes.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_progress.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../selectors.dart';
import '../settings/greyscale_by_hand.dart';
import 'mode_labels.dart';

/// Full black page while a mode runs: big countdown (or elapsed time), the
/// Pomodoro ring in Work, and "End mode".
class ActiveModePage extends ConsumerWidget {
  const ActiveModePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeModeProvider).value;
    final modes = ref.watch(modesProvider).value ?? const <Mode>[];
    final now = ref.watch(currentTimeProvider);
    final mode = active == null
        ? null
        : modes.where((m) => m.id == active.modeId).firstOrNull;

    ref.listen(currentTimeProvider, (_, now) {
      final a = ref.read(activeModeProvider).value;
      if (a?.endsAt != null && !now.isBefore(a!.endsAt!)) {
        context.pushReplacement(Routes.timesUp);
      }
    });

    if (mode == null || active == null) {
      return CupertinoPageScaffold(
        backgroundColor: VInk.surfaceOf(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                Text('No mode running', style: VText.doto(28, weight: 900)),
                const Spacer(),
                VButton.secondary('Back', onPressed: () => context.pop()),
              ],
            ),
          ),
        ),
      );
    }

    final p = ModeProgress.of(mode, active, now);
    return CupertinoPageScaffold(
      backgroundColor: VInk.surfaceOf(context),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Column(
                children: [
                  if (p.eyebrow != null)
                    Text(
                      p.eyebrow!,
                      style: VText.inter(11, weight: 500, letterSpacing: 1.5),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    mode.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: VText.doto(40, weight: 900, height: 1),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: VRing(
                  value: p.ringValue,
                  size: 260,
                  strokeWidth: 6,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        p.display,
                        style: VText.doto(64, weight: 900, height: 1),
                      ),
                      const SizedBox(height: 6),
                      Text(p.caption, style: VText.inter(13, weight: 300)),
                    ],
                  ),
                ),
              ),
            ),
            Wrap(
              spacing: 6,
              children: [
                for (final c in ModeLabels.activeChips(mode))
                  VPill(
                    c,
                    style: VText.chip,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                  ),
              ],
            ),
            // Without the greyscale grant, a one-tap way to the setting.
            if (mode.greyscale &&
                !(ref.watch(adbStatusProvider).value?.greyscaleGranted ?? true))
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 18, 24, 0),
                child: VButton.ghost(
                  'Turn on greyscale',
                  onPressed: openColorCorrection,
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 40),
              child: VButton.secondary(
                'End mode',
                onPressed: () async {
                  await ref.read(modeRepositoryProvider).end();
                  if (context.mounted) context.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

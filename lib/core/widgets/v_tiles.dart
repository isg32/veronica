import 'package:flutter/widgets.dart';

import '../theme/v_text.dart';
import '../theme/v_tokens.dart';
import 'v_surface.dart';

/// A 36 px app tile with the app's initial in Doto, until real (monochrome)
/// icons are wired up.
class VAppTile extends StatelessWidget {
  const VAppTile(this.name, {super.key, this.dashed = false, this.child});

  final String name;
  final bool dashed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 36,
      child: VOutlined(
        radius: VRadius.appTile,
        outline: dashed ? VOutline.dashed : VOutline.solid,
        child: Center(
          child:
              child ??
              Text(
                name.isEmpty ? '?' : name.characters.first.toUpperCase(),
                style: VText.doto(16),
              ),
        ),
      ),
    );
  }
}

/// Outline of a task as it ages (no colour change, ever):
/// under 3 days 1 px, 3–6 days heavier, 7+ days dashed.
class TaskAgeOutline {
  const TaskAgeOutline._(this.width, this.outline);

  factory TaskAgeOutline.forDays(int days) {
    if (days >= 7) return const TaskAgeOutline._(1.5, VOutline.dashed);
    if (days >= 5) return const TaskAgeOutline._(2.5, VOutline.solid);
    if (days >= 3) return const TaskAgeOutline._(2, VOutline.solid);
    return const TaskAgeOutline._(1, VOutline.solid);
  }

  final double width;
  final VOutline outline;

  /// The round checkbox uses the same scale, capped at 2 px.
  double get checkWidth => width > 2 ? 2 : width;
}

/// The round task checkbox, outlined by age. Done shows a filled circle.
class VTaskCheck extends StatelessWidget {
  const VTaskCheck({
    super.key,
    required this.ageDays,
    this.done = false,
    this.size = 22,
  });

  final int ageDays;
  final bool done;
  final double size;

  @override
  Widget build(BuildContext context) {
    final age = TaskAgeOutline.forDays(ageDays);
    return SizedBox.square(
      dimension: size,
      child: VOutlined(
        radius: size / 2,
        outline: done ? VOutline.solid : age.outline,
        width: done ? 1 : age.checkWidth,
        dashPattern: const [3, 3],
        child: done
            ? Padding(
                padding: const EdgeInsets.all(4),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: DefaultTextStyle.of(context).style.color,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : const SizedBox.expand(),
      ),
    );
  }
}

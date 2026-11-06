import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../icons/v_icons.dart';
import '../theme/v_colors.dart';
import '../theme/v_text.dart';
import '../theme/v_tokens.dart';
import 'v_ink.dart';
import 'v_surface.dart';

/// Repeating breathe-in / breathe-out cycle (4 s in, 6 s out).
///
/// Builds with `t` from 0 (out) to 1 (in) and whether the user is breathing in.
class VBreathing extends StatefulWidget {
  const VBreathing({super.key, required this.builder, this.running = true});

  final Widget Function(BuildContext context, double t, bool inhaling) builder;
  final bool running;

  @override
  State<VBreathing> createState() => _VBreathingState();
}

class _VBreathingState extends State<VBreathing>
    with SingleTickerProviderStateMixin {
  static final _cycle = VMotion.breatheIn + VMotion.breatheOut;
  static final _inShare =
      VMotion.breatheIn.inMilliseconds / _cycle.inMilliseconds;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _cycle,
  );

  @override
  void initState() {
    super.initState();
    if (widget.running) _controller.repeat();
  }

  @override
  void didUpdateWidget(VBreathing old) {
    super.didUpdateWidget(old);
    if (widget.running && !_controller.isAnimating) _controller.repeat();
    if (!widget.running) _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final p = _controller.value;
        final inhaling = p < _inShare;
        final t = inhaling
            ? Curves.easeInOut.transform(p / _inShare)
            : 1 - Curves.easeInOut.transform((p - _inShare) / (1 - _inShare));
        return widget.builder(context, t, inhaling);
      },
    );
  }
}

/// The breathe circle on "Put it down" and "Time's up": dashed outer ring,
/// solid inner ring, and a white core with the countdown.
class VBreatheCircle extends StatelessWidget {
  const VBreatheCircle({
    super.key,
    required this.value,
    this.label = 'BREATHE',
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ink = VInk.of(context);
    return VBreathing(
      builder: (context, t, _) => SizedBox.square(
        dimension: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned.fill(
              child: VOutlined(
                radius: 90,
                outline: VOutline.dashed,
                child: SizedBox.expand(),
              ),
            ),
            const Positioned.fill(
              left: 22,
              top: 22,
              right: 22,
              bottom: 22,
              child: VOutlined(radius: 68, child: SizedBox.expand()),
            ),
            Transform.scale(
              scale: 0.9 + 0.1 * t,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(color: ink, shape: BoxShape.circle),
                child: VInkScope(
                  ink: VColors.onColor(ink),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        value,
                        style: VText.doto(36, weight: 900, height: 1),
                      ),
                      Text(
                        label,
                        style: VText.inter(10, weight: 500, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Slide-to-stop control on the alarm screen.
class VSlideToStop extends StatefulWidget {
  const VSlideToStop({
    super.key,
    required this.onComplete,
    this.label = 'slide to stop',
  });

  final VoidCallback onComplete;
  final String label;

  @override
  State<VSlideToStop> createState() => _VSlideToStopState();
}

class _VSlideToStopState extends State<VSlideToStop> {
  double _dx = 0;

  @override
  Widget build(BuildContext context) {
    final ink = VInk.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        const knob = 52.0;
        const pad = 5.0;
        final maxDx = constraints.maxWidth - knob - pad * 2;
        return SizedBox(
          height: 64,
          child: VOutlined(
            radius: 32,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  widget.label,
                  style: VText.inter(15, weight: 500, letterSpacing: 0.6),
                ),
                Positioned(
                  left: pad + _dx,
                  top: pad,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (d) => setState(
                      () => _dx = (_dx + d.delta.dx).clamp(0, maxDx),
                    ),
                    onHorizontalDragEnd: (_) {
                      if (_dx >= maxDx * 0.9) {
                        HapticFeedback.heavyImpact();
                        widget.onComplete();
                      }
                      setState(() => _dx = 0);
                    },
                    child: Container(
                      width: knob,
                      height: knob,
                      decoration: BoxDecoration(
                        color: ink,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: VIconView(
                          VIcon.chevron,
                          strokeWidth: 2,
                          color: VColors.onColor(ink),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

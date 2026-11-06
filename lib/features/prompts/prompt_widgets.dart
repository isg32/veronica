import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../core/theme/v_colors.dart';
import '../../core/theme/v_text.dart';

/// Black full-screen frame shared by every prompt.
class PromptScaffold extends StatelessWidget {
  const PromptScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: VColors.black,
      child: SafeArea(child: child),
    );
  }
}

/// Big Doto headline with a short line under it ("PUT IT DOWN, SAPAN").
class PromptHeadline extends StatelessWidget {
  const PromptHeadline({
    super.key,
    required this.title,
    required this.body,
    this.eyebrow,
    this.size = 58,
    this.onLongPress,
  });

  final String title;
  final String body;
  final String? eyebrow;
  final double size;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 44, 28, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (eyebrow != null) ...[
              Text(
                eyebrow!,
                style: VText.inter(11, weight: 500, letterSpacing: 1.5),
              ),
              const SizedBox(height: 14),
            ],
            Text(title, style: VText.doto(size, weight: 900, height: 0.92)),
            const SizedBox(height: 14),
            Text(body, style: VText.inter(16, weight: 300, height: 1.4)),
          ],
        ),
      ),
    );
  }
}

/// Counts down whole seconds from [seconds] to zero.
class Countdown extends StatefulWidget {
  const Countdown({super.key, required this.seconds, required this.builder});

  final int seconds;
  final Widget Function(BuildContext context, int left) builder;

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late int _left = widget.seconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_left <= 0) {
        t.cancel();
        return;
      }
      setState(() => _left--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _left);
}

/// Breaks a long word across lines for the giant headline ("MAGNE / SIUM").
String splitForHeadline(String text, {int maxLine = 6}) {
  final words = text.toUpperCase().split(' ');
  return words
      .map((w) {
        if (w.length <= maxLine) return w;
        final half = (w.length / 2).ceil();
        return '${w.substring(0, half)}\n${w.substring(half)}';
      })
      .join('\n');
}

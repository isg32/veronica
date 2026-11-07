import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../core/theme/v_text.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_surface.dart';
import '../../platform/shizuku.dart';

/// "Grant with Shizuku": greyscale without a computer. Walks through getting
/// Shizuku, starting it, letting Veronica use it, and granting, re-checking
/// whenever you come back from Shizuku.
class ShizukuGrant extends StatefulWidget {
  const ShizukuGrant({super.key});

  @override
  State<ShizukuGrant> createState() => _ShizukuGrantState();
}

class _ShizukuGrantState extends State<ShizukuGrant>
    with WidgetsBindingObserver {
  ShizukuStep? _step;
  bool _working = false;
  bool? _granted;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_check());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_check());
  }

  Future<void> _check() async {
    final step = await Shizuku.step();
    if (mounted) setState(() => _step = step);
  }

  Future<void> _act() async {
    setState(() => _working = true);
    switch (_step) {
      case ShizukuStep.notInstalled || ShizukuStep.notRunning:
        await Shizuku.open();
      case ShizukuStep.notPermitted:
        await Shizuku.requestPermission();
        // The answer comes from Shizuku's own dialog; look again shortly.
        await Future<void>.delayed(const Duration(seconds: 2));
        await _check();
      case ShizukuStep.ready:
        final ok = await Shizuku.grantGreyscale();
        if (mounted) setState(() => _granted = ok);
      case null:
        break;
    }
    if (mounted) setState(() => _working = false);
  }

  @override
  Widget build(BuildContext context) {
    final step = _step;
    if (step == null) return const SizedBox.shrink();
    if (_granted == true) {
      return Text(
        'Greyscale granted. Shizuku is no longer needed.',
        style: VText.secondary,
      );
    }
    final (body, action) = switch (step) {
      ShizukuStep.notInstalled => (
        'No computer? Install Shizuku (free). It uses Wireless debugging to '
            'grant greyscale on the phone itself.',
        'Get Shizuku',
      ),
      ShizukuStep.notRunning => (
        'Open Shizuku and start it with Wireless debugging. It walks you through pairing.',
        'Open Shizuku',
      ),
      ShizukuStep.notPermitted => (
        'Let Veronica use Shizuku for one grant.',
        'Allow',
      ),
      ShizukuStep.ready => (
        'Shizuku is running. Grant greyscale now.',
        'Grant greyscale',
      ),
    };
    return VCard(
      outline: VOutline.dashed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Grant with Shizuku', style: VText.rowTitle),
          const SizedBox(height: 4),
          Text(body, style: VText.secondary),
          if (_granted == false) ...[
            const SizedBox(height: 6),
            Text(
              'That did not work. Check Shizuku is running and try again.',
              style: VText.secondary,
            ),
          ],
          const SizedBox(height: 12),
          VButton.secondary(
            _working ? 'Working…' : action,
            onPressed: _working ? null : _act,
          ),
        ],
      ),
    );
  }
}

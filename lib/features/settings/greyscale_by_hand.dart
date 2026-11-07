import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../core/theme/v_text.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_surface.dart';
import '../../platform/android_usage.dart';

const _channel = MethodChannel('veronica/permissions');

/// Opens Android's Color correction screen (or Accessibility), for turning
/// greyscale on or off by hand when Veronica has no grant to do it.
Future<void> openColorCorrection() async {
  if (isAndroid) await _channel.invokeMethod<void>('openColorCorrection');
}

/// The third way to greyscale, needing no setup: switch it yourself. Shown
/// after the ADB command (first choice) and Shizuku (second).
class GreyscaleByHand extends StatelessWidget {
  const GreyscaleByHand({super.key});

  @override
  Widget build(BuildContext context) {
    return VCard(
      outline: VOutline.dashed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Or switch it yourself', style: VText.rowTitle),
          const SizedBox(height: 4),
          Text(
            'No setup needed. When a mode wants greyscale, Veronica sends a '
            'notification that opens the setting in one tap. For the quickest '
            'way, add the "Color correction" tile to your quick settings.',
            style: VText.secondary,
          ),
          const SizedBox(height: 12),
          const VButton.secondary(
            'Open Color correction',
            onPressed: openColorCorrection,
          ),
        ],
      ),
    );
  }
}

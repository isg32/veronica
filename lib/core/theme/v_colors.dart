import 'package:flutter/widgets.dart';

/// The only colours Veronica may use.
///
/// The app is pure black and white. Translucency exists only for the glass
/// surfaces listed in `design/DESIGN.md`; each has its own named constant so
/// nothing else can sneak in. `test/design/no_banned_colors_test.dart` fails
/// the build if a colour is created anywhere outside this file.
abstract final class VColors {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);

  /// Floating tab bar: white at 10 %.
  static const Color glassBar = Color(0x1AFFFFFF);

  /// Glass card over a full-screen prompt: white at 8 %.
  static const Color glassCard = Color(0x14FFFFFF);

  /// Bottom sheet: black at 55 %.
  static const Color glassSheet = Color(0x8C000000);

  /// Home-screen widget, dark set: black at 40 %.
  static const Color widgetDark = Color(0x66000000);

  /// Home-screen widget, light set: white at 50 %.
  static const Color widgetLight = Color(0x80FFFFFF);

  /// Opacity of a disabled primary action.
  static const double disabledOpacity = 0.35;

  /// The colour that sits on top of [color] (black on white, white on black).
  static Color onColor(Color color) => color == white ? black : white;
}

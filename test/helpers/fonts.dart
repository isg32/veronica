import 'dart:io';

import 'package:flutter/services.dart';

/// Loads the bundled fonts so layout in tests matches the device (the
/// default test font draws every glyph as a full-width square).
Future<void> loadAppFonts() async {
  for (final (family, path) in const [
    ('Doto', 'assets/fonts/Doto.ttf'),
    ('Inter', 'assets/fonts/Inter.ttf'),
  ]) {
    final bytes = File(path).readAsBytesSync();
    await (FontLoader(
      family,
    )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
  }
}

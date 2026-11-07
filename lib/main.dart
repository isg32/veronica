import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'platform/mantra_audio.dart';
import 'platform/mantra_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerFontLicences();
  unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
  // Mantras play as a media service, so they carry on in the background.
  final mantras = await initMantraAudio();
  runApp(
    ProviderScope(
      overrides: [mantraHandlerProvider.overrideWithValue(mantras)],
      child: const VeronicaApp(),
    ),
  );
}

/// Doto and Inter are bundled under the SIL Open Font License.
void _registerFontLicences() {
  for (final (font, file) in const [
    ('Doto', 'assets/fonts/OFL-Doto.txt'),
    ('Inter', 'assets/fonts/OFL-Inter.txt'),
  ]) {
    LicenseRegistry.addLicense(() async* {
      yield LicenseEntryWithLineBreaks([
        font,
      ], await rootBundle.loadString(file));
    });
  }
}

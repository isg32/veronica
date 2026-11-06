import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/theme/v_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _registerFontLicences();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: VColors.transparent,
      systemNavigationBarColor: VColors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ProviderScope(child: VeronicaApp()));
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

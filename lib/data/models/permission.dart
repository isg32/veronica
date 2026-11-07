/// A runtime permission Veronica asks for during onboarding.
enum AppPermission {
  usageAccess('Usage access', 'See time spent in the apps you pick'),
  accessibility('Accessibility', 'Notice the moment a watched app opens'),
  overlay('Display over apps', 'Show "Put it down" over Instagram'),
  dnd('Do Not Disturb', 'Silence the phone in Work and Go Out'),
  notifications('Notifications', 'Water, medicine and mantra reminders'),
  exactAlarms('Exact alarms', 'Wake you at exactly 07:00'),
  battery('Battery unrestricted', 'Keep the watcher running'),
  writeSettings('Modify system settings', 'Dim the screen in a mode');

  const AppPermission(this.label, this.reason);

  final String label;
  final String reason;
}

/// State of the one-time ADB grants.
class AdbStatus {
  const AdbStatus({
    required this.greyscaleGranted,
    required this.glyphDebugNeeded,
    required this.glyphDebugExpiresAt,
  });

  /// `WRITE_SECURE_SETTINGS` granted (needed for greyscale).
  final bool greyscaleGranted;

  /// Whether this phone needs Glyph debug mode at all (Android 16+ doesn't).
  final bool glyphDebugNeeded;

  /// When Glyph debug mode switches itself off; null if it is off.
  final DateTime? glyphDebugExpiresAt;

  bool glyphDebugActive(DateTime now) =>
      glyphDebugExpiresAt != null && glyphDebugExpiresAt!.isAfter(now);
}

/// The ADB commands shown in onboarding and Settings.
abstract final class AdbCommands {
  static const String packageName = 'com.isg32.veronica';

  static const String greyscale =
      'adb shell pm grant $packageName android.permission.WRITE_SECURE_SETTINGS';

  static const String glyphDebug =
      'adb shell settings put global nt_glyph_interface_debug_enable 1';
}

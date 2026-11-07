/// Every path in the app, in one place.
abstract final class Routes {
  // Tabs.
  static const today = '/today';
  static const focus = '/focus';
  static const tasks = '/tasks';
  static const care = '/care';
  static const sleep = '/sleep';

  static const onboarding = '/onboarding';

  // Detail pages (pushed over the tabs, without the tab bar).
  static const settings = '/settings';
  static const settingsPermissions = '/settings/permissions';
  static const settingsGlyph = '/settings/glyph';
  static const settingsVoice = '/settings/voice';
  static const settingsWidgets = '/settings/widgets';
  static const settingsWidgetsPlace = '/settings/widgets/place';
  static const settingsData = '/settings/data';
  static const weekly = '/weekly';
  static String app(String packageName) => '/app/$packageName';
  static const addApp = '/app-picker';
  static String mode(String id) => '/mode/$id';
  static const newModeId = 'new';
  static String task(String id) => '/task/$id';
  static String medicine(String id) => '/medicine/$id';
  static const newId = 'new';
  static const doses = '/doses';
  static const mantras = '/mantras';
  static const listening = '/listening';
  static String alarm(String id) => '/alarm/$id';
  static const sounds = '/sounds';

  // Full-screen prompts.
  static const activeMode = '/now/mode';
  static String putItDown(String packageName) =>
      '/now/put-it-down/$packageName';
  static const timesUp = '/now/times-up';
  static String medicineDue(String medicineId) => '/now/medicine/$medicineId';
  static String alarmRinging(String alarmId) => '/now/alarm/$alarmId';
  static const mantraSession = '/now/mantra';
  static const mantraTime = '/now/mantra-time';
  static const listen = '/now/listen';
}

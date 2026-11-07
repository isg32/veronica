/// Shown in Settings. Must match `version:` in pubspec.yaml (a test checks).
///
/// Bump both when a phase is completed: 0.1.0 after Phase 0, then 0.2.0,
/// 0.3.0, 0.4.0, and 1.0.0 after Phase 4. The build number goes up by one on
/// every bump. See "Versioning" in docs/PLAN.md.
const String kAppVersion = '0.2.0';
const int kAppBuild = 3;

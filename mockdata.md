# mockdata.md

This file lists every fake dataset in the app. In Phase 0, every screen reads from a `Mock…Repository` in `lib/mock/`, and no widget hard-codes values. When a later phase wires a feature to real data, its **Status** flips from `Mock` to `Real`, and the mock file is kept only for tests.

The values match the design canvas ([`design/DESIGN.md`](design/DESIGN.md)), so screens can be compared side by side. Everything Veronica keeps now lives in the on-device database. The sample data below is still used by tests, by the local preview renders and by **Settings → Data → Load sample data** in debug builds (`lib/mock/seed.dart`), anchored to the moment it is loaded (`mockNow`).

| Dataset | File | Used on | Contents | Status |
| --- | --- | --- | --- | --- |
| Profile | `lib/data/local/local_repositories.dart` | Onboarding, Today, prompts | Name and onboarding state | Real |
| Permissions | `lib/data/system/android_permission_repository.dart` (`lib/mock/permissions_mock.dart` in tests) | Onboarding, Settings | The phone's real state of the 7 permissions and the ADB grants, re-read every few seconds while shown | Real |
| Watched apps | `lib/data/usage/drift_usage_repository.dart`, `lib/platform/android_usage.dart` | Today, Focus, App detail, Put it down, Weekly, widgets | Watched apps, limits and counters in drift; minutes per day and the installed-app list from Android usage stats (`MockUsageSource` only in tests and on the desktop) | Real |
| Tasks | `lib/data/local/local_repositories.dart` | Today, Tasks, Task detail, widget | Your tasks | Real |
| Water log | `lib/data/local/local_repositories.dart` | Today, Care, Weekly, widget | Goal, glass size, window and every glass logged | Real |
| Medicines | `lib/data/local/local_repositories.dart` | Today, Care, Medicine editor, Dose history, Medicine due | Medicines and answered doses; unanswered doses are due, then missed 2 h after their time. Off until you turn it on | Real |
| Modes | `lib/data/local/local_repositories.dart` | Today, Focus, Mode editor, Active mode, widget | Work, Go Out and Binge Time presets (created on first run), your own modes, and the running mode | Real |
| Sleep + alarms | `lib/data/local/local_repositories.dart`; nights from `nightSource` (empty until Phase 3) | Sleep, Alarm editor, Alarm ringing, Weekly, widget | Schedule, wind-down and alarms are stored. The 7-night estimate is not built yet | Partly real |
| Mantras | `lib/data/local/local_repositories.dart` | Today, Care, Mantra library, Mantra session/time, widget | Six starter mantras on first run, plus your own; rotates by date | Real |
| Alarm sounds | `lib/data/local/local_repositories.dart`; `soundPicker` (Phase 3) | Sleep, Alarm editor, Sound library | Stored sounds; importing from files arrives in Phase 3 | Partly real |
| Voice | `lib/data/local/local_repositories.dart`; `voiceModelState` (Phase 4) | Settings · Voice | Voice settings are stored; the model and speech arrive in Phase 4 | Partly real |
| Glyph | `lib/data/local/local_repositories.dart` | Settings · Glyph | Brightness and quiet hours are stored; the lights arrive in Phase 4 | Partly real |

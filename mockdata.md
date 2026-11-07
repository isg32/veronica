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
| Sleep + alarms | `lib/data/local/local_repositories.dart`, `lib/platform/reminders.dart` | Sleep, Alarm editor, Alarm ringing, Weekly, widget | Schedule, wind-down and alarms are stored and fire as exact alarms; the 7-night estimate comes from screen-off time | Real |
| Mantras | `lib/data/local/local_repositories.dart` | Today, Care, Mantra library, Mantra session/time, widget | Six starter mantras on first run, plus your own; rotates by date | Real |
| Alarm sounds | `lib/data/local/local_repositories.dart`, `lib/platform/reminders.dart` | Sleep, Alarm editor, Sound library, Alarm ringing | Imported from your files and copied into the app; played with a fade-in | Real |
| Voice | `lib/data/local/local_repositories.dart`, `lib/platform/voice.dart` | Settings · Voice, full-screen prompts | Voice settings are stored; Kokoro is downloaded once and lines are rendered and cached, with Android speech as the fallback | Real |
| Glyph | `lib/data/local/local_repositories.dart`, `lib/platform/glyph.dart` | Settings · Glyph, full-screen prompts | Brightness and quiet hours are stored; patterns play on the Phone (2a) lights while their page is open | Real |

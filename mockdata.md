# mockdata.md

This file lists every fake dataset in the app. In Phase 0, every screen reads from a `Mock…Repository` in `lib/mock/`, and no widget hard-codes values. When a later phase wires a feature to real data, its **Status** flips from `Mock` to `Real`, and the mock file is kept only for tests.

The values match the design canvas ([`design/DESIGN.md`](design/DESIGN.md)), so screens can be compared side by side. The app clock is real time. The remaining mock data is anchored to the moment the app started (`mockNow` in `lib/mock/mock_cell.dart`), so ages, logs and timers are relative to launch, and it resets when the app restarts. Real data (marked below) is kept in the on-device database.

| Dataset | File | Used on | Contents | Status |
| --- | --- | --- | --- | --- |
| Profile | `lib/mock/profile_mock.dart` | Onboarding, Today, overlays | Name "Sapan" | Mock |
| Permissions | `lib/data/system/android_permission_repository.dart` (`lib/mock/permissions_mock.dart` in tests) | Onboarding, Settings | The phone's real state of the 7 permissions and the ADB grants, re-read every few seconds while shown | Real |
| Watched apps | `lib/data/usage/drift_usage_repository.dart`, `lib/platform/android_usage.dart` | Today, Focus, App detail, Put it down, Weekly, widgets | Watched apps, limits and counters in drift; minutes per day and the installed-app list from Android usage stats (`MockUsageSource` only in tests and on the desktop) | Real |
| Tasks | `lib/mock/tasks_mock.dart` | Today, Tasks, Task detail, widget | 8 tasks, 6 open (ages 10, 8, 5, 4, 1, 0 days) and 2 done; "Renew passport" is due Fri 20 Nov, priority High, with notes | Mock |
| Water log | `lib/mock/water_mock.dart` | Today, Care, Weekly, widget | 5 of 8 glasses (250 ml) at 08:10–15:40; window 07:00–23:00, every 2 h; week total 45 of 56 | Mock |
| Medicines | `lib/mock/medicine_mock.dart` | Today, Care, Medicine editor, Dose history, Medicine due | Vitamin D (1 tablet, 09:00, 24 left) and Magnesium (200 mg, 22:00, 6 left); 13 of 14 taken this week, 1 missed (Thu 22:00); medicine switched on so its screens show | Mock |
| Modes | `lib/mock/modes_mock.dart` | Today, Focus, Mode editor, Active mode, widget | Work, Go Out and Binge Time presets (Binge running, 38:12 left of 60:00) and one custom mode ("Reading": dim, silent, black wallpaper) | Mock |
| Sleep + alarms | `lib/mock/sleep_mock.dart` | Sleep, Alarm editor, Alarm ringing, Weekly, widget | Bed 23:30, wake 07:00, wind-down 30 min; alarms 07:00 Mon–Fri "Rain on tin" with sunrise (on) and 09:00 Sat–Sun "Birdsong" (off); 7 nights planned vs actual, average 6h 48m | Mock |
| Mantras | `lib/mock/mantra_mock.dart` | Today, Care, Mantra library, Mantra session/time, widget | 6 mantras (3 yours and 3 starter); today's is "I am here. This is enough." at 07:15; rotate daily | Mock |
| Alarm sounds | `lib/mock/sounds_mock.dart` | Sleep, Alarm editor, Sound library | Rain on tin 0:42, Birdsong 1:10, Low bell 0:18 (names only, no audio) | Mock |
| Voice | `lib/mock/voice_mock.dart` | Settings · Voice | Voice af_heart, speed 1.0×, all 7 moments on, 14 of 14 lines pre-rendered, model downloaded | Mock |
| Glyph | `lib/mock/glyph_mock.dart` | Settings · Glyph | Brightness 60%, quiet hours 23:00–07:00 | Mock |

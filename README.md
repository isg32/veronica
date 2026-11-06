# Veronica

Veronica is a calm Android companion that helps you use your phone less and look after yourself more. It watches only the apps you pick and nudges you to put the phone down. It also keeps your water, medicine, sleep, wake-up alarms, a daily mantra and to-dos in one place.

It is built for the **Nothing Phone (2a)**, where the Glyph lights act as a quiet second screen.

- **Calm, not guilt.** Nudges are soft and escalate slowly.
- **Offline and private.** There is no account and all data stays on the phone. The only network request is a one-time voice-model download.
- **Two colours.** The UI is pure black and white, with dot-matrix Doto type.
- **Personal use.** Veronica is sideloaded, never on the Play Store, so it uses ADB-granted permissions.

> **Status:** Phase 0 (UI on mock data), version 0.0.1. See the roadmap in [`docs/PLAN.md`](docs/PLAN.md#roadmap).

## Repository

| Path | What it is |
| --- | --- |
| [`docs/PLAN.md`](docs/PLAN.md) | Product plan: features, modes, pages, tech, data model and roadmap |
| [`design/`](design/) | Screens v1 from Claude Design, plus [`DESIGN.md`](design/DESIGN.md), the spec the code follows |
| [`mockdata.md`](mockdata.md) | Every fake dataset and whether it is still mock |
| `lib/` | Flutter app (Cupertino widgets only) |
| `android/` | Android host and the native Kotlin layer |

## Build

You need Flutter 3.47+ (Dart 3.13+), the Android SDK 36 and JDK 17.

```sh
flutter pub get
flutter analyze
flutter test
flutter run            # with the phone connected over USB debugging
```

## One-time phone setup

Veronica asks for most permissions in onboarding. Greyscale needs one ADB grant:

```sh
adb shell pm grant com.isg32.veronica android.permission.WRITE_SECURE_SETTINGS
```

Glyph control may also need debug mode on phones older than Android 16. Debug mode expires after 48 hours:

```sh
adb shell settings put global nt_glyph_interface_debug_enable 1
```

Re-run both commands after a factory reset.

## Contributing

History is linear on `main` and uses [Conventional Commits](https://www.conventionalcommits.org/) (`feat(today): …`, `fix(tasks): …`, `docs: …`). Each commit must pass `flutter analyze` and `flutter test`.

When a phase is completed, bump `version:` in `pubspec.yaml` and `lib/app/version.dart` in a `chore(release): …` commit: 0.1.0 after Phase 0, then 0.2.0, 0.3.0, 0.4.0, and 1.0.0 after Phase 4. The build number (after `+`) goes up by one every time. See [Versioning](docs/PLAN.md#roadmap).

## License

Copyright (C) 2026 Sapan Gajjar

Veronica is free software: you can redistribute it and/or modify it under the terms of the [GNU General Public License v3.0](LICENSE) as published by the Free Software Foundation. It is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the [LICENSE](LICENSE) for details.

Bundled third-party assets keep their own licences: Doto and Inter are under the SIL Open Font License ([`assets/fonts/`](assets/fonts/)), and `design/support.js` is the Claude Design canvas runtime, included only to view the design export.

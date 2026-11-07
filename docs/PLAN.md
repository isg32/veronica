# Veronica — App Plan

Nov 6, 2026 · Sapan Gajjar

> Design: [`design/DESIGN.md`](../design/DESIGN.md) · Mock data: [`mockdata.md`](../mockdata.md)

## Vision & principles

Veronica is a calm Android companion that helps you use your phone less and look after yourself more: it watches the apps you choose, nudges you to put the phone down, and handles water, medicine, sleep, wake-up, mantra and to-dos in one place. It targets Nothing phones first, so the Glyph lights become a quiet second screen for reminders.

- **Calm, not guilt.** Nudges are soft and escalate slowly; no streak-shaming.
- **You choose what is watched.** Only apps the user selects are tracked.
- **Offline and private.** All data stays on the phone; no account. Personal use only: sideloaded, never on the Play Store, so ADB-granted permissions are fine.
- **Glanceable.** Anything that can be said with a Glyph pattern instead of lighting the screen should be.
- **Nothing-style UI.** pure black and white only (no other colours, no greys), dot-matrix type, so the app itself feels distraction-free. It follows the system light or dark mode, with no toggle.

## Features

Ten features, grouped into a v1 core (usage, water, to-do, modes, focus settings) and later add-ons. Priority: P0 = MVP, P1 = v1.1, P2 = later.

| Feature | What it does | Key details | Priority |
| --- | --- | --- | --- |
| App usage monitor | Tracks time in apps you pick; nudges you to put the phone down | Daily limit per app; soft nudge at 80%, full-screen "Put it down" card at 100% with a 5 s breathe-to-dismiss; optional hard block with "5 more minutes" (max 2 per day); a long-press emergency override always exists (5 min, logged, shown weekly) | P0 |
| Water reminders | Reminds you to drink at intervals | Daily goal in ml or glasses; interval from wake to sleep time; one-tap "logged" from notification or Glyph button; pauses during sleep and Work focus calls | P0 |
| To-do with age | Simple task list that shows how long each task has waited | "Added 1 day ago" label on every task; the outline gets heavier at 3 days and dashed after 7 (no colour); filter "older than 3 days"; optional due date | P0 |
| Modes | Work, Go Out, Binge Time presets that change the whole phone's behaviour | See Modes section; switch from app, quick-settings tile, or schedule | P0 |
| Distraction-less settings | Greyscale, DND, hide notifications, dim screen | Applied by modes or manually; greyscale needs a one-time ADB permission (see Tech) | P0 |
| Medicine (optional) | Medicine schedule with reminders | Off by default; name, dose, times; "taken / skip / snooze 15 min"; missed-dose history; refill count | P1 |
| Sleep schedule | Bedtime and wake targets with a wind-down | Wind-down 30 min before bed turns on greyscale + DND; weekly view of planned vs actual (screen-off time as proxy) | P1 |
| Calm alarm | Gentle wake-up | Sound fades in over 2–5 min; sounds you import yourself; Glyph lights ramp up as a sunrise; snooze by flipping or Glyph button; linked to sleep schedule | P1 |
| Daily mantra | A set time to read or say a mantra | User-written or built-in list; one notification a day; full-screen calm card with a 1-minute breathing timer; mantra history | P1 |
| Glyph interface | Shows reminders and progress on the Nothing Glyph lights | Water progress, usage limit progress, mode indicator, alarm sunrise; see Glyph section | P1 |

Home screen: today's usage vs limits, water progress ring, next medicine (only when medicine is on), current mode, top 3 oldest to-dos.

## Modes

Each mode is a bundle of settings applied in one tap and reverted when the mode ends. Users can edit every default below and create their own modes (v1). Custom modes can also set screen brightness, ringer and media volume, hide notifications, and switch to a plain black wallpaper; all are restored when the mode ends.

| Setting | Work | Go Out | Binge Time |
| --- | --- | --- | --- |
| Purpose | Deep focus | Be present with people | Guilt-free leisure, with a cap |
| Greyscale | On | On | Off |
| Do Not Disturb | On, allow starred contacts | On, allow calls | Off |
| Watched apps | Blocked (social, video) | Nudge after 5 min of use | Allowed until binge timer ends |
| Water reminders | On | Off (or Glyph only) | On |
| Timer | Optional Pomodoro 25/5 | None | Required: set 30 / 60 / 90 min |
| Glyph | Slow focus pulse | Off except calls | Countdown of binge time left |
| Ends | Manually or on schedule | Manually | When the timer hits zero, then a "Put it down" card |

Modes can start on a schedule (Work at 10:00 on weekdays) or from a quick-settings tile. Only one mode runs at a time; Sleep wind-down overrides any mode.

## Design system

The whole app uses exactly two colours, `#000000` and `#FFFFFF`; hierarchy comes from size, weight, outline vs fill and inversion, never from greys or a third colour.

| Rule | How it is applied |
| --- | --- |
| Background / foreground | Black background, white text, icons and lines everywhere |
| Emphasis and selection | Inversion: a selected chip, primary button or active tab becomes a white pill with black text |
| Secondary or disabled | Smaller size, lighter weight, outline-only or dashed border, never grey text |
| Charts and progress | White bars and rings; a second series uses a dot or hatch pattern, not a colour |
| Dividers | 1 px white hairlines; inset-grouped lists use white outline cards |
| Frosted glass | The only translucency: tab bar, nav bar, sheets and widgets blur what is behind and add a thin white tint and 1 px white border |
| Type | **Doto** (open dot-matrix font, Google Fonts) for big numbers, timers and page titles; a clean sans such as **Inter** for body text |
| Icons | A small custom 1.5 px line-icon set (from the design), inverted inside a white pill when selected |
| Motion | 250 ms ease-out fades and slides, no bounce; light haptic on every confirm |

**Flutter Cupertino setup.** `CupertinoApp` with a custom `CupertinoThemeData` (dark brightness, `primaryColor` white, `scaffoldBackgroundColor` black), a custom floating glass tab bar (see `design/DESIGN.md`) and large Doto page titles. Cupertino widgets bring their own blue, green and red by default (the switch track, destructive actions, the activity indicator), so every one is themed or wrapped, and all colours come from one `VColors` class with just `black` and `white`. A unit test scans `lib/` and fails the build if any other `Color(...)` or `CupertinoColors.*` appears.

Core components: `CupertinoListSection.insetGrouped`, `CupertinoSwitch` (white track, black thumb), `CupertinoSlidingSegmentedControl`, `CupertinoDatePicker` and `CupertinoTimerPicker`, `CupertinoActionSheet`, and modal sheets via `showCupertinoModalPopup`. In-app glass uses `BackdropFilter` with `ImageFilter.blur`.

## Pages & navigation

Veronica has five tabs (Today, Focus, Tasks, Care, Sleep), with Settings behind a gear on Today and five full-screen prompts that can open over any app.

The full list of 37 designed screens is in [`design/DESIGN.md`](../design/DESIGN.md#screens).

Onboarding runs once and lands on Today; the dashed box marks the prompts, which Focus, Care and Sleep trigger.

## Page layouts & features

Every tab page uses the same frame: a large-title glass nav bar on top, scrolling content in inset-grouped white-outline cards, and the glass tab bar at the bottom. Layouts below are listed top to bottom.

### Onboarding (first run only)

1. **Welcome:** large "VERONICA" in Doto, one line on what she does, a name field ("What should Veronica call you?"), Veronica says hello in her voice; "Begin" button.
2. **Permissions checklist:** one row per permission (Usage access, Accessibility, Display over apps, DND access, Notifications, Exact alarms, Battery unrestricted), each with a one-line reason and a "Grant" button that opens the right Settings screen; rows tick when granted.
3. **ADB setup guide:** the commands to copy (secure settings for greyscale; Glyph debug only if the phone needs it), a "Copy" button for each, and a "Check again" button that confirms they worked.
4. **Pick apps to watch:** searchable list of installed apps with icons and a toggle; set a daily limit per picked app with a timer picker.
5. **Water goal:** glasses or ml, glass size, wake and sleep times for the reminder window.
6. **Sleep times:** bedtime and wake time pickers; "Done" lands on Today.

### Today (tab 1, home)

1. **Nav bar:** greeting with date ("Good evening, Sapan"); gear icon to Settings.
2. **Current mode card:** mode name in Doto, time left if a timer runs, "Switch" opens a 3-option action sheet.
3. **Screen time card:** total watched-app time today vs total limit as a big number and a white ring; the top 3 apps as rows with mini bars.
4. **Water card:** dot row (one dot per glass, filled when drunk), "+1 glass" button.
5. **Next up card:** the next medicine (hidden when medicine is off), alarm and mantra time.
6. **Oldest tasks card:** top 3 open tasks with their age ("added 4 days ago"); tap goes to Tasks.
7. **Today's mantra strip:** the mantra text in one line; tap opens the mantra session.
8. **Weekly summary link:** opens a page with 7-day bars for screen time, water and sleep, plus nudges accepted.

### Focus (tab 2)

1. **Segmented control:** Usage | Modes.
2. **Usage view:** today's total in Doto; a list of watched apps, each with icon, time used / limit and a progress bar; "Add app" at the bottom.
3. **App detail page:** 7-day bar chart, daily limit picker, nudge point (50 / 80 / 90%), hard-block toggle, "5 more minutes" allowance (0–2 a day), remove app.
4. **Modes view:** three large cards (Work, Go Out, Binge Time) showing what each turns on as small icons; the active one is inverted (white card, black text); tap to start, long-press to edit.
5. **Mode editor:** toggles for greyscale, DND, water reminders and Glyph; app picker for blocked apps; timer picker; schedule (days + start time).
6. **Active mode screen:** full black page with the mode name and a big Doto countdown or elapsed time, "End mode" button; Pomodoro ring in Work.

### Tasks (tab 3)

1. **Nav bar:** "Tasks" large title; "+" button.
2. **Filter control:** All | Old (3+ days) | Done.
3. **Task list:** each row has a round checkbox, title, and age label under it ("added 1 day ago"); older tasks get a thicker outline, then a dashed outline after 7 days (no colour change); swipe left to delete, swipe right to complete.
4. **Add task sheet:** glass bottom sheet with a title field, optional due date, "Add" button; the created time is saved automatically.
5. **Task detail:** title, notes, created date and age, due date, "Mark done".

### Care (tab 4)

1. **Water card:** big ring with glasses drunk / goal, "+1 glass" and "undo"; interval setting; tap for the day's log by time.
2. **Medicine section (hidden until turned on):** today's doses as rows with time and a Taken / Skip control; "Add medicine" opens an editor with name, dose, times, days and refill count; a history page shows missed doses.
3. **Mantra card:** today's mantra, the set time, "Start now".
4. **Mantra session (full screen):** mantra in large type centred, a 1-minute breathing circle that grows and shrinks, Veronica reads it aloud if voice is on.
5. **Mantra library:** your own mantras plus a starter list; set which one shows each day (fixed or rotate).

### Sleep (tab 5)

1. **Tonight card:** bedtime and wake time in Doto with the hours of sleep between them; edit with time pickers.
2. **Wind-down row:** minutes before bed (15 / 30 / 60) and what it switches on (greyscale, DND, Veronica's goodnight line).
3. **Alarms list:** each alarm with time, days and a switch; "+" adds one.
4. **Alarm editor:** time picker, repeat days, sound from your library, fade-in length (1–5 min), Glyph sunrise toggle, snooze length.
5. **Sound library:** sounds you import from your files; preview, rename, delete. No sounds ship with the app.
6. **Last 7 nights:** bars of planned vs actual sleep, using screen-off time as the estimate.

### Settings (gear on Today)

- **Permissions & ADB:** live status of every permission and ADB grant, with fix buttons and the commands again.
- **Glyph:** test each pattern on the Phone (2a) lights, overall brightness, quiet hours.
- **Veronica's voice:** on/off, voice choice, speed, which moments she speaks (nudges, mantra, wake-up, goodnight).
- **Widgets:** preview of each home-screen widget and how to add it.
- **Data:** export to JSON, import, reset all.
- **About:** version and licences (Kokoro, Doto, Glyph SDK).

### Full-screen overlays (appear over any app)

- **Put it down:** black screen, "Put it down" in Doto, today's time in that app, a 5-second breathing circle before "Close app" or "5 more minutes" (if any left). Veronica can say it aloud.
- **Time's up:** Binge Time ended; same layout with "End" only.
- **Medicine due:** name and dose, Taken / Snooze 15 min / Skip.
- **Alarm ringing:** time in huge Doto, slide to stop, tap to snooze; the sound fades in while the Glyph sunrise ramps up.
- **Mantra time:** a gentle prompt card with "Start" or "Later".

## Home-screen widgets

Six widgets in Nothing OS's square-grid style, all black and white with a frosted-glass card. Built with the Flutter `home_widget` package and native Android widget layouts.

| Widget | Size | Shows | Tap actions |
| --- | --- | --- | --- |
| Screen time | 2×2 | Today's watched-app total in Doto + ring vs limit | Opens Focus |
| Water | 2×1 | Dot row of glasses | "+1" logs a glass without opening the app |
| Mode switch | 4×1 | Work / Go Out / Binge as three pills, active one inverted | Tap a pill to start that mode |
| Oldest tasks | 4×2 | 3 oldest open tasks with ages | Tick to complete; tap opens Tasks |
| Next alarm | 2×1 | Alarm time + hours of sleep left | Opens Sleep |
| Mantra | 4×1 | Today's mantra | Opens mantra session |

**About the frosted glass.** Android home-screen widgets can't blur the live wallpaper behind them; the widget system only allows simple layouts. Two ways to get the look:

1. **Tinted glass (default, reliable):** white at low opacity with a 1 px white border, so the wallpaper shows through softly. Works with any wallpaper and launcher.
2. **Fake blur (experimental):** the app reads your wallpaper, blurs it, and paints the matching crop as the widget background. Looks like real frosted glass, but breaks when you move the widget or change wallpaper until it refreshes, and needs storage permission to read the wallpaper. Fine for personal use; build it after option 1 works.

## Veronica's voice

The models are downloaded once, on first use, from their public releases. That is the only network access Veronica makes, and Android TTS covers the gap until the download finishes.

Use **Kokoro-82M** through **sherpa-onnx**: both are open source and run fully offline on Android, and sherpa-onnx has an official Flutter package (`sherpa_onnx` on pub.dev). Kokoro has several soft female English voices to audition, such as `af_heart`, `af_bella`, `af_nicole` (very soft, near-whisper) and the British `bf_emma`.

Kokoro is slow on mid-range phones: one Android app built on it reports 2–3 minutes of processing per minute of audio on budget and mid-range devices, and recommends about 500 MB free for models ([VoxSherpa](https://github.com/CodeBySonu95/VoxSherpa-TTS/releases/tag/v1.0-beta)). The Phone (2a) is mid-range, so:

- **Pre-render fixed lines.** Veronica's lines are short and mostly fixed ("Put it down, Sapan", "Good morning", "Time for water", each mantra). Generate them once when a line is added or edited, save as audio files, and play instantly.
- **Piper for live lines.** Lines with numbers ("You've been on Instagram for 42 minutes") use a fast Piper voice, also through sherpa-onnx, or are stitched from pre-rendered pieces.
- **Fallback:** if a clip is missing, use Android's built-in TTS so a reminder is never silent.

Where she speaks (each toggleable): Put-it-down nudge, Time's up, water reminder, medicine due, mantra session, wake-up greeting after the alarm, goodnight at wind-down.

Sources: [sherpa-onnx Kokoro model page](https://k2-fsa.github.io/sherpa/onnx/tts/all/Chinese-English/kokoro-multi-lang-v1_0.html), [VoxSherpa (Kokoro + Piper on Android via sherpa-onnx)](https://github.com/CodeBySonu95/VoxSherpa-TTS).

## Glyph interface

Glyph support targets the **Nothing Phone (2a) only**, using the official [Glyph Developer Kit](https://github.com/Nothing-Developer-Programme/Glyph-Developer-Kit) through the MIT-licensed Flutter plugin [`nothing_glyph_interface`](https://pub.dev/packages/nothing_glyph_interface), which supports the 2a. The 2a has three lights: **A** (index 25), **B** (index 24) and the curved strip **C1–C24** (indices 0–23, C1 bottom left to C24 top right).

Setup for personal use: add the `com.nothing.ketchum.permission.ENABLE` permission and `NothingKey` = `test` in the manifest, then run `adb shell settings put global nt_glyph_interface_debug_enable 1`. Debug mode switches itself off after 48 hours. Nothing says no API key is needed for apps targeting Android 16 or later, so if your 2a is on Android 16 (Nothing OS 4) this step may not be needed at all.

**Main limit: only an app in the foreground can control the Glyphs.** So Veronica lights them while one of her own screens is open, which is why the Put-it-down, alarm, medicine and mantra prompts open as full-screen pages rather than small pop-ups.

| Signal | Phone (2a) pattern | Shows when |
| --- | --- | --- |
| Alarm sunrise | C fills slowly from C1 to C24 over the fade-in time, then A and B light | Alarm ringing screen |
| Put it down | C fills to the share of the limit used, then three slow pulses of A | Put-it-down screen |
| Time's up (Binge) | C empties from top to bottom over the last minute | Time's up screen |
| Water progress | C lights one block per glass of the goal | Water card or after "+1 glass" |
| Medicine due | A and B double-flash, repeating every 10 s | Medicine due screen |
| Mantra breathing | Whole C strip glows up for 4 s and down for 6 s | Mantra session |
| Focus countdown | C drains as the Work or Binge timer runs | Active mode screen |

When Veronica isn't on screen, reminders rely on normal notifications. Nothing OS can light the Glyphs for notifications from chosen apps, so adding Veronica there may give a light even in the background (to verify on your phone).

## Tech stack & permissions

Veronica is a Flutter app using Cupertino widgets only, built for Android only for now (sideloaded to your Phone (2a)). The phone-control parts Flutter can't reach run in a small native Kotlin layer, called from Dart over platform channels.

- **UI:** Flutter, `CupertinoApp`, no Material widgets; Doto + Inter fonts bundled
- **State and navigation:** Riverpod with `riverpod_generator`; `go_router` with Cupertino page transitions
- **Storage:** `drift` (SQLite) for records, `shared_preferences` for settings
- **Data layer:** every feature reads through a repository interface (`TaskRepository`, `UsageRepository` …) with two versions: `Mock…` (Phase 0) and `Real…` (later phases), switched in one place
- **Native Kotlin layer:** usage watcher foreground service, launching full-screen prompt pages, DND, greyscale, exact alarms, boot restore
- **Packages:** `home_widget` (widgets), `nothing_glyph_interface` (Glyphs), `sherpa_onnx` (voice), `just_audio` (alarm sounds), `file_picker` (importing your sounds), `flutter_local_notifications`

| Capability | Android API / permission | One-time step |
| --- | --- | --- |
| Read app usage time | `UsageStatsManager`, `PACKAGE_USAGE_STATS` | Grant Usage Access in Settings |
| Detect an app opening instantly | `AccessibilityService` (fine since it's not on the Play Store), with usage-event polling as backup | Turn on Veronica in Accessibility |
| Full-screen prompts | `SYSTEM_ALERT_WINDOW`, `USE_FULL_SCREEN_INTENT` | Allow "Display over other apps" |
| Do Not Disturb | `ACCESS_NOTIFICATION_POLICY` | Grant DND access |
| Greyscale | `WRITE_SECURE_SETTINGS`; set `accessibility_display_daltonizer_enabled` = 1 and `accessibility_display_daltonizer` = 0 | `adb shell pm grant com.isg32.veronica android.permission.WRITE_SECURE_SETTINGS`, or on the phone alone through Shizuku (see *Sharing Veronica*) |
| Glyphs | `com.nothing.ketchum.permission.ENABLE` | Glyph debug ADB command (see Glyph section) |
| Exact alarms | `USE_EXACT_ALARM` | None |
| Background watcher | `FOREGROUND_SERVICE`, battery unrestricted | Set battery to Unrestricted |
| Notifications, reboot | `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED` | Allow notifications |

## Sharing Veronica (greyscale without a computer)

Veronica is personal and sideloaded, but it should work for a friend with only their phone. Everything except greyscale is granted on the phone already. Greyscale needs `WRITE_SECURE_SETTINGS`, which Android only lets ADB (or root) grant; there is no on-device prompt for it.

**Plan: Shizuku.** [Shizuku](https://shizuku.rikka.app/) is a free app that starts an ADB-level service using Android's own **Wireless debugging** (Android 11+), so no computer is needed:

1. The friend installs Shizuku and starts it once from *Developer options → Wireless debugging* (Shizuku walks through pairing).
2. In Veronica's ADB step (onboarding and *Settings → Permissions & ADB*), a **Grant with Shizuku** button asks Shizuku for permission and runs `pm grant com.isg32.veronica android.permission.WRITE_SECURE_SETTINGS` through it.
3. Once granted, the permission stays; Shizuku is not needed again until a factory reset or reinstall.

Shizuku itself has to be restarted after every reboot, but Veronica only needs it for the one-time grant. The computer command stays documented as the fallback. Status: built (`ShizukuChannel.kt`, the Grant with Shizuku card in onboarding and Settings); awaiting the on-device test.

## Data model

Eight drift (SQLite) tables cover v1, and the same shapes are used for the mock data in Phase 0; all timestamps are stored as epoch millis so "added 1 day ago" is a simple subtraction.

| Table | Key fields |
| --- | --- |
| `WatchedApp` | packageName, dailyLimitMin, nudgeAtPercent, hardBlock, extensionsUsedToday |
| `UsageLog` | packageName, date, minutesUsed, nudgesShown, putDownAccepted |
| `Task` | id, title, createdAt, dueAt?, completedAt?, priority |
| `WaterLog` | id, timestamp, amountMl; goal in settings |
| `Medicine` / `DoseLog` | name, dose, times\[\], refillCount / medicineId, scheduledAt, status (taken, skipped, missed) |
| `Mode` | id, name, isPreset, greyscale, dnd, blockedApps\[\], waterOn, timerMin?, glyphPattern, schedule?, brightness?, ringerMode?, mediaVolume?, hideNotifications, blackWallpaper |
| `SleepSchedule` / `Alarm` | bedtime, wakeTime, windDownMin, days\[\] / time, sound, fadeInSec, glyphSunrise, days\[\] |
| `Mantra` | id, text, scheduledTime, lastShownAt |

Two additions for the new decisions: `AlarmSound` (id, displayName, filePath, importedAt) for sounds you import, and `VoiceLine` (id, trigger, text, voice, audioPath, renderedAt) for Veronica's pre-rendered lines, and `OverrideLog` (id, packageName, timestamp) for emergency overrides.

## Roadmap

Phase 0 builds every page, overlay and widget layout on mock data; Phases 1–4 then swap each mock for the real feature, one area at a time.

| Phase | Scope | Done when |
| --- | --- | --- |
| 0 · UI on mocks | Theme, components, and every page, overlay and widget layout from `design/`, all reading `Mock…Repository` | Every screen in DESIGN.md can be reached and matches the design on the Phone (2a) |
| 1 · Usage watcher | Kotlin foreground service, Accessibility app-open detection, usage stats, Put it down and Time's up overlays, limits, nudges, overrides | Opening a watched app past its limit shows Put it down within 1 s, and the counts survive a reboot |
| 2 · Modes & phone control | Preset and custom modes, schedules, quick-settings tile, DND, greyscale, brightness, volume, notification hiding, wallpaper | Starting Work turns on greyscale and DND and blocks apps; ending it restores everything |
| 3 · Care, tasks & sleep | drift storage for tasks, water, medicine and mantras; notifications; sleep wind-down; calm alarm with imported sounds | After a week of real use, no mock data remains on Today, Tasks, Care or Sleep |
| 4 · Glyph, voice & widgets | Glyph patterns, Kokoro/Piper download and pre-rendering, six home widgets (tinted glass first, fake blur after) | Every Glyph pattern plays from Settings, Veronica speaks offline, and widgets update and act without opening the app |

**Versioning.** Every completed phase bumps `version:` in `pubspec.yaml` (and `lib/app/version.dart`, which a test keeps in step), in its own `chore(release): …` commit:

| Milestone | Version |
| --- | --- |
| Phase 0 in progress | 0.0.x |
| Phase 0 done | 0.1.0 |
| Phase 1 done | 0.2.0 |
| Phase 2 done | 0.3.0 |
| Phase 3 done | 0.4.0 |
| Phase 4 done | 1.0.0 |

The build number after `+` goes up by one with every bump and never resets.

**Phase 0 rules.** Every screen reads from a `Mock…Repository`, never from hard-coded values inside a widget. Each mock lives in `lib/mock/` and is listed in `mockdata.md` at the repo root, so you always know what is fake. When a later phase wires a feature up, its row in `mockdata.md` flips from Mock to Real and the mock file is kept only for tests.

```markdown
# mockdata.md

| Dataset | File | Used on | Contents | Status |
| --- | --- | --- | --- | --- |
| Watched apps | lib/mock/usage_mock.dart | Today, Focus, Put it down | 5 apps (Instagram 42/60 min, YouTube 75/60 min …) | Mock |
| Tasks | lib/mock/tasks_mock.dart | Today, Tasks | 8 tasks, ages 0–10 days, 2 done | Mock |
| Water log | lib/mock/water_mock.dart | Today, Care | 5 of 8 glasses, times 08:10–15:40 | Mock |
| Medicines | lib/mock/medicine_mock.dart | Care, Medicine due | 2 medicines, 1 missed dose | Mock |
| Modes | lib/mock/modes_mock.dart | Focus, Today | Work, Go Out, Binge Time defaults | Mock |
| Sleep + alarms | lib/mock/sleep_mock.dart | Sleep, Alarm ringing | Bed 23:30, wake 07:00, 2 alarms | Mock |
| Mantras | lib/mock/mantra_mock.dart | Care, Mantra session | 6 mantras | Mock |
| Alarm sounds | lib/mock/sounds_mock.dart | Sleep | 3 placeholder names, no audio | Mock |
```

Each later phase is done only when its "Done when" holds on your phone, and Phase 1 starts with the usage watcher because everything else depends on it.

## Additions (7 Nov 2026)

| Addition | What it does | Status |
| --- | --- | --- |
| Glyph light test | *Settings → Glyph → Test the lights* runs every light in turn (C1–C24, B, A) and then all of them, on the preview and the real Glyphs; the page says whether the Phone (2a) lights were found | Done |
| Blurred status bar | Pages run edge to edge behind the status bar with an iOS-style progressive blur: strongest at the top, fading out 16 px below the bar, under a soft paper-coloured gradient | Done |
| Greyscale without ADB | Grant greyscale on the phone alone through Shizuku, so the app can be shared (see *Sharing Veronica*) | Built |
| Veronica's voice | Kokoro (kokoro-en-v0_19) downloaded once via sherpa-onnx, lines rendered once and cached, Android speech as the fallback; speaks on Put it down, Time's up, Medicine due, the mantra session and after the alarm | Built |
| Widgets refresh in the background | Next alarm and Binge Time are rendered ahead as frames and redrawn on schedule with the app closed; screen time updates when Veronica opens | Built |
| Medicine snooze | "Snooze 15 min" reminds again 15 minutes later | Built |

## Risks & open questions

Since this is a personal, sideloaded app, the Play Store risks are gone; what's left is mostly Android and Nothing OS limits.

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Glyphs only work while Veronica is in the foreground | No lights for background reminders | Prompts open as full-screen pages; try Nothing OS Glyph notifications for background |
| Glyph debug mode expires after 48 hours | Lights stop working | Check on Android 16 (no key needed); otherwise a Settings banner reminds you to re-run the command |
| Kokoro is slow on the 2a | Voice lags | Pre-render fixed lines; Piper for live lines; system TTS fallback |
| Home widgets can't blur live | Glass looks flat | Tinted glass first, fake-blur as an experiment |
| Cupertino default colours leak in | A blue switch or red button breaks the two-colour rule | One `VColors` class + a build test that bans other colours |
| ADB grants reset after a factory reset | Greyscale and Glyph stop | Permissions page shows status and the commands to re-run; Shizuku can re-grant on the phone |
| A shared copy has no computer for ADB | Greyscale can't be granted | Shizuku grant (see *Sharing Veronica*) |

**Decided:** personal use only with ADB · no Play Store · Phone (2a) only for Glyph · you supply the alarm sounds · Kokoro voice via sherpa-onnx.

- [x] Custom modes ship in v1 and can also control brightness, volume, notification hiding and wallpaper.
- [x] Veronica calls you by name; she asks for it during onboarding.
- [x] The 2a runs Android 16+, so the Glyph debug step is probably unnecessary. Veronica checks at runtime and shows the step only when it's needed.

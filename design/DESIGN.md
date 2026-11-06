# Veronica — design spec

This is the spec the Flutter code follows. It is distilled from [`Veronica Screens.dc.html`](Veronica%20Screens.dc.html) ("Screens v1", exported from Claude Design). When this file and the HTML disagree, the HTML wins on visuals and this file wins on behaviour.

| File | What it is |
| --- | --- |
| `Veronica Screens.dc.html` | All 37 screens on one canvas. Open it in a browser; it needs `support.js` next to it. |
| `support.js` | The Claude Design canvas runtime (generated, do not edit). |
| `reference/` | Local-only mood references (e.g. a Nothing OS Glyph settings screenshot). Git-ignored. |

The canvas also shows the widgets over two wallpapers (`wallpaper-dark.png` and `wallpaper-light.png`). Those images are not in the repo, so the widget mockups render on plain black.

## Rules

1. **Two colours only:** `#000000` and `#FFFFFF`, with no greys. The Nothing OS reference uses grey cards, but Veronica does not.
   Veronica follows the system theme, with no in-app toggle. Dark mode is white ink on black (as designed) and light mode is black ink on white; every component draws in the current ink, so the two are exact inverses.
   The one exception is the stand-in wallpaper behind the home-widget previews in Settings: dim, colourful, blurred light spots, since real widgets sit on a colourful wallpaper. The hues are named in `VColors.previewWallpaperSpots` and used nowhere else.
2. **Hierarchy** comes from size, weight, outline vs fill, dashed vs solid, and inversion.
3. **Translucency** is allowed only in the cases below. They are the only alpha values in `VColors`, and the banned-colour test enforces that.

| Surface | Fill | Blur | Border |
| --- | --- | --- | --- |
| Tab bar | white @ 0.10 (light: black @ 0.06) | 18 | 1 px ink |
| Overlay card (Mantra time) | white @ 0.08 (light: black @ 0.05) | 16 | 1 px ink |
| Bottom sheet | black @ 0.55 (light: white @ 0.60) | 14 | 1 px ink, top only |
| Widget, dark set | black @ 0.40 | 30* | none |
| Widget, light set | white @ 0.50 | 30* | none |
| Disabled primary button | whole button @ 0.35 | – | – |

\* Home-screen widgets can't blur live. "Tinted" (the default) is the tint alone; "Blur" reads the wallpaper (with All files access) and blurs the part behind each widget into its image, using positions the user sets in Settings → Widgets → Place widgets.

## Type

| Role | Font | Weight / size | Notes |
| --- | --- | --- | --- |
| Wordmark | Doto | 900 / 62, line 0.9 | `VERO` / `NICA` on two lines |
| Page title | Doto | 700 / 34, line 1 | Left-aligned, 20 px gutter |
| Hero number | Doto | 900 / 44–112 | Timers, totals, alarm time |
| Card number | Doto | 700 / 16–28 | Times in lists, `5/8`, `10d` |
| Overlay headline | Doto | 900 / 52–58, line 0.92 | `PUT IT / DOWN, / SAPAN` |
| Eyebrow | Inter | 500 / 11, tracking 0.1 em, UPPERCASE | `SCREEN TIME`, `STEP 2 OF 6` |
| Body | Inter | 400–500 / 14–15 | Row titles are 500 |
| Secondary | Inter | 300 / 12–13 | Row subtitles and footnotes |
| Button | Inter | 600 / 16 (primary), 500 / 15 (secondary) | |
| Mono (ADB) | ui-monospace | 400 / 11.5 | Inside a dashed box |

Bundle both fonts (both OFL): **Doto** (500, 700, 900) and **Inter** (300, 400, 500, 600).

## Layout & shape

- Screen gutter is 16 px for cards and 20 px for titles. The gap between cards is 12 px.
- The page title sits 16 px below the status bar. Detail pages put a `‹ Parent` back link (Inter 400 / 14) above the title, and an optional `Save` (Inter 600 / 14) on the right.
- Tab pages pad 120 px at the bottom so content clears the floating tab bar.
- **Radii:**
  - Cards: 20, or 24 for hero and mode cards
  - Task rows: 18
  - Sheets: 28 at the top
  - Overlay card: 28
  - App tile: 10
  - Pills, buttons and segmented controls: 999
- **Card:** a 1 px white border on black with 16 px padding. Inset-grouped lists are a single card with 1 px white dividers between rows (14–15 px vertical padding).

## Components

| Component | Spec |
| --- | --- |
| `VPrimaryButton` | White pill, black Inter 600 / 16 text, 16 px padding, full width. Disabled = opacity 0.35. |
| `VSecondaryButton` | 1 px white outline pill. |
| `VGhostButton` | 1 px **dashed** outline pill, for optional, skip, remove, "5 more minutes" and "Continue" before everything is granted. |
| `VLink` | Underlined text, offset 3. |
| `VCard` | 1 px white outline, radius 20. `inverted: true` gives a white fill with black content (the active mode, or the Glyph banner). `dashed: true` is used for the mantra strip. |
| `VListSection` / `VListRow` | Title (500 / 15) + optional subtitle (300 / 12) + trailing slot (value + chevron, switch, segmented control or stepper). |
| `VSwitch` | 46×28. On: white track with a 22 px black knob. Off: 1 px outline track with a 20 px outline knob. |
| `VSegmented` | Outline pill with 3 px padding; the selected segment is a white pill (600). Compact variant at 12 px (`50/80/90%`). |
| `VChip` | Outline pill, Inter 500 / 11. Filled chip (white, 600 / 12) means selected/included. Dashed chip means "+ Add" or "off" (e.g. `Water off`). |
| `VBadge` | Small inverted pill for over-limit (`75/60`, `+15`), states (`Taken`, `On`) and durations (`7h 30m`). |
| `VDayPicker` | 7 × 34 px circles; filled = on. |
| `VStepper` | 52 px (or 30 px) outline circles with − / + around a Doto number. |
| `VWheel` | Doto wheel: the selected value is 900 / 38 inside hairlines top and bottom, and neighbours are 500 / 18. Used for times and minutes. |
| `VRing` | 1 px **dotted** track (dasharray 1 4) with a 6–10 px round-cap arc from 12 o'clock. Sizes 96 / 170 / 260. |
| `VBar` | 6 px tall, radius 3, 1 px outline, white fill to the value. Full or over = solid white. |
| `VBarChart` | 7 white bars (18 px, top radius 3) with day initials; today's label is 600. Optional dashed limit line. |
| `VPairChart` | Planned (1 px outline + 45° hatch) beside actual (solid), with a legend. |
| `VDots` | Water glasses: filled = drunk, outline = remaining. 16 px on Today, 10 px weekly, 9 px widget. |
| `VAppTile` | 36 px, radius 10, 1 px outline, app initial in Doto 700 / 16. Use the real app icon once it's available (it renders monochrome). |
| `VTaskRow` | Round checkbox + title + age line + Doto age (`10d`) on the right. The border follows the age rules below. Swipe right shows a white "Complete" layer; swipe left deletes. |
| `VTabBar` | Floating capsule, 12 px from the sides, 22 px from the bottom, 62 tall, radius 31, glass. The active tab is a white pill (icon + Inter 600 / 12 label); inactive tabs show the icon only. |
| `VSheet` | Glass bottom sheet with a 36×4 handle. |
| `VBreatheCircle` | Dashed outer ring (180), solid inner ring (inset 22), and a 96 px white core with a Doto countdown and the `BREATHE` label. |
| `VSlideToStop` | 64 px outline track with a 52 px white knob and a chevron. |
| `VGlyphPreview` | Diagram of the Phone (2a) back: 24 C segments (arcs from 10° to 75°, unlit segments dotted, lit ones solid at 7 px), A (150–208°) and B (254–286°). |

**Task age border**

| Age | Border |
| --- | --- |
| < 3 days | 1 px solid |
| 3–6 days | 2 px (4 d) → 2.5 px (5–6 d) solid |
| ≥ 7 days | 1.5 px dashed |

The checkbox circle uses the same scale.

### Icons

The icons are a custom 1.5 px round-cap line set on a 24 px grid, not CupertinoIcons. Selected tabs draw at 2 px stroke in black inside the white pill.

| Name | SVG path |
| --- | --- |
| today (sun) | `M12 8a4 4 0 1 0 0 8a4 4 0 1 0 0-8M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4` |
| focus (target) | `M12 3a9 9 0 1 0 0 18a9 9 0 1 0 0-18M12 8a4 4 0 1 0 0 8a4 4 0 1 0 0-8` |
| tasks (check box) | `M5 4h14a1 1 0 0 1 1 1v14a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1zM8 12l3 3l5-6` |
| care (drop) | `M12 3c4 5 6 8 6 11a6 6 0 0 1-12 0c0-3 2-6 6-11z` |
| sleep (moon) | `M20 14.5A8 8 0 0 1 9.5 4a8 8 0 1 0 10.5 10.5z` |
| gear | `M12 9a3 3 0 1 0 0 6a3 3 0 1 0 0-6M12 2v3M12 19v3M2 12h3M19 12h3M4.9 4.9l2.1 2.1M17 17l2.1 2.1M4.9 19.1L7 17M17 7l2.1-2.1` |
| plus | `M12 5v14M5 12h14` |
| minus | `M5 12h14` |
| chevron | `M9 6l6 6l-6 6` (mirrored for back) |
| check | `M5 12l5 5l9-10` (stroke 3, inside a 26 px white circle) |
| search | `M11 4a7 7 0 1 0 0 14a7 7 0 1 0 0-14M16 16l5 5` |

## Screens

There are 37 screens, grouped as in the canvas. ✱ marks something the design adds to or changes from `docs/PLAN.md`.

**01 Onboarding.** The step dots and "STEP n OF 6" stay as designed. Accessibility is added as a 7th permission row.
1. Welcome: wordmark, one line, a voice-waveform pill ("Hello, Sapan. I'm Veronica."), 6 step dots, **Begin**. The name field also lives here.
2. Permissions: one card of permission rows. A white check circle marks granted, and a `Grant` outline pill marks to-do. "4 of 6 granted". The **Continue** button stays dashed until all are granted.
3. ADB setup: one card per command (status `Works` / `Not yet`, dashed mono box, `Copy`), "Expires after 48 h", **Check again**, and a "Skip for now" link. The Glyph card shows only when it's needed, and the package is `com.isg32.veronica`.
4. Watch apps: search pill ("Search 64 apps"), app rows with tile, name, "Limit 60 min a day" or "Not watched", and a switch. The footer reads "4 apps · 2h 50m a day in total".
5. Water goal: `Glasses | ml`, a stepper with a Doto 96 number ("8", "glasses a day · 2000 ml"), glass size `200 | 250 | 300 ml`, Wake / Sleep rows, and "Remind every 2 h · works out from your goal".
6. Sleep times: BEDTIME and WAKE wheels plus a `7h 30m of sleep` badge, then **Done**.

**02 Tabs**
7. Today
   - Eyebrow date and "Good evening, Sapan", with a gear circle.
   - Inverted mode card (`MODE`, `BINGE TIME`, "38:12 left · then put it down", `Switch`).
   - Screen time card: 96 ring, "2h 24m of 2h 50m across 4 apps", top 3 app bars with badges.
   - Water card (`5/8`, dots, `+1 glass`).
   - NEXT UP rows (Doto times).
   - OLDEST TASKS ("All 6 ›").
   - Dashed TODAY'S MANTRA strip.
   - "Weekly summary" link plus "7 nudges accepted".
8. Focus · Usage
   - `Usage | Modes` segmented control.
   - "WATCHED APPS TODAY" with a Doto 64 total and "26 min left in your limits".
   - App list with bars and a `+15` over badge.
   - Dashed "Add app" row.
   - Footnote on nudge points.
9. Focus · Modes: a mode card per mode (Doto 900 / 30 name, subtitle, `Start` chip, setting chips). The active card is inverted with a progress bar and an `On` badge. Footnote: "Tap to start. Long-press to edit." ✱ A "New mode" dashed card goes at the end.
10. Tasks: title plus a white `+` circle, `All · 6 | Old 3+ days | Done`, task rows, and a footnote.
11. Care: a 170 ring with "5/8, glasses · 1250 ml", `+1 glass`, `Undo`, and "Every 90 min · 07:00–23:00 · Next 21:40". Then the MEDICINE list ("1 missed this week"; `Taken` badge, or a `Taken | Skip` split) and the MANTRA card ("MANTRA · 07:15", "Rotate daily", 22 px text, `Start now`).
12. Sleep: TONIGHT (Bed / Wake in Doto 40 with a dashed connector and a `7h 30m` badge), Wind-down `15 | 30 | 60` with an explanation line, ALARMS with `+` (Doto 28 time, details, switch), LAST 7 NIGHTS pair chart, and "Average 6h 48m · estimated from screen-off time".
13. Settings
    - Inverted banner when the Glyph debug grant is expiring.
    - Rows: Permissions & ADB (`1 to fix`), Glyph (`60%`), Veronica's voice (`af_heart`), Widgets (`6`), Data, About (`0.1.0`).
    - Footer line.

**03 Full-screen pages and Glyph**
14. Active mode: "FOCUS 2 OF 4", `WORK`, a 260 ring with a Doto 64 `18:24` and "then a 5 min break", setting chips, and an outline **End mode** button.
15. Put it down: headline, "60 min on Instagram today. That was your limit.", a breathe circle counting down, and **Close app**, disabled until the countdown ends. Below that, a dashed "5 more minutes · 1 left today". ✱ Long-pressing the headline opens the emergency override.
16. Alarm ringing: date eyebrow, Doto 112 time, "Good morning, Sapan.", a fade-in meter ("Rain on tin · fading in, 2 of 4 min"), a "Tap to snooze · 9 min" link, and slide to stop.
17. Mantra session: `Close` and "● Voice on" at the top, the mantra in Inter 300 / 34, a 200 breathe ring (`BREATHE IN`, `00:38`), and "In for 4 · out for 6".
18. Time's up: same layout as Put it down, with "TIME'S UP", the breathe circle and a single **End** button.
19. Medicine due: "22:00 · DOSE 2 OF 2 TODAY", the name in Doto 52 (broken across lines), the dose line, a 180 circle showing tablets left, **Taken**, and `Snooze 15 min` | dashed `Skip`.
20. Mantra time: centred glass card ("07:15 · MANTRA TIME", "One minute for yourself, Sapan.", the mantra, **Start**, `Later`).
- Glyph previews: Put it down (C full, A lit), Alarm sunrise, Time's up, Medicine due (A + B), Mantra breathing, Water progress, Focus countdown.

**04 Widgets.** These sit on a 4-column grid of 76 px cells with 8 px gaps, in dark and light glass sets.
21. Dark set.
22. Light set.

The six widgets:

| Widget | Size | Shape and contents |
| --- | --- | --- |
| Screen time | 2×2 | **Circle** with a 160 ring and "2h 24m of 2h 50m" |
| Water | 2×1 | Pill with `5/8`, a 4×2 dot grid and a solid `+1` circle |
| Next alarm | 2×1 | Soft rectangle with `07:00` and "Alarm · 9h 56m" |
| Mode switch | 4×1 | Pill with Work / Go Out / Binge; the active one is solid and shows the time left |
| Oldest tasks | 4×2 | 3 rows with age checkboxes and Doto ages |
| Mantra | 4×1 | Pill with the mantra text |

**05 Detail pages & editors**
23. Weekly summary ("This week"): SCREEN TIME (`18h 54m`, avg, bar chart with dashed limit), WATER (dot rows Sat–Fri, "45 of 56 glasses"), SLEEP pair chart, NUDGES (`7/9` with squares, "You put the phone down 7 times when asked."). ✱ "Overrides used" goes under nudges.
24. App detail · Instagram: `42 min of 60 today` with a 7-day chart and limit line, a DAILY LIMIT wheel, `Nudge at 50 | 80 | 90%`, a Hard block switch, `5 more minutes 0 | 1 | 2`, and a dashed **Remove app**.
25. Mode editor · Work ("Edit Work" / Save): switches for Greyscale, DND ("Starred contacts can call"), Water reminders and Glyph ("Slow focus pulse"); BLOCKED APPS chips plus "+ Add"; TIMER `25/5 | 50/10 | None`; SCHEDULE day picker; ✱ **Starts / Ends** times. ✱ Custom modes add a name field plus brightness, volume, hide-notifications and black-wallpaper rows.
26. Add task sheet: a glass sheet over Tasks with NEW TASK, a title field, dashed "Add notes", Due date (date chip + switch), **Add**, and "The age label starts from when you add it."
27. Task detail: Doto 30 title, a dashed card with "10 days, waiting since Tue 27 Oct, 09:14", Due, ✱ Priority `Low | Mid | High`, NOTES, **Mark done**, and a dashed **Delete**.
28. Medicine editor: Name, Dose, TIMES chips plus "+ Add time", DAYS picker, Refill count stepper, ✱ "Remind to refill · when 5 are left", and a dashed **Delete medicine**.
29. Dose history ("Doses"): `13/14 taken this week`, grouped by day, with `Taken` (filled), `Due` (outline) and `Missed` (dashed).
30. Mantra library ("Mantras"): `Rotate daily | Fixed`, then the list: yours (with "shown on …" and a `Today` badge) and Starter mantras. Footnote: "Shown at 07:15. Veronica reads it aloud if voice is on."
31. Alarm editor: hour and minute wheels, REPEAT day picker, Sound (`Rain on tin ›`), `Fade in 1–5 minutes`, Glyph sunrise switch, `Snooze 5 | 9 | 15`, and a dashed **Delete alarm**.
32. Sound library ("Sounds"): rows with duration and import date, an `In use` badge or `Rename`, **Import from files**, and "MP3, M4A, OGG or WAV. No sounds ship with Veronica."

**06 Settings pages**
33. Permissions & ADB: 7 rows with `Granted` or `Fix`, and ADB GRANTS (Greyscale `WRITE_SECURE_SETTINGS`, Glyph debug "Expires in 31 h", `Copy command`). Footnote: "Re-run both after a factory reset."
34. Glyph: a large back preview, TEST PATTERNS (6 rows with `Play` / `Playing`), brightness, and Quiet hours `23:00 to 07:00`.
35. Veronica's voice: "Veronica speaks" switch; VOICE list (af_heart "Warm, soft", af_bella "Bright", af_nicole "Very soft, near-whisper", bf_emma "British"); Speed `0.9× | 1.0× | 1.1×`; WHEN SHE SPEAKS with 7 switches; "14 of 14 fixed lines pre-rendered. Lines with numbers use Piper." ✱ Plus a model download status row.
36. Widgets: the 6 widgets with their sizes, HOW TO ADD (3 numbered steps), and GLASS STYLE `Tinted | Fake blur` with an explanation.
37. Data & About: Export to JSON ("Last export: never"), Import from JSON ("Replaces current data"), Reset all data. ABOUT lists Veronica `0.1.0 · build 12` and the licences: Kokoro-82M (Apache 2.0), sherpa-onnx (Apache 2.0), Doto (OFL), Glyph Developer Kit (Nothing), nothing_glyph_interface (MIT).

## Copy & voice

- Calm and short. Second person, with the user's name in key moments ("Put it down, Sapan").
- Times are 24 h (`07:00`). Durations read `2h 24m`, `38:12`, `10d`.
- Dates read `Fri 20 Nov` and `FRIDAY 6 NOVEMBER` (eyebrow).
- No emoji, no exclamation marks, no guilt.
- Ages read "added today", "added 1 day ago", "added 10 days ago".

## Motion

- Transitions: 250 ms ease-out fades and slides, no bounce.
- Light haptic on every confirm.
- The breathing circles scale in for 4 s and out for 6 s.

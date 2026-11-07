import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/version.dart';
import '../../core/icons/v_icons.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_controls.dart';
import '../../core/widgets/v_glass.dart';
import '../../core/widgets/v_glyph_preview.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_page.dart';
import '../../core/widgets/v_pickers.dart';
import '../../core/widgets/v_surface.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../selectors.dart';
import '../../mock/seed.dart';
import '../home_widgets/home_widget_views.dart';
import 'glyph_frames.dart';
import 'widget_glass_pages.dart';
import 'widget_previews.dart';

/// Settings, behind the gear on Today.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final granted = ref.watch(permissionsProvider).value ?? const {};
    final adb = ref.watch(adbStatusProvider).value;
    final glyph = ref.watch(glyphSettingsProvider).value;
    final voice = ref.watch(voiceSettingsProvider).value;
    final now = ref.watch(currentTimeProvider);

    final toFix =
        granted.values.where((g) => !g).length +
        (adb != null && !adb.greyscaleGranted ? 1 : 0);
    final expiresIn = adb?.glyphDebugExpiresAt?.difference(now);
    final showBanner =
        adb != null &&
        adb.glyphDebugNeeded &&
        expiresIn != null &&
        expiresIn.inHours < 48;

    return VDetailPage(
      backLabel: 'Today',
      title: 'Settings',
      children: [
        if (showBanner)
          VCard(
            inverted: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expiresIn.isNegative
                            ? 'Glyph debug has expired'
                            : 'Glyph debug expires in ${expiresIn.inHours} h',
                        style: VText.inter(14, weight: 600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Re-run the ADB command to keep the lights',
                        style: VText.inter(12),
                      ),
                    ],
                  ),
                ),
                const CopyPill(AdbCommands.glyphDebug),
              ],
            ),
          ),
        VListSection(
          children: [
            VListRow(
              title: 'Permissions & ADB',
              subtitle: 'Live status and fix buttons',
              value: toFix == 0 ? 'All set' : '$toFix to fix',
              onTap: () => context.push(Routes.settingsPermissions),
            ),
            VListRow(
              title: 'Glyph',
              subtitle: 'Test patterns, brightness, quiet hours',
              value: glyph == null
                  ? null
                  : '${(glyph.brightness * 100).round()}%',
              onTap: () => context.push(Routes.settingsGlyph),
            ),
            VListRow(
              title: "Veronica's voice",
              subtitle: 'Voice, speed, when she speaks',
              value: voice == null
                  ? null
                  : (voice.enabled ? voice.voice.id : 'Off'),
              onTap: () => context.push(Routes.settingsVoice),
            ),
            VListRow(
              title: 'Widgets',
              subtitle: 'Previews and how to add',
              value: '6',
              onTap: () => context.push(Routes.settingsWidgets),
            ),
            VListRow(
              title: 'Data & About',
              subtitle: 'Export, import, reset, licences',
              value: kAppVersion,
              onTap: () => context.push(Routes.settingsData),
            ),
          ],
        ),
        if (kDebugMode) const _PromptPreviews(),
        const VFootnote('Veronica $kAppVersion · Kokoro · Doto · Glyph SDK'),
      ],
    );
  }
}

/// Debug-only shortcuts to the full-screen prompts, which otherwise appear
/// only when the native layer triggers them.
class _PromptPreviews extends StatelessWidget {
  const _PromptPreviews();

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      ('Put it down', Routes.putItDown('com.instagram.android')),
      ("Time's up", Routes.timesUp),
      ('Medicine due', Routes.medicineDue('m2')),
      ('Alarm ringing', Routes.alarmRinging('a1')),
      ('Mantra time', Routes.mantraTime),
      ('Mantra session', Routes.mantraSession),
    ];
    return VListSection(
      header: const VEyebrow(
        'Preview prompts',
        trailing: VEyebrowNote('debug'),
      ),
      children: [
        for (final (label, route) in rows)
          VListRow(title: label, onTap: () => context.push(route)),
      ],
    );
  }
}

/// A "Copy" pill that copies [text] and says "Copied" for a moment.
class CopyPill extends StatefulWidget {
  const CopyPill(this.text, {super.key, this.label = 'Copy'});

  final String text;
  final String label;

  @override
  State<CopyPill> createState() => _CopyPillState();
}

class _CopyPillState extends State<CopyPill> {
  bool _copied = false;
  Timer? _reset;

  @override
  void dispose() {
    _reset?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VPill(
      _copied ? 'Copied' : widget.label,
      style: VText.inter(12, weight: 600),
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: widget.text));
        setState(() => _copied = true);
        _reset?.cancel();
        _reset = Timer(const Duration(seconds: 2), () {
          if (mounted) setState(() => _copied = false);
        });
      },
    );
  }
}

/// Permissions & ADB: live status of every grant with fix buttons.
class PermissionsSettingsPage extends ConsumerWidget {
  const PermissionsSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final granted = ref.watch(permissionsProvider).value ?? const {};
    final adb = ref.watch(adbStatusProvider).value;
    final now = ref.watch(currentTimeProvider);
    final repo = ref.read(permissionRepositoryProvider);

    return VDetailPage(
      backLabel: 'Settings',
      title: 'Permissions',
      children: [
        VListSection(
          children: [
            for (final p in AppPermission.values)
              VListRow(
                title: p.label,
                subtitle: granted[p] == true ? null : p.reason,
                trailing: granted[p] == true
                    ? Text('Granted', style: VText.inter(13))
                    : VPill(
                        'Fix',
                        style: VText.inter(12, weight: 600),
                        onTap: () => repo.request(p),
                      ),
              ),
          ],
        ),
        if (adb != null)
          VListSection(
            header: const VEyebrow('ADB grants'),
            children: [
              VListRow(
                title: 'Greyscale',
                subtitle: 'WRITE_SECURE_SETTINGS',
                trailing: adb.greyscaleGranted
                    ? Text('Granted', style: VText.inter(13))
                    : const CopyPill(
                        AdbCommands.greyscale,
                        label: 'Copy command',
                      ),
              ),
              VListRow(
                title: 'Glyph debug',
                subtitle: !adb.glyphDebugNeeded
                    ? 'Not needed on this phone'
                    : adb.glyphDebugActive(now)
                    ? 'Expires in ${adb.glyphDebugExpiresAt!.difference(now).inHours} h'
                    : 'Off',
                trailing: adb.glyphDebugNeeded
                    ? const CopyPill(
                        AdbCommands.glyphDebug,
                        label: 'Copy command',
                      )
                    : null,
              ),
            ],
          ),
        const VFootnote('Re-run both after a factory reset.'),
      ],
    );
  }
}

/// Glyph: test each pattern, brightness and quiet hours.
class GlyphSettingsPage extends ConsumerStatefulWidget {
  const GlyphSettingsPage({super.key});

  @override
  ConsumerState<GlyphSettingsPage> createState() => _GlyphSettingsPageState();
}

class _GlyphSettingsPageState extends ConsumerState<GlyphSettingsPage>
    with SingleTickerProviderStateMixin {
  GlyphSignal _playing = GlyphSignal.alarmSunrise;
  late final Ticker _ticker = createTicker((elapsed) {
    setState(() => _t = elapsed.inMilliseconds / 1000);
  });
  double _t = 0;

  @override
  void initState() {
    super.initState();
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _play(GlyphSignal s) {
    setState(() {
      _playing = s;
      _t = 0;
    });
    _ticker
      ..stop()
      ..start();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(glyphSettingsProvider).value;
    if (s == null) return const SizedBox.shrink();
    final repo = ref.read(settingsRepositoryProvider);

    return VDetailPage(
      backLabel: 'Settings',
      title: 'Glyph',
      children: [
        Center(
          child: VGlyphPreview(frame: glyphFrameAt(_playing, _t), scale: 1.25),
        ),
        VListSection(
          header: const VEyebrow('Test patterns'),
          children: [
            for (final signal in GlyphSignal.values)
              VListRow(
                title: signal.label,
                trailing: signal == _playing
                    ? const VPill.badge('Playing')
                    : VPill(
                        'Play',
                        style: VText.inter(12, weight: 500),
                        onTap: () => _play(signal),
                      ),
                onTap: () => _play(signal),
              ),
          ],
        ),
        Text(_playing.description, style: VText.secondary),
        VListSection(
          children: [
            VListRow(
              title: 'Brightness',
              trailing: VSegmented<int>(
                compact: true,
                segments: const {
                  20: '20',
                  40: '40',
                  60: '60',
                  80: '80',
                  100: '100%',
                },
                value: (s.brightness * 100).round(),
                onChanged: (v) =>
                    repo.saveGlyph(s.copyWith(brightness: v / 100)),
              ),
            ),
            VListRow(
              title: 'Quiet hours',
              value: '${s.quietFrom.label} to ${s.quietTo.label}',
              onTap: () async {
                final from = await showTimePickerSheet(
                  context,
                  title: 'Quiet from',
                  initial: s.quietFrom,
                );
                if (from == null || !context.mounted) return;
                final to = await showTimePickerSheet(
                  context,
                  title: 'Quiet until',
                  initial: s.quietTo,
                );
                if (to == null) return;
                await repo.saveGlyph(s.copyWith(quietFrom: from, quietTo: to));
              },
            ),
          ],
        ),
        const VFootnote(
          'Only Veronica in the foreground can light the Glyphs, so reminders '
          'open as full-screen pages.',
        ),
      ],
    );
  }
}

/// Veronica's voice: on/off, voice, speed and which moments she speaks.
class VoiceSettingsPage extends ConsumerWidget {
  const VoiceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(voiceSettingsProvider).value;
    if (v == null) return const SizedBox.shrink();
    final repo = ref.read(settingsRepositoryProvider);
    void save(VoiceSettings next) => repo.saveVoice(next);

    return VDetailPage(
      backLabel: 'Settings',
      title: 'Voice',
      children: [
        VListSection(
          children: [
            VListRow(
              title: 'Veronica speaks',
              trailing: VSwitch(
                value: v.enabled,
                onChanged: (on) => save(v.copyWith(enabled: on)),
              ),
            ),
            VListRow(
              title: 'Voice model',
              subtitle: 'Kokoro-82M, downloaded once and kept offline',
              value: switch (v.modelState) {
                VoiceModelState.ready => 'Ready',
                VoiceModelState.downloading =>
                  '${(v.downloadProgress * 100).round()}%',
                VoiceModelState.notDownloaded => 'Download',
              },
            ),
          ],
        ),
        VListSection(
          header: const VEyebrow('Voice'),
          children: [
            for (final voice in KokoroVoice.values)
              VListRow(
                title: voice.id,
                subtitle: voice.description,
                trailing: voice == v.voice ? const _Check() : null,
                onTap: () => save(v.copyWith(voice: voice)),
                chevron: false,
              ),
          ],
        ),
        VListSection(
          children: [
            VListRow(
              title: 'Speed',
              trailing: VSegmented<int>(
                compact: true,
                segments: const {9: '0.9×', 10: '1.0×', 11: '1.1×'},
                value: (v.speed * 10).round(),
                onChanged: (s) => save(v.copyWith(speed: s / 10)),
              ),
            ),
          ],
        ),
        VListSection(
          header: const VEyebrow('When she speaks'),
          children: [
            for (final m in VoiceMoment.values)
              VListRow(
                title: m.label,
                trailing: VSwitch(
                  value: v.moments.contains(m),
                  onChanged: (on) => save(
                    v.copyWith(
                      moments: on
                          ? {...v.moments, m}
                          : ({...v.moments}..remove(m)),
                    ),
                  ),
                ),
              ),
          ],
        ),
        VFootnote(
          '${v.linesRendered} of ${v.linesTotal} fixed lines pre-rendered. '
          'Lines with numbers use Piper.',
        ),
      ],
    );
  }
}

class _Check extends StatelessWidget {
  const _Check();

  @override
  Widget build(BuildContext context) {
    return const VCircleButton(icon: VIcon.check, filled: true, size: 26);
  }
}

/// Widgets: previews, sizes, how to add, glass style.
class WidgetsSettingsPage extends StatefulWidget {
  const WidgetsSettingsPage({super.key});

  @override
  State<WidgetsSettingsPage> createState() => _WidgetsSettingsPageState();
}

class _WidgetsSettingsPageState extends State<WidgetsSettingsPage> {
  bool _light = false;

  @override
  Widget build(BuildContext context) {
    const steps = [
      'Long-press the home screen',
      'Tap Widgets and find Veronica',
      'Drag one onto the grid',
    ];
    return VDetailPage(
      backLabel: 'Settings',
      title: 'Widgets',
      children: [
        VSegmented<bool>(
          segments: const {false: 'Dark glass', true: 'Light glass'},
          value: _light,
          onChanged: (v) => setState(() => _light = v),
        ),
        WidgetPreviewBackdrop(
          light: _light,
          child: WidgetPreviewGrid(light: _light),
        ),
        VListSection(
          children: [
            for (final k in HomeWidgetKind.values)
              VListRow(title: k.label, value: k.sizeLabel),
          ],
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VEyebrow('How to add'),
              for (final (i, step) in steps.indexed) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    VPill.badge('${i + 1}'),
                    const SizedBox(width: 12),
                    Expanded(child: Text(step, style: VText.inter(14))),
                  ],
                ),
              ],
            ],
          ),
        ),
        const GlassStyleSection(),
      ],
    );
  }
}

/// Data & About: export, import, reset, and licences.
class DataSettingsPage extends ConsumerWidget {
  const DataSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void notYet() => showVSheet<void>(
      context,
      title: 'Not yet',
      builder: (_) => const VFootnote(
        'Export and import arrive with on-device storage. Right now Veronica '
        'is running on sample data.',
      ),
    );

    const licences = [
      ('Kokoro-82M', 'Apache 2.0'),
      ('sherpa-onnx', 'Apache 2.0'),
      ('Doto', 'OFL'),
      ('Inter', 'OFL'),
      ('Glyph Developer Kit', 'Nothing'),
      ('nothing_glyph_interface', 'MIT'),
    ];

    return VDetailPage(
      backLabel: 'Settings',
      title: 'Data',
      children: [
        VListSection(
          children: [
            VListRow(
              title: 'Export to JSON',
              subtitle: 'Last export: never',
              trailing: VPill(
                'Export',
                style: VText.inter(12, weight: 600),
                onTap: notYet,
              ),
            ),
            VListRow(
              title: 'Import from JSON',
              subtitle: 'Replaces current data',
              onTap: notYet,
            ),
            VListRow(
              title: 'Reset all data',
              subtitle: 'Deletes everything and starts onboarding again',
              onTap: () => showVSheet<void>(
                context,
                title: 'Reset all data?',
                builder: (sheet) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VFootnote(
                      'Everything Veronica keeps on this phone is deleted.',
                    ),
                    const SizedBox(height: 14),
                    VButton.primary(
                      'Reset',
                      onPressed: () async {
                        Navigator.of(sheet).pop();
                        await ref.read(databaseProvider).resetAll();
                      },
                    ),
                    const SizedBox(height: 10),
                    VButton.secondary(
                      'Cancel',
                      onPressed: () => Navigator.of(sheet).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (kDebugMode)
          VListSection(
            header: const VEyebrow('Debug', trailing: VEyebrowNote('debug')),
            children: [
              VListRow(
                title: 'Load sample data',
                subtitle: 'Replaces everything with the design\'s sample data',
                onTap: () async {
                  final db = ref.read(databaseProvider);
                  await db.resetAll();
                  await seedSampleData(db);
                },
              ),
            ],
          ),
        VListSection(
          header: const VEyebrow('About'),
          children: [
            const VListRow(
              title: 'Veronica',
              value: '$kAppVersion · build $kAppBuild',
            ),
            const VListRow(title: 'Licence', value: 'GPL-3.0'),
            for (final (name, licence) in licences)
              VListRow(title: name, value: licence),
          ],
        ),
        const VFootnote(
          'Made for the Nothing Phone (2a). Offline and private.',
        ),
      ],
    );
  }
}

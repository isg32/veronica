import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/format.dart';
import '../../core/icons/v_icons.dart';
import '../../core/ids.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_controls.dart';
import '../../core/widgets/v_glass.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_page.dart';
import '../../core/widgets/v_pickers.dart';
import '../../core/widgets/v_surface.dart';
import '../../core/widgets/v_wheel.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../../platform/device_sounds.dart';

/// Add or edit an alarm (`id == 'new'` adds). Draft until "Save".
class AlarmEditorPage extends ConsumerStatefulWidget {
  const AlarmEditorPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<AlarmEditorPage> createState() => _AlarmEditorPageState();
}

class _AlarmEditorPageState extends ConsumerState<AlarmEditorPage> {
  Alarm? _draft;

  bool get _isNew => widget.id == Routes.newId;

  void _set(Alarm Function(Alarm a) change) =>
      setState(() => _draft = change(_draft!));

  Future<void> _save() async {
    await ref.read(sleepRepositoryProvider).saveAlarm(_draft!);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final alarms = ref.watch(alarmsProvider).value;
    final sounds = ref.watch(soundsProvider).value ?? const <AlarmSound>[];
    if (alarms == null) return const SizedBox.shrink();
    _draft ??=
        alarms.where((a) => a.id == widget.id).firstOrNull ??
        Alarm(
          id: newId('alarm'),
          time: const DayTime(7, 0),
          days: Weekdays.weekdays,
          soundId: sounds.isEmpty ? null : sounds.first.id,
        );
    final a = _draft!;
    final sound = sounds.where((s) => s.id == a.soundId).firstOrNull;

    return VDetailPage(
      backLabel: 'Sleep',
      title: 'Alarm',
      action: VTextAction('Save', onTap: _save),
      children: [
        VCard(
          child: VTimeWheel(
            hour: a.time.hour,
            minute: a.time.minute,
            minuteStep: 1,
            onChanged: (h, m) => _set((a) => a.copyWith(time: DayTime(h, m))),
          ),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VEyebrow(
                'Repeat',
                trailing: VEyebrowNote(VFormat.daysWord(a.days)),
              ),
              const SizedBox(height: 12),
              VDayPicker(
                days: a.days,
                onChanged: (d) => _set((a) => a.copyWith(days: d)),
              ),
            ],
          ),
        ),
        VListSection(
          children: [
            VListRow(
              title: 'Sound',
              value: sound?.name ?? 'Import one',
              onTap: () => sounds.isEmpty
                  ? context.push(Routes.sounds)
                  : _pickSound(sounds),
            ),
            VListRow(
              title: 'Fade in',
              subtitle: 'minutes',
              trailing: VSegmented<int>(
                compact: true,
                segments: const {1: '1', 2: '2', 3: '3', 4: '4', 5: '5'},
                value: a.fadeInMin,
                onChanged: (v) => _set((a) => a.copyWith(fadeInMin: v)),
              ),
            ),
            VListRow(
              title: 'Glyph sunrise',
              subtitle: 'Lights ramp up with the sound',
              trailing: VSwitch(
                value: a.glyphSunrise,
                onChanged: (v) => _set((a) => a.copyWith(glyphSunrise: v)),
              ),
            ),
            VListRow(
              title: 'Snooze',
              subtitle: 'minutes',
              trailing: VSegmented<int>(
                compact: true,
                segments: const {5: '5', 9: '9', 15: '15'},
                value: a.snoozeMin,
                onChanged: (v) => _set((a) => a.copyWith(snoozeMin: v)),
              ),
            ),
          ],
        ),
        if (!_isNew)
          VButton.ghost(
            'Delete alarm',
            onPressed: () async {
              await ref.read(sleepRepositoryProvider).deleteAlarm(a.id);
              if (context.mounted) context.pop();
            },
          ),
      ],
    );
  }

  Future<void> _pickSound(List<AlarmSound> sounds) async {
    final chosen = await showVSheet<String>(
      context,
      title: 'Sound',
      builder: (context) =>
          _SoundPicker(sounds: sounds, selected: _draft!.soundId),
    );
    if (chosen == _library) {
      if (mounted) unawaited(context.push(Routes.sounds));
    } else if (chosen != null) {
      _set((a) => a.copyWith(soundId: chosen));
    }
  }
}

const _library = '#library';

/// Tap a sound to hear it; "Use this sound" chooses it.
class _SoundPicker extends ConsumerStatefulWidget {
  const _SoundPicker({required this.sounds, required this.selected});

  final List<AlarmSound> sounds;
  final String? selected;

  @override
  ConsumerState<_SoundPicker> createState() => _SoundPickerState();
}

class _SoundPickerState extends ConsumerState<_SoundPicker> {
  late String? _chosen = widget.selected;
  late final SoundPreview _preview = SoundPreview(
    ref.read(sleepRepositoryProvider).soundPath,
  );

  @override
  void dispose() {
    _preview.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String?>(
    valueListenable: _preview,
    builder: (context, playing, _) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VListSection(
          children: [
            for (final s in widget.sounds)
              VListRow(
                title: s.name,
                subtitle: [
                  if (s.fromPhone) 'On this phone',
                  if (s.length > Duration.zero) VFormat.length(s.length),
                  if (s.id == playing) 'Playing',
                ].join(' · '),
                trailing: s.id == _chosen
                    ? const VCircleButton(
                        icon: VIcon.check,
                        filled: true,
                        size: 26,
                      )
                    : null,
                chevron: false,
                onTap: () {
                  setState(() => _chosen = s.id);
                  unawaited(_preview.toggle(s.id));
                },
              ),
          ],
        ),
        const SizedBox(height: 14),
        VButton.primary(
          'Use this sound',
          onPressed: _chosen == null
              ? null
              : () => Navigator.of(context).pop(_chosen),
        ),
        const SizedBox(height: 10),
        VButton.ghost(
          'Sound library',
          onPressed: () => Navigator.of(context).pop(_library),
        ),
      ],
    ),
  );
}

/// The phone's own alarm tones and the sounds you imported.
/// Tap a sound to hear it.
class SoundLibraryPage extends ConsumerStatefulWidget {
  const SoundLibraryPage({super.key});

  @override
  ConsumerState<SoundLibraryPage> createState() => _SoundLibraryPageState();
}

class _SoundLibraryPageState extends ConsumerState<SoundLibraryPage> {
  late final SoundPreview _preview = SoundPreview(
    ref.read(sleepRepositoryProvider).soundPath,
  );

  @override
  void initState() {
    super.initState();
    _preview.addListener(_changed);
  }

  void _changed() => setState(() {});

  @override
  void dispose() {
    _preview.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(soundsProvider).value ?? const <AlarmSound>[];
    final phone = all.where((s) => s.fromPhone).toList();
    final sounds = all.where((s) => !s.fromPhone).toList();
    final alarms = ref.watch(alarmsProvider).value ?? const <Alarm>[];
    final inUse = {for (final a in alarms) ?a.soundId};
    final repo = ref.read(sleepRepositoryProvider);

    return VDetailPage(
      backLabel: 'Sleep',
      title: 'Sounds',
      children: [
        if (sounds.isNotEmpty)
          VListSection(
            header: const VEyebrow('Imported'),
            children: [
              for (final s in sounds)
                VListRow(
                  title: s.name,
                  subtitle:
                      '${VFormat.length(s.length)} · imported ${VFormat.dayMonth(s.importedAt)}',
                  trailing: inUse.contains(s.id)
                      ? const VPill.badge('In use')
                      : VPill(
                          'Rename',
                          style: VText.inter(12, weight: 500),
                          onTap: () async {
                            final name = await showTextSheet(
                              context,
                              title: 'Rename',
                              initial: s.name,
                            );
                            if (name != null) {
                              await repo.renameSound(s.id, name);
                            }
                          },
                        ),
                  onTap: inUse.contains(s.id)
                      ? null
                      : () => showVSheet<void>(
                          context,
                          title: s.name,
                          builder: (context) => VButton.ghost(
                            'Delete sound',
                            onPressed: () {
                              Navigator.of(context).pop();
                              repo.deleteSound(s.id);
                            },
                          ),
                        ),
                ),
            ],
          ),
        VButton.primary('Import from files', onPressed: repo.importSound),
        const VFootnote('MP3, M4A, OGG or WAV.', center: true),
        if (phone.isNotEmpty)
          VListSection(
            header: const VEyebrow('On this phone'),
            children: [
              for (final s in phone)
                VListRow(
                  title: s.name,
                  subtitle: [
                    if (s.length > Duration.zero) VFormat.length(s.length),
                    if (s.id == _preview.playing) 'Playing' else 'Alarm tone',
                  ].join(' · '),
                  trailing: inUse.contains(s.id)
                      ? const VPill.badge('In use')
                      : null,
                  chevron: false,
                  onTap: () => _preview.toggle(s.id),
                ),
            ],
          ),
      ],
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/format.dart';
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

  Future<void> _pickSound(List<AlarmSound> sounds) {
    return showVSheet<void>(
      context,
      title: 'Sound',
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VListSection(
            children: [
              for (final s in sounds)
                VListRow(
                  title: s.name,
                  subtitle: VFormat.length(s.length),
                  trailing: s.id == _draft!.soundId
                      ? const VPill.badge('In use')
                      : null,
                  onTap: () {
                    _set((a) => a.copyWith(soundId: s.id));
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
          VButton.ghost(
            'Sound library',
            onPressed: () {
              Navigator.of(context).pop();
              this.context.push(Routes.sounds);
            },
          ),
        ],
      ),
    );
  }
}

/// The phone's own alarm tones and the sounds you imported.
class SoundLibraryPage extends ConsumerWidget {
  const SoundLibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  subtitle: s.length == Duration.zero
                      ? 'Alarm tone'
                      : '${VFormat.length(s.length)} · alarm tone',
                  trailing: inUse.contains(s.id)
                      ? const VPill.badge('In use')
                      : null,
                  chevron: false,
                ),
            ],
          ),
      ],
    );
  }
}

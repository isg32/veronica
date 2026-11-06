import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/format.dart';
import '../../core/ids.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_controls.dart';
import '../../core/widgets/v_glass.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_page.dart';
import '../../core/widgets/v_pickers.dart';
import '../../core/widgets/v_surface.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';

/// Edits a mode, or creates a custom one (`id == 'new'`). Changes are kept
/// in a draft until "Save".
class ModeEditorPage extends ConsumerStatefulWidget {
  const ModeEditorPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ModeEditorPage> createState() => _ModeEditorPageState();
}

class _ModeEditorPageState extends ConsumerState<ModeEditorPage> {
  Mode? _draft;
  final _name = TextEditingController();

  bool get _isNew => widget.id == Routes.newModeId;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Mode _initial(List<Mode> modes) {
    final existing = modes.where((m) => m.id == widget.id).firstOrNull;
    if (existing != null) return existing;
    return Mode(id: newId('mode'), name: '', purpose: 'Your own mode');
  }

  void _set(Mode Function(Mode m) change) =>
      setState(() => _draft = change(_draft!));

  Future<void> _save() async {
    var mode = _draft!;
    if (!mode.isPreset) {
      final name = _name.text.trim();
      if (name.isEmpty) return;
      mode = mode.copyWith(name: name);
    }
    await ref.read(modeRepositoryProvider).save(mode);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final modes = ref.watch(modesProvider).value;
    if (modes == null) return const SizedBox.shrink();
    if (_draft == null) {
      _draft = _initial(modes);
      _name.text = _draft!.name;
    }
    final mode = _draft!;
    final installed =
        ref.watch(installedAppsProvider).value ?? const <InstalledApp>[];
    final names = {for (final a in installed) a.packageName: a.name};

    return VDetailPage(
      backLabel: 'Modes',
      title: _isNew ? 'New mode' : 'Edit ${mode.name}',
      action: VTextAction('Save', onTap: _save),
      children: [
        if (!mode.isPreset)
          VTextField(controller: _name, placeholder: 'Name, e.g. Reading'),
        VListSection(
          children: [
            VListRow(
              title: 'Greyscale',
              trailing: VSwitch(
                value: mode.greyscale,
                onChanged: (v) => _set((m) => m.copyWith(greyscale: v)),
              ),
            ),
            VListRow(
              title: 'Do Not Disturb',
              subtitle: mode.dnd == DndPolicy.off ? null : mode.dnd.label,
              trailing: VSwitch(
                value: mode.dnd != DndPolicy.off,
                onChanged: (v) => _set(
                  (m) => m.copyWith(dnd: v ? DndPolicy.starred : DndPolicy.off),
                ),
              ),
            ),
            if (mode.dnd != DndPolicy.off)
              VListRow(
                title: 'Who can reach you',
                trailing: VSegmented<DndPolicy>(
                  compact: true,
                  segments: const {
                    DndPolicy.starred: 'Starred',
                    DndPolicy.calls: 'Calls',
                  },
                  value: mode.dnd,
                  onChanged: (v) => _set((m) => m.copyWith(dnd: v)),
                ),
              ),
            VListRow(
              title: 'Water reminders',
              trailing: VSwitch(
                value: mode.waterOn,
                onChanged: (v) => _set((m) => m.copyWith(waterOn: v)),
              ),
            ),
            VListRow(
              title: 'Glyph',
              subtitle: mode.glyph == GlyphPattern.off
                  ? null
                  : mode.glyph.label,
              trailing: VSwitch(
                value: mode.glyph != GlyphPattern.off,
                onChanged: (v) => _set(
                  (m) => m.copyWith(
                    glyph: v
                        ? (m.timer == ModeTimer.fixed
                              ? GlyphPattern.countdown
                              : GlyphPattern.focusPulse)
                        : GlyphPattern.off,
                  ),
                ),
              ),
            ),
          ],
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VEyebrow(
                'Blocked apps',
                trailing: VEyebrowNote('${mode.blockedApps.length}'),
              ),
              const SizedBox(height: 12),
              VChoiceChips<String>(
                options: {for (final p in mode.blockedApps) p: names[p] ?? p},
                selected: mode.blockedApps,
                onToggle: (p) => _set(
                  (m) => m.copyWith(blockedApps: {...m.blockedApps}..remove(p)),
                ),
                addLabel: '+ Add',
                onAdd: () => _pickApps(context, installed),
              ),
            ],
          ),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VEyebrow('Timer'),
              const SizedBox(height: 12),
              VSegmented<ModeTimer>(
                segments: {
                  ModeTimer.pomodoro25: ModeTimer.pomodoro25.label,
                  ModeTimer.pomodoro50: ModeTimer.pomodoro50.label,
                  ModeTimer.fixed: 'Fixed',
                  ModeTimer.none: ModeTimer.none.label,
                },
                value: mode.timer,
                onChanged: (v) => _set(
                  (m) => m.copyWith(timer: v, timerMin: m.timerMin ?? 60),
                ),
              ),
              if (mode.timer == ModeTimer.fixed) ...[
                const SizedBox(height: 12),
                VSegmented<int>(
                  segments: const {30: '30 min', 60: '60 min', 90: '90 min'},
                  value: mode.timerMin ?? 60,
                  onChanged: (v) => _set((m) => m.copyWith(timerMin: v)),
                ),
              ],
            ],
          ),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VEyebrow(
                'Schedule',
                trailing: VEyebrowNote(
                  mode.schedule == null
                      ? 'off'
                      : VFormat.daysWord(mode.schedule!.days),
                ),
              ),
              const SizedBox(height: 12),
              VDayPicker(
                days: mode.schedule?.days ?? const {},
                onChanged: (days) => _set(
                  (m) => days.isEmpty
                      ? m.copyWith(clearSchedule: true)
                      : m.copyWith(
                          schedule: ModeSchedule(
                            days: days,
                            start: m.schedule?.start ?? const DayTime(10, 0),
                            end: m.schedule?.end,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
        if (mode.schedule != null)
          VListSection(
            children: [
              VListRow(
                title: 'Starts',
                value: mode.schedule!.start.label,
                onTap: () => _pickTime(start: true),
              ),
              VListRow(
                title: 'Ends',
                value: mode.schedule!.end?.label ?? 'Manually',
                onTap: () => _pickTime(start: false),
              ),
            ],
          ),
        if (!mode.isPreset) ...[
          VListSection(
            header: const VEyebrow('More'),
            children: [
              VListRow(
                title: 'Dim screen',
                subtitle: mode.brightness == null
                    ? 'Keep brightness'
                    : '${(mode.brightness! * 100).round()}% brightness',
                trailing: VSwitch(
                  value: mode.brightness != null,
                  onChanged: (v) => _set(
                    (m) => v
                        ? m.copyWith(brightness: 0.3)
                        : m.copyWith(clearBrightness: true),
                  ),
                ),
              ),
              if (mode.brightness != null)
                VListRow(
                  title: 'Brightness',
                  trailing: VSegmented<int>(
                    compact: true,
                    segments: const {10: '10', 30: '30', 50: '50%'},
                    value: (mode.brightness! * 100).round(),
                    onChanged: (v) =>
                        _set((m) => m.copyWith(brightness: v / 100)),
                  ),
                ),
              VListRow(
                title: 'Ringer',
                trailing: VSegmented<RingerMode?>(
                  compact: true,
                  segments: const {
                    null: 'Keep',
                    RingerMode.vibrate: 'Vibrate',
                    RingerMode.silent: 'Silent',
                  },
                  value: mode.ringer,
                  onChanged: (v) => _set(
                    (m) => v == null
                        ? m.copyWith(clearRinger: true)
                        : m.copyWith(ringer: v),
                  ),
                ),
              ),
              VListRow(
                title: 'Hide notifications',
                subtitle: 'Keep the shade empty',
                trailing: VSwitch(
                  value: mode.hideNotifications,
                  onChanged: (v) =>
                      _set((m) => m.copyWith(hideNotifications: v)),
                ),
              ),
              VListRow(
                title: 'Black wallpaper',
                subtitle: 'Restored when the mode ends',
                trailing: VSwitch(
                  value: mode.blackWallpaper,
                  onChanged: (v) => _set((m) => m.copyWith(blackWallpaper: v)),
                ),
              ),
            ],
          ),
          if (!_isNew)
            VButton.ghost(
              'Delete mode',
              onPressed: () async {
                await ref.read(modeRepositoryProvider).delete(mode.id);
                if (context.mounted) context.pop();
              },
            ),
        ],
      ],
    );
  }

  Future<void> _pickTime({required bool start}) async {
    final s = _draft!.schedule!;
    final picked = await showTimePickerSheet(
      context,
      title: start ? 'Starts' : 'Ends',
      initial: start
          ? s.start
          : (s.end ?? s.start.add(const Duration(hours: 3))),
    );
    if (picked == null) return;
    _set(
      (m) => m.copyWith(
        schedule: ModeSchedule(
          days: s.days,
          start: start ? picked : s.start,
          end: start ? s.end : picked,
        ),
      ),
    );
  }

  Future<void> _pickApps(BuildContext context, List<InstalledApp> apps) {
    return showVSheet<void>(
      context,
      title: 'Block apps',
      builder: (context) => StatefulBuilder(
        builder: (context, setSheet) => VListSection(
          children: [
            for (final a in apps)
              VListRow(
                title: a.name,
                trailing: VSwitch(
                  value: _draft!.blockedApps.contains(a.packageName),
                  onChanged: (on) {
                    _set((m) {
                      final next = {...m.blockedApps};
                      on ? next.add(a.packageName) : next.remove(a.packageName);
                      return m.copyWith(
                        blockedApps: next,
                        appPolicy: next.isEmpty
                            ? m.appPolicy
                            : AppPolicy.blocked,
                      );
                    });
                    setSheet(() {});
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

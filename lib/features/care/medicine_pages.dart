import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/format.dart';
import '../../core/ids.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_controls.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_page.dart';
import '../../core/widgets/v_pickers.dart';
import '../../core/widgets/v_surface.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../selectors.dart';

/// Add or edit a medicine (`id == 'new'` adds). Draft until "Save".
class MedicineEditorPage extends ConsumerStatefulWidget {
  const MedicineEditorPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<MedicineEditorPage> createState() => _MedicineEditorPageState();
}

class _MedicineEditorPageState extends ConsumerState<MedicineEditorPage> {
  Medicine? _draft;

  bool get _isNew => widget.id == Routes.newId;

  void _set(Medicine Function(Medicine m) change) =>
      setState(() => _draft = change(_draft!));

  Future<void> _save() async {
    final m = _draft!;
    if (m.name.trim().isEmpty || m.times.isEmpty) return;
    await ref.read(medicineRepositoryProvider).save(m);
    if (mounted) context.pop();
  }

  Future<void> _editText({
    required String title,
    required String initial,
    required Medicine Function(Medicine m, String v) apply,
  }) async {
    final v = await showTextSheet(context, title: title, initial: initial);
    if (v != null) _set((m) => apply(m, v));
  }

  @override
  Widget build(BuildContext context) {
    final meds = ref.watch(medicinesProvider).value;
    if (meds == null) return const SizedBox.shrink();
    _draft ??=
        meds.where((m) => m.id == widget.id).firstOrNull ??
        Medicine(
          id: newId('med'),
          name: '',
          dose: '1 tablet',
          times: const [DayTime(9, 0)],
          refillCount: 30,
        );
    final m = _draft!;
    final times = [...m.times]..sort();

    return VDetailPage(
      backLabel: 'Care',
      title: m.name.isEmpty ? 'New medicine' : m.name,
      action: VTextAction('Save', onTap: _save),
      children: [
        VListSection(
          children: [
            VListRow(
              title: 'Name',
              value: m.name.isEmpty ? 'Add' : m.name,
              onTap: () => _editText(
                title: 'Name',
                initial: m.name,
                apply: (m, v) => m.copyWith(name: v),
              ),
            ),
            VListRow(
              title: 'Dose',
              value: m.dose,
              onTap: () => _editText(
                title: 'Dose',
                initial: m.dose,
                apply: (m, v) => m.copyWith(dose: v),
              ),
            ),
          ],
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VEyebrow('Times'),
              const SizedBox(height: 12),
              VChoiceChips<DayTime>(
                options: {for (final t in times) t: t.label},
                selected: times.toSet(),
                onToggle: times.length == 1
                    ? null
                    : (t) => _set(
                        (m) => m.copyWith(
                          times: m.times.where((x) => x != t).toList(),
                        ),
                      ),
                addLabel: '+ Add time',
                onAdd: () async {
                  final t = await showTimePickerSheet(
                    context,
                    title: 'Add time',
                    initial: const DayTime(21, 0),
                  );
                  if (t != null && !m.times.contains(t)) {
                    _set((m) => m.copyWith(times: [...m.times, t]));
                  }
                },
              ),
              if (times.length > 1) ...[
                const SizedBox(height: 10),
                Text('Tap a time to remove it.', style: VText.secondary),
              ],
            ],
          ),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VEyebrow(
                'Days',
                trailing: VEyebrowNote(VFormat.daysWord(m.days)),
              ),
              const SizedBox(height: 12),
              VDayPicker(
                days: m.days,
                onChanged: (d) {
                  if (d.isNotEmpty) _set((m) => m.copyWith(days: d));
                },
              ),
            ],
          ),
        ),
        VListSection(
          children: [
            VListRow(
              title: 'Refill count',
              subtitle: 'Tablets left',
              trailing: VStepper(
                value: m.refillCount,
                onChanged: (v) => _set((m) => m.copyWith(refillCount: v)),
              ),
            ),
            VListRow(
              title: 'Remind to refill',
              subtitle: 'When ${m.refillRemindAt} are left',
              trailing: VSwitch(
                value: m.remindRefill,
                onChanged: (v) => _set((m) => m.copyWith(remindRefill: v)),
              ),
            ),
          ],
        ),
        if (!_isNew)
          VButton.ghost(
            'Delete medicine',
            onPressed: () async {
              await ref.read(medicineRepositoryProvider).delete(m.id);
              if (context.mounted) context.pop();
            },
          ),
      ],
    );
  }
}

/// Dose history: the week's taken, due, skipped and missed doses by day.
class DosesPage extends ConsumerWidget {
  const DosesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doses = ref.watch(dosesProvider).value ?? const <DoseLog>[];
    final meds = ref.watch(medicinesProvider).value ?? const <Medicine>[];
    final now = ref.watch(currentMinuteProvider);
    final names = {for (final m in meds) m.id: m.name};
    final shown = doses.where((d) => names.containsKey(d.medicineId)).toList();

    final settled = shown.where((d) => d.status != DoseStatus.due);
    final taken = settled.where((d) => d.status == DoseStatus.taken).length;

    final groups = <DateTime, List<DoseLog>>{};
    for (final d in shown) {
      final day = DateTime(
        d.scheduledAt.year,
        d.scheduledAt.month,
        d.scheduledAt.day,
      );
      groups.putIfAbsent(day, () => []).add(d);
    }

    return VDetailPage(
      backLabel: 'Care',
      title: 'Doses',
      children: [
        VCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  '$taken/${settled.length}',
                  style: VText.doto(44, weight: 900, height: 1),
                ),
              ),
              Text('taken this week', style: VText.inter(13, weight: 300)),
            ],
          ),
        ),
        for (final entry in groups.entries)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
                child: Text(
                  VFormat.dayHeading(entry.key, now),
                  style: VText.eyebrow,
                ),
              ),
              VListSection(
                children: [
                  for (final d in entry.value.reversed)
                    VListRow(
                      leading: SizedBox(
                        width: 48,
                        child: Text(
                          VFormat.time(d.scheduledAt),
                          style: VText.doto(15),
                        ),
                      ),
                      title: names[d.medicineId]!,
                      trailing: switch (d.status) {
                        DoseStatus.taken => const VPill.badge('Taken'),
                        DoseStatus.due => VPill(
                          'Due',
                          style: VText.inter(12, weight: 500),
                        ),
                        DoseStatus.skipped => VPill(
                          'Skipped',
                          fill: VFill.dashed,
                          style: VText.inter(12, weight: 500),
                        ),
                        DoseStatus.missed => VPill(
                          'Missed',
                          fill: VFill.dashed,
                          style: VText.inter(12, weight: 500),
                        ),
                      },
                    ),
                ],
              ),
            ],
          ),
        VButton.ghost(
          'Turn medicine off',
          onPressed: () async {
            await ref.read(medicineRepositoryProvider).setEnabled(false);
            if (context.mounted) context.pop();
          },
        ),
      ],
    );
  }
}

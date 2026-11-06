import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/format.dart';
import '../../core/icons/v_icons.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_controls.dart';
import '../../core/widgets/v_glass.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_page.dart';
import '../../core/widgets/v_progress.dart';
import '../../core/widgets/v_surface.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../selectors.dart';
import 'water_goal_form.dart';

/// Tab 4: water, medicine and the daily mantra.
class CarePage extends StatelessWidget {
  const CarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const VTabPage(
      title: 'Care',
      children: [_WaterCard(), _MedicineCard(), _MantraCard()],
    );
  }
}

/// The next reminder in the window after [now], or null when the day's
/// reminders are over.
DateTime? nextWaterReminder(WaterSettings s, DateTime now) {
  final start = s.wake.on(now);
  final step = s.interval;
  if (step.inMinutes <= 0) return null;
  final end = start.add(Duration(minutes: s.wake.minutesUntil(s.sleep)));
  for (var t = start.add(step); !t.isAfter(end); t = t.add(step)) {
    if (t.isAfter(now)) return t;
  }
  return null;
}

class _WaterCard extends ConsumerWidget {
  const _WaterCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(waterTodayProvider).value ?? const <WaterLog>[];
    final s = ref.watch(waterSettingsProvider).value ?? const WaterSettings();
    final now = ref.watch(currentTimeProvider);
    final repo = ref.read(waterRepositoryProvider);
    final ml = logs.fold<int>(0, (sum, l) => sum + l.ml);
    final next = nextWaterReminder(s, now);

    return VCard(
      radius: 24,
      padding: const EdgeInsets.all(20),
      onTap: () => _showLog(context, logs),
      child: Column(
        children: [
          VRing(
            value: logs.length / s.goalGlasses,
            size: 170,
            strokeWidth: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${logs.length}/${s.goalGlasses}',
                  style: VText.doto(48, weight: 900, height: 1),
                ),
                const SizedBox(height: 2),
                Text('glasses · $ml ml', style: VText.inter(12)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: VPill(
                  '+1 glass',
                  fill: VFill.filled,
                  style: VText.inter(14, weight: 600),
                  padding: const EdgeInsets.all(12),
                  onTap: repo.logGlass,
                ),
              ),
              const SizedBox(width: 8),
              VPill(
                'Undo',
                style: VText.inter(14, weight: 500),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                onTap: logs.isEmpty ? null : repo.undoLast,
              ),
            ],
          ),
          const SizedBox(height: 16),
          VTappable(
            onTap: () => showVSheet<void>(
              context,
              title: 'Water goal',
              builder: (_) => const WaterGoalForm(),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Every ${VFormat.hm(s.interval)} · ${s.wake.label}–${s.sleep.label}',
                    style: VText.inter(12, weight: 300),
                  ),
                ),
                Text(
                  next == null
                      ? 'Done for today'
                      : 'Next ${VFormat.time(next)}',
                  style: VText.inter(12, weight: 300),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLog(BuildContext context, List<WaterLog> logs) {
    showVSheet<void>(
      context,
      title: "Today's water",
      builder: (_) => logs.isEmpty
          ? const VFootnote('Nothing logged yet.')
          : VListSection(
              children: [
                for (final l in logs.reversed)
                  VListRow(title: VFormat.time(l.at), value: '${l.ml} ml'),
              ],
            ),
    );
  }
}

class _MedicineCard extends ConsumerWidget {
  const _MedicineCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(medicineEnabledProvider).value ?? false;
    final repo = ref.read(medicineRepositoryProvider);

    if (!enabled) {
      return VCard(
        outline: VOutline.dashed,
        radius: 24,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Medicine', style: VText.rowTitle),
                  const SizedBox(height: 2),
                  Text('Reminders, doses and refills', style: VText.secondary),
                ],
              ),
            ),
            VSwitch(value: false, onChanged: repo.setEnabled),
          ],
        ),
      );
    }

    final meds = ref.watch(medicinesProvider).value ?? const <Medicine>[];
    final doses = ref.watch(dosesProvider).value ?? const <DoseLog>[];
    final now = ref.watch(currentTimeProvider);
    final byId = {for (final m in meds) m.id: m};
    final today =
        doses
            .where(
              (d) =>
                  _sameDay(d.scheduledAt, now) &&
                  byId.containsKey(d.medicineId),
            )
            .toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    final missed = doses.where((d) => d.status == DoseStatus.missed).length;

    return VCard(
      radius: 24,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: VEyebrow(
              'Medicine',
              trailing: VTappable(
                onTap: () => context.push(Routes.doses),
                child: Text(
                  missed == 0 ? 'History ›' : '$missed missed this week ›',
                  style: VText.inter(11),
                ),
              ),
            ),
          ),
          for (final dose in today) ...[
            _DoseRow(dose: dose, medicine: byId[dose.medicineId]!),
            const VDivider(),
          ],
          VTappable(
            onTap: () => context.push(Routes.medicine(Routes.newId)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  const VIconView(VIcon.plus, size: 16, strokeWidth: 1.6),
                  const SizedBox(width: 8),
                  Text('Add medicine', style: VText.inter(14, weight: 500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DoseRow extends ConsumerWidget {
  const _DoseRow({required this.dose, required this.medicine});

  final DoseLog dose;
  final Medicine medicine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(medicineRepositoryProvider);
    final control = switch (dose.status) {
      DoseStatus.taken => const VPill.badge('Taken'),
      DoseStatus.skipped => VPill(
        'Skipped',
        fill: VFill.dashed,
        style: VText.inter(12),
      ),
      DoseStatus.missed => VPill(
        'Missed',
        fill: VFill.dashed,
        style: VText.inter(12),
      ),
      DoseStatus.due => _TakenSkip(
        onTaken: () => repo.setDoseStatus(dose, DoseStatus.taken),
        onSkip: () => repo.setDoseStatus(dose, DoseStatus.skipped),
      ),
    };

    return VTappable(
      onTap: () => context.push(Routes.medicine(medicine.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 52,
              child: Text(
                VFormat.time(dose.scheduledAt),
                style: VText.doto(16),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(medicine.name, style: VText.inter(14, weight: 500)),
                  Text(
                    '${medicine.dose.split(' · ').first} · ${medicine.refillCount} left',
                    style: VText.inter(12, weight: 300),
                  ),
                ],
              ),
            ),
            control,
          ],
        ),
      ),
    );
  }
}

/// "Taken | Skip" split pill for a dose that is due.
class _TakenSkip extends StatelessWidget {
  const _TakenSkip({required this.onTaken, required this.onSkip});

  final VoidCallback onTaken;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    Widget part(String label, VoidCallback onTap) => VTappable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(label, style: VText.inter(12, weight: 500)),
      ),
    );
    return VOutlined(
      radius: 999,
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            part('Taken', onTaken),
            const VDivider(vertical: true),
            part('Skip', onSkip),
          ],
        ),
      ),
    );
  }
}

class _MantraCard extends ConsumerWidget {
  const _MantraCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mantra = ref.watch(todayMantraProvider);
    final settings = ref.watch(mantraSettingsProvider).value;
    if (settings == null) return const SizedBox.shrink();

    return VCard(
      radius: 24,
      padding: const EdgeInsets.all(18),
      onTap: () => context.push(Routes.mantras),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VEyebrow(
            'Mantra · ${settings.time.label}',
            trailing: VEyebrowNote(settings.rotate ? 'Rotate daily' : 'Fixed'),
          ),
          const SizedBox(height: 12),
          Text(
            mantra?.text ?? 'Add a mantra in the library.',
            style: VText.inter(22, height: 1.25),
          ),
          const SizedBox(height: 12),
          VPill(
            'Start now',
            style: VText.inter(13, weight: 600),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onTap: mantra == null
                ? null
                : () => context.push(Routes.mantraSession),
          ),
        ],
      ),
    );
  }
}

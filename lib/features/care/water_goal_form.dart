import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_controls.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_pickers.dart';
import '../../core/widgets/v_surface.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';

/// Water goal, glass size and reminder window. Saves as it changes.
/// Used in onboarding and from the Care water card.
class WaterGoalForm extends ConsumerWidget {
  const WaterGoalForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(waterSettingsProvider).value;
    if (s == null) return const SizedBox.shrink();
    final repo = ref.read(waterRepositoryProvider);
    void save(WaterSettings next) => repo.saveSettings(next);

    final inGlasses = s.unit == WaterUnit.glasses;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VSegmented<WaterUnit>(
          segments: const {WaterUnit.glasses: 'Glasses', WaterUnit.ml: 'ml'},
          value: s.unit,
          onChanged: (u) => save(s.copyWith(unit: u)),
        ),
        const SizedBox(height: 12),
        VCard(
          child: Column(
            children: [
              VStepper(
                large: true,
                value: inGlasses ? s.goalGlasses : s.goalMl ~/ 100,
                min: 1,
                max: inGlasses ? 20 : 50,
                onChanged: (v) => save(
                  s.copyWith(
                    goalGlasses: inGlasses ? v : (v * 100 / s.glassMl).round(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                inGlasses
                    ? 'glasses a day · ${s.goalMl} ml'
                    : '× 100 ml a day · ${s.goalGlasses} glasses',
                style: VText.inter(13, weight: 300),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        VListSection(
          children: [
            VListRow(
              title: 'Glass size',
              trailing: VSegmented<int>(
                compact: true,
                segments: const {200: '200', 250: '250', 300: '300 ml'},
                value: s.glassMl,
                onChanged: (v) => save(s.copyWith(glassMl: v)),
              ),
            ),
            VListRow(
              title: 'Wake',
              value: s.wake.label,
              onTap: () async {
                final t = await showTimePickerSheet(
                  context,
                  title: 'Wake',
                  initial: s.wake,
                );
                if (t != null) save(s.copyWith(wake: t));
              },
            ),
            VListRow(
              title: 'Sleep',
              value: s.sleep.label,
              onTap: () async {
                final t = await showTimePickerSheet(
                  context,
                  title: 'Sleep',
                  initial: s.sleep,
                );
                if (t != null) save(s.copyWith(sleep: t));
              },
            ),
            VListRow(
              title: 'Remind every',
              subtitle: 'Works out from your goal',
              value: VFormat.hm(s.interval),
            ),
          ],
        ),
      ],
    );
  }
}

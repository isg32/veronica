import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/icons/v_icons.dart';
import '../../core/ids.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_controls.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_page.dart';
import '../../core/widgets/v_pickers.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../selectors.dart';

/// Today's quote: your lines plus a starter list, rotating daily or fixed.
class MantraLibraryPage extends ConsumerWidget {
  const MantraLibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mantras = ref.watch(mantrasProvider).value ?? const <Mantra>[];
    final settings = ref.watch(mantraSettingsProvider).value;
    final today = ref.watch(todayMantraProvider);
    final repo = ref.read(mantraRepositoryProvider);
    if (settings == null) return const SizedBox.shrink();

    String subtitle(Mantra m) {
      final who = m.isStarter ? 'Starter' : 'Yours';
      if (m.id == today?.id) return '$who · today';
      if (m.lastShownAt != null) {
        return '$who · shown ${VFormat.dayMonth(m.lastShownAt!)}';
      }
      return who;
    }

    return VDetailPage(
      backLabel: 'Care',
      title: 'Quotes',
      children: [
        VSegmented<bool>(
          segments: const {true: 'Rotate daily', false: 'Fixed'},
          value: settings.rotate,
          onChanged: (rotate) => repo.saveSettings(
            settings.copyWith(
              rotate: rotate,
              fixedMantraId: settings.fixedMantraId ?? today?.id,
            ),
          ),
        ),
        VListSection(
          children: [
            for (final m in mantras)
              VListRow(
                title: m.text,
                subtitle: subtitle(m),
                trailing: m.id == today?.id ? const VPill.badge('Today') : null,
                onTap: () => repo.saveSettings(
                  settings.copyWith(rotate: false, fixedMantraId: m.id),
                ),
              ),
            VListRow(
              leading: const VIconView(VIcon.plus, size: 16, strokeWidth: 1.6),
              title: 'Add your own',
              onTap: () async {
                final text = await showTextSheet(
                  context,
                  title: 'New quote',
                  placeholder: 'A line to come back to',
                  action: 'Add',
                );
                if (text != null) {
                  await repo.save(Mantra(id: newId('mantra'), text: text));
                }
              },
            ),
          ],
        ),
        const VFootnote(
          "Tap a quote to keep it fixed. Today's quote shows on Today, in "
          'Care and on the home widget.',
        ),
        if (today != null && !today.isStarter)
          VButton.ghost(
            'Delete today\'s quote',
            onPressed: () => repo.delete(today.id),
          ),
      ],
    );
  }
}

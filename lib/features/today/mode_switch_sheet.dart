import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_glass.dart';
import '../../core/widgets/v_list.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';

/// Glass sheet listing every mode; picking one starts it (replacing the one
/// running). Built instead of CupertinoActionSheet, which brings its own
/// greys and blue.
Future<void> showModeSwitchSheet(BuildContext context, WidgetRef ref) {
  return showVSheet<void>(
    context,
    title: 'Switch mode',
    builder: (context) => const _ModeSwitch(),
  );
}

class _ModeSwitch extends ConsumerWidget {
  const _ModeSwitch();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modes = ref.watch(modesProvider).value ?? const <Mode>[];
    final active = ref.watch(activeModeProvider).value;
    final repo = ref.read(modeRepositoryProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VListSection(
          children: [
            for (final m in modes)
              VListRow(
                title: m.name,
                subtitle: m.purpose,
                trailing: m.id == active?.modeId
                    ? const VPill.badge('On')
                    : null,
                onTap: () async {
                  Navigator.of(context).pop();
                  await repo.start(
                    m.id,
                    minutes: m.timer == ModeTimer.fixed ? m.timerMin : null,
                  );
                },
              ),
          ],
        ),
        if (active != null) ...[
          const SizedBox(height: 12),
          VButton.ghost(
            'End mode',
            onPressed: () async {
              Navigator.of(context).pop();
              await repo.end();
            },
          ),
        ],
      ],
    );
  }
}

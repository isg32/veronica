import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_breathe.dart';
import '../../core/widgets/v_buttons.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import 'prompt_widgets.dart';

/// "Put it down": shown over a watched app at its limit. A 5-second breath
/// before "Close app"; "5 more minutes" while any are left today; with hard
/// block and none left, a long-press on the headline is the emergency exit.
class PutItDownPage extends ConsumerWidget {
  const PutItDownPage({super.key, required this.packageName});

  final String packageName;

  void _leave(BuildContext context) =>
      context.canPop() ? context.pop() : context.go(Routes.today);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(watchedAppsProvider).value ?? const <WatchedApp>[];
    final app = apps.where((a) => a.packageName == packageName).firstOrNull;
    final name = ref.watch(profileProvider).value?.name ?? '';
    final repo = ref.read(usageRepositoryProvider);
    if (app == null) return const PromptScaffold(child: SizedBox.shrink());

    final emergency = app.hardBlock && app.extensionsLeft == 0;
    final over = app.minutesToday >= app.dailyLimitMin;

    return PromptScaffold(
      child: Countdown(
        seconds: 5,
        builder: (context, left) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PromptHeadline(
              title: name.isEmpty
                  ? 'PUT IT\nDOWN'
                  : 'PUT IT\nDOWN,\n${name.toUpperCase()}',
              body: over
                  ? '${app.minutesToday} min on ${app.name} today. '
                        'That was your limit.'
                  : '${app.minutesToday} of ${app.dailyLimitMin} min on '
                        '${app.name} today.',
              onLongPress: emergency
                  ? () async {
                      await repo.logOverride(app.packageName);
                      if (context.mounted) _leave(context);
                    }
                  : null,
            ),
            Expanded(
              child: Center(child: VBreatheCircle(value: '$left')),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                children: [
                  VButton.primary(
                    'Close app',
                    enabled: left == 0,
                    onPressed: () async {
                      await repo.recordPutDown(app.packageName);
                      if (context.mounted) _leave(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  if (app.extensionsLeft > 0)
                    VButton.ghost(
                      '5 more minutes · ${app.extensionsLeft} left today',
                      onPressed: () async {
                        await repo.extend(app.packageName);
                        if (context.mounted) _leave(context);
                      },
                    )
                  else
                    Text(
                      emergency
                          ? 'No more minutes today. Long-press the title for an emergency 5.'
                          : 'No more minutes today.',
                      textAlign: TextAlign.center,
                      style: VText.secondary,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Time's up": Binge Time has ended.
class TimesUpPage extends ConsumerWidget {
  const TimesUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeModeProvider).value;
    final minutes = active?.endsAt == null
        ? null
        : active!.endsAt!.difference(active.startedAt).inMinutes;

    return PromptScaffold(
      child: Countdown(
        seconds: 5,
        builder: (context, left) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PromptHeadline(
              title: "TIME'S\nUP",
              body: minutes == null
                  ? 'Binge Time has ended.'
                  : 'Binge Time has ended. That was $minutes minutes, as planned.',
            ),
            Expanded(
              child: Center(child: VBreatheCircle(value: '$left')),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: VButton.primary(
                'End',
                onPressed: () async {
                  await ref.read(modeRepositoryProvider).end();
                  if (context.mounted) context.go(Routes.today);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

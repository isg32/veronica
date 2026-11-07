import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_breathe.dart';
import '../../core/widgets/v_buttons.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../../platform/watcher.dart';
import 'prompt_widgets.dart';

/// "Put it down": shown over a watched app at its limit. A 5-second breath
/// before "Close app"; "5 more minutes" while any are left today; with hard
/// block and none left, a long-press on the headline is the emergency exit.
///
/// Opened by the watcher ([fromWatcher]), "Close app" goes to the home
/// screen and the other ways out return to the app with a 5-minute grace;
/// opened from inside Veronica (the debug preview), they just close the page.
class PutItDownPage extends ConsumerStatefulWidget {
  const PutItDownPage({
    super.key,
    required this.packageName,
    this.fromWatcher = false,
    this.modeName,
  });

  final String packageName;
  final bool fromWatcher;

  /// Set when the app is blocked by a running mode rather than a limit.
  final String? modeName;

  @override
  ConsumerState<PutItDownPage> createState() => _PutItDownPageState();
}

class _PutItDownPageState extends ConsumerState<PutItDownPage> {
  String get packageName => widget.packageName;

  @override
  void initState() {
    super.initState();
    if (widget.fromWatcher) {
      unawaited(ref.read(usageRepositoryProvider).recordNudge(packageName));
    }
  }

  void _close() => context.canPop() ? context.pop() : context.go(Routes.today);

  /// Back to the watched app, quiet for five minutes.
  Future<void> _backToApp() async {
    if (!widget.fromWatcher) return _close();
    await Watcher.grantGrace(packageName);
    _close();
    await Watcher.returnToApp();
  }

  /// To the home screen: the phone is put down.
  Future<void> _home() async {
    if (widget.fromWatcher) await Watcher.goHome();
    if (mounted) _close();
  }

  /// The app is blocked by [modeName]: no minutes, no extra time; Close app,
  /// or a long-press on the title for an emergency five minutes.
  Widget _blockedByMode(BuildContext context, String name, String modeName) {
    final installed =
        ref.watch(installedAppsProvider).value ?? const <InstalledApp>[];
    final appName =
        installed
            .where((a) => a.packageName == packageName)
            .firstOrNull
            ?.name ??
        'This app';
    final repo = ref.read(usageRepositoryProvider);
    return PromptScaffold(
      speak: (
        text: 'Put it down${name.isEmpty ? '' : ', $name'}.',
        moment: VoiceMoment.putItDown,
      ),
      child: Countdown(
        seconds: 5,
        builder: (context, left) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PromptHeadline(
              title: name.isEmpty
                  ? 'PUT IT\nDOWN'
                  : 'PUT IT\nDOWN,\n${name.toUpperCase()}',
              body: '$modeName is on. $appName is paused until it ends.',
              onLongPress: () async {
                await repo.logOverride(packageName);
                await _backToApp();
              },
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
                      await repo.recordPutDown(packageName);
                      await _home();
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Long-press the title for an emergency 5 minutes.',
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

  @override
  Widget build(BuildContext context) {
    final apps = ref.watch(watchedAppsProvider).value ?? const <WatchedApp>[];
    final app = apps.where((a) => a.packageName == packageName).firstOrNull;
    final name = ref.watch(profileProvider).value?.name ?? '';
    final repo = ref.read(usageRepositoryProvider);
    final modeName = widget.modeName;
    if (modeName != null) return _blockedByMode(context, name, modeName);
    if (app == null) return const PromptScaffold(child: SizedBox.shrink());

    final emergency = app.hardBlock && app.extensionsLeft == 0;
    final over = app.minutesToday >= app.dailyLimitMin;

    return PromptScaffold(
      speak: widget.fromWatcher
          ? (
              text: 'Put it down${name.isEmpty ? '' : ', $name'}.',
              moment: VoiceMoment.putItDown,
            )
          : null,
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
                      await _backToApp();
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
                      await _home();
                    },
                  ),
                  const SizedBox(height: 10),
                  if (app.extensionsLeft > 0)
                    VButton.ghost(
                      '5 more minutes · ${app.extensionsLeft} left today',
                      onPressed: () async {
                        await repo.extend(app.packageName);
                        await _backToApp();
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
      speak: (
        text: "Time's up. That was your Binge Time.",
        moment: VoiceMoment.timesUp,
      ),
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

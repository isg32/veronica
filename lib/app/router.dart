import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/theme/v_tokens.dart';
import '../data/providers.dart';
import 'placeholder_page.dart';
import 'routes.dart';
import 'shell.dart';

part 'router.g.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // Re-run redirects when onboarding state changes.
  final onboarded = ValueNotifier<bool?>(null);
  ref.listen(
    profileProvider,
    (_, next) => onboarded.value = next.value?.onboarded,
    fireImmediately: true,
  );
  ref.onDispose(onboarded.dispose);

  final router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.today,
    refreshListenable: onboarded,
    redirect: (context, state) {
      final done = onboarded.value;
      if (done == null) return null;
      final inOnboarding = state.matchedLocation == Routes.onboarding;
      if (!done && !inOnboarding) return Routes.onboarding;
      if (done && inOnboarding) return Routes.today;
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          for (final (path, title) in const [
            (Routes.today, 'Today'),
            (Routes.focus, 'Focus'),
            (Routes.tasks, 'Tasks'),
            (Routes.care, 'Care'),
            (Routes.sleep, 'Sleep'),
          ])
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: path,
                  pageBuilder: (context, state) =>
                      NoTransitionPage(child: PlaceholderPage(title)),
                ),
              ],
            ),
        ],
      ),
      GoRoute(
        path: Routes.onboarding,
        pageBuilder: (context, state) =>
            fadePage(state, const PlaceholderPage('Welcome')),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}

/// Full-screen prompts and onboarding fade in; nothing slides or bounces.
Page<void> fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: VMotion.standard,
    reverseTransitionDuration: VMotion.standard,
    transitionsBuilder: (context, animation, _, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: VMotion.curve),
      child: child,
    ),
  );
}

/// Detail pages slide in like any Cupertino page.
Page<void> slidePage(GoRouterState state, Widget child) =>
    CupertinoPage<void>(key: state.pageKey, child: child);

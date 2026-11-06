import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/theme/v_tokens.dart';
import '../data/providers.dart';
import '../features/care/care_page.dart';
import '../features/care/mantra_library_page.dart';
import '../features/care/medicine_pages.dart';
import '../features/focus/active_mode_page.dart';
import '../features/focus/app_pages.dart';
import '../features/focus/focus_page.dart';
import '../features/focus/mode_editor_page.dart';
import '../features/prompts/care_prompts.dart';
import '../features/prompts/limit_prompts.dart';
import '../features/settings/settings_pages.dart';
import '../features/sleep/alarm_pages.dart';
import '../features/sleep/sleep_page.dart';
import '../features/tasks/task_detail_page.dart';
import '../features/tasks/tasks_page.dart';
import '../features/today/today_page.dart';
import '../features/today/weekly_page.dart';
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.today,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: TodayPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.focus,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: FocusPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.tasks,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: TasksPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.care,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: CarePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.sleep,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SleepPage()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.settings,
        pageBuilder: (context, state) => slidePage(state, const SettingsPage()),
      ),
      for (final (path, page) in const [
        (Routes.settingsPermissions, PermissionsSettingsPage()),
        (Routes.settingsGlyph, GlyphSettingsPage()),
        (Routes.settingsVoice, VoiceSettingsPage()),
        (Routes.settingsWidgets, WidgetsSettingsPage()),
        (Routes.settingsData, DataSettingsPage()),
      ])
        GoRoute(
          path: path,
          pageBuilder: (context, state) => slidePage(state, page),
        ),
      GoRoute(
        path: Routes.weekly,
        pageBuilder: (context, state) => slidePage(state, const WeeklyPage()),
      ),
      GoRoute(
        path: '/app/:package',
        pageBuilder: (context, state) => slidePage(
          state,
          AppDetailPage(packageName: state.pathParameters['package']!),
        ),
      ),
      GoRoute(
        path: Routes.addApp,
        pageBuilder: (context, state) =>
            slidePage(state, const AppPickerPage()),
      ),
      GoRoute(
        path: '/mode/:id',
        pageBuilder: (context, state) =>
            slidePage(state, ModeEditorPage(id: state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/task/:id',
        pageBuilder: (context, state) =>
            slidePage(state, TaskDetailPage(id: state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/medicine/:id',
        pageBuilder: (context, state) => slidePage(
          state,
          MedicineEditorPage(id: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: Routes.doses,
        pageBuilder: (context, state) => slidePage(state, const DosesPage()),
      ),
      GoRoute(
        path: Routes.mantras,
        pageBuilder: (context, state) =>
            slidePage(state, const MantraLibraryPage()),
      ),
      GoRoute(
        path: '/alarm/:id',
        pageBuilder: (context, state) =>
            slidePage(state, AlarmEditorPage(id: state.pathParameters['id']!)),
      ),
      GoRoute(
        path: Routes.sounds,
        pageBuilder: (context, state) =>
            slidePage(state, const SoundLibraryPage()),
      ),
      GoRoute(
        path: Routes.activeMode,
        pageBuilder: (context, state) =>
            fadePage(state, const ActiveModePage()),
      ),
      GoRoute(
        path: '/now/put-it-down/:package',
        pageBuilder: (context, state) => fadePage(
          state,
          PutItDownPage(packageName: state.pathParameters['package']!),
        ),
      ),
      GoRoute(
        path: Routes.timesUp,
        pageBuilder: (context, state) => fadePage(state, const TimesUpPage()),
      ),
      GoRoute(
        path: '/now/medicine/:id',
        pageBuilder: (context, state) => fadePage(
          state,
          MedicineDuePage(medicineId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/now/alarm/:id',
        pageBuilder: (context, state) => fadePage(
          state,
          AlarmRingingPage(alarmId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: Routes.mantraSession,
        pageBuilder: (context, state) =>
            fadePage(state, const MantraSessionPage()),
      ),
      GoRoute(
        path: Routes.mantraTime,
        pageBuilder: (context, state) =>
            fadePage(state, const MantraTimePage()),
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

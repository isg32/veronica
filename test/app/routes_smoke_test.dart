import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veronica/app/app.dart';
import 'package:veronica/app/router.dart';
import 'package:veronica/app/routes.dart';
import 'package:veronica/data/models/models.dart';
import 'package:veronica/data/providers.dart';

import '../helpers/fonts.dart';

/// Opens every screen on a phone-sized view and fails on any exception or
/// layout overflow.
void main() {
  setUpAll(loadAppFonts);

  final routes = <String>[
    Routes.today,
    Routes.focus,
    Routes.tasks,
    Routes.care,
    Routes.sleep,
    Routes.settings,
    Routes.settingsPermissions,
    Routes.settingsGlyph,
    Routes.settingsVoice,
    Routes.settingsWidgets,
    Routes.settingsData,
    Routes.weekly,
    Routes.app('com.instagram.android'),
    Routes.addApp,
    Routes.mode('work'),
    Routes.mode('reading'),
    Routes.mode(Routes.newModeId),
    Routes.task('t1'),
    Routes.medicine('m2'),
    Routes.medicine(Routes.newId),
    Routes.doses,
    Routes.mantras,
    Routes.alarm('a1'),
    Routes.alarm(Routes.newId),
    Routes.sounds,
    Routes.activeMode,
    Routes.putItDown('com.instagram.android'),
    Routes.timesUp,
    Routes.medicineDue('m2'),
    Routes.alarmRinging('a1'),
    Routes.mantraSession,
    Routes.mantraTime,
  ];

  Future<ProviderContainer> boot(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const VeronicaApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    return container;
  }

  for (final light in [false, true]) {
    for (final route in routes) {
      testWidgets('opens $route in ${light ? 'light' : 'dark'} mode', (
        tester,
      ) async {
        // Set both ways: the test binding defaults to light.
        tester.platformDispatcher.platformBrightnessTestValue = light
            ? Brightness.light
            : Brightness.dark;
        addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
        final container = await boot(tester);
        container.read(routerProvider).go(route);
        for (var i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('reset sends you through onboarding to Today', (tester) async {
    final container = await boot(tester);
    await container
        .read(profileRepositoryProvider)
        .save(const Profile(name: '', onboarded: false));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('VERO\nNICA'), findsOneWidget);

    Future<void> settle() async {
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    await tester.enterText(find.byType(EditableText), 'Sapan');
    for (final label in [
      'Begin',
      'Continue',
      'Skip for now',
      'Continue',
      'Continue',
      'Done',
    ]) {
      await tester.tap(find.text(label).last);
      await settle();
    }
    expect(find.text('Good evening, Sapan'), findsOneWidget);
  });
}

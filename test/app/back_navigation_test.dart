import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veronica/app/app.dart';
import 'package:veronica/app/router.dart';
import 'package:veronica/app/routes.dart';

import '../helpers/fonts.dart';

void main() {
  setUpAll(loadAppFonts);

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('back goes to Today, then asks before exiting', (tester) async {
    final exits = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'SystemNavigator.pop') exits.add(call);
        return null;
      },
    );

    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const VeronicaApp(),
      ),
    );
    await settle(tester);
    final router = container.read(routerProvider);

    router.go(Routes.tasks);
    await settle(tester);

    // Back on a tab goes to Today.
    await tester.binding.handlePopRoute();
    await settle(tester);
    expect(router.state.matchedLocation, Routes.today);
    expect(exits, isEmpty);

    // First back on Today shows the hint, second exits.
    await tester.binding.handlePopRoute();
    await settle(tester);
    expect(find.text('Swipe back again to exit'), findsOneWidget);
    expect(exits, isEmpty);

    await tester.binding.handlePopRoute();
    await settle(tester);
    expect(exits, hasLength(1));
  });

  testWidgets('back on a detail page just closes it', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const VeronicaApp(),
      ),
    );
    await settle(tester);
    final router = container.read(routerProvider);

    router.go(Routes.focus);
    await settle(tester);
    unawaited(router.push<void>(Routes.app('com.instagram.android')));
    await settle(tester);

    await tester.binding.handlePopRoute();
    await settle(tester);
    expect(router.state.matchedLocation, Routes.focus);
  });
}

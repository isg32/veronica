import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veronica/data/providers.dart';
import 'package:veronica/features/selectors.dart';

void main() {
  test('the minute clock only notifies when the minute changes', () async {
    final ticks = StreamController<DateTime>();
    final container = ProviderContainer(
      overrides: [nowProvider.overrideWith((ref) => ticks.stream)],
    );
    addTearDown(container.dispose);

    var notified = 0;
    container.listen(currentMinuteProvider, (_, _) => notified++);

    Future<void> tick(DateTime t) async {
      ticks.add(t);
      await Future<void>.delayed(Duration.zero);
      container.read(currentMinuteProvider);
    }

    await tick(DateTime(2026, 11, 7, 21, 4, 1));
    final first = notified;
    await tick(DateTime(2026, 11, 7, 21, 4, 2));
    await tick(DateTime(2026, 11, 7, 21, 4, 3));
    expect(notified, first, reason: 'same minute, no rebuilds');
    await tick(DateTime(2026, 11, 7, 21, 5, 0));
    expect(notified, first + 1);
  });
}

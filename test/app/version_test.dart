import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:veronica/app/version.dart';

void main() {
  test('version.dart matches pubspec.yaml', () {
    final line = File('pubspec.yaml')
        .readAsLinesSync()
        .firstWhere((l) => l.startsWith('version:'));
    final value = line.substring('version:'.length).trim();
    expect(value, '$kAppVersion+$kAppBuild');
  });
}

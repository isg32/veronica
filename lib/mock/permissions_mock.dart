import '../data/models/models.dart';
import '../data/repositories/repositories.dart';
import 'mock_cell.dart';

final Map<AppPermission, bool> mockPermissions = {
  for (final p in AppPermission.values)
    p: p != AppPermission.exactAlarms && p != AppPermission.battery,
};

/// Glyph debug is marked as needed so its UI can be reviewed; the real
/// repository detects whether the phone needs it.
AdbStatus mockAdb() => AdbStatus(
  greyscaleGranted: true,
  glyphDebugNeeded: true,
  glyphDebugExpiresAt: mockNow.add(const Duration(hours: 31)),
);

class MockPermissionRepository implements PermissionRepository {
  final MockCell<Map<AppPermission, bool>> _granted = MockCell(
    Map.of(mockPermissions),
  );
  final MockCell<AdbStatus> _adb = MockCell(mockAdb());

  @override
  Stream<Map<AppPermission, bool>> watchGranted() => _granted.watch();

  @override
  Future<void> request(AppPermission permission) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _granted.update((m) => {...m, permission: true});
  }

  @override
  Stream<AdbStatus> watchAdb() => _adb.watch();

  @override
  Future<void> recheckAdb() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _adb.value = mockAdb();
  }
}

import '../data/models/models.dart';
import '../data/repositories/repositories.dart';
import 'mock_cell.dart';

/// Starts onboarded so the app opens on Today. "Reset all data" in Settings
/// replays onboarding.
const Profile mockProfile = Profile(name: 'Sapan', onboarded: true);

class MockProfileRepository implements ProfileRepository {
  final MockCell<Profile> _profile = MockCell(mockProfile);

  @override
  Stream<Profile> watch() => _profile.watch();

  @override
  Future<void> save(Profile profile) async => _profile.value = profile;
}

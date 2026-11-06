import '../data/models/models.dart';

/// Placeholder names only; no audio ships with Veronica.
List<AlarmSound> mockSounds() => [
  AlarmSound(
    id: 's1',
    name: 'Rain on tin',
    length: const Duration(seconds: 42),
    importedAt: DateTime(2026, 11, 2),
  ),
  AlarmSound(
    id: 's2',
    name: 'Birdsong',
    length: const Duration(minutes: 1, seconds: 10),
    importedAt: DateTime(2026, 11, 2),
  ),
  AlarmSound(
    id: 's3',
    name: 'Low bell',
    length: const Duration(seconds: 18),
    importedAt: DateTime(2026, 10, 28),
  ),
];

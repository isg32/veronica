import '../data/models/models.dart';
import '../data/repositories/repositories.dart';
import 'mock_cell.dart';

List<Mantra> mockMantras() => [
  Mantra(
    id: 'r1',
    text: 'I am here. This is enough.',
    lastShownAt: daysAgo(0, hour: 7, minute: 15),
  ),
  Mantra(
    id: 'r2',
    text: 'One thing at a time.',
    lastShownAt: daysAgo(1, hour: 7, minute: 15),
  ),
  Mantra(
    id: 'r3',
    text: 'The phone can wait.',
    lastShownAt: daysAgo(2, hour: 7, minute: 15),
  ),
  const Mantra(id: 'st1', text: 'Breathe out longer than in.', isStarter: true),
  const Mantra(id: 'st2', text: 'Small steps count.', isStarter: true),
  const Mantra(id: 'st3', text: 'Rest is part of the work.', isStarter: true),
];

const MantraSettings mockMantraSettings = MantraSettings();

class MockMantraRepository implements MantraRepository {
  final MockCell<List<Mantra>> _mantras = MockCell(mockMantras());
  final MockCell<MantraSettings> _settings = MockCell(mockMantraSettings);

  @override
  Stream<List<Mantra>> watchMantras() => _mantras.watch();

  @override
  Future<void> save(Mantra mantra) async => _mantras.update((list) {
    final exists = list.any((m) => m.id == mantra.id);
    return exists
        ? [for (final m in list) m.id == mantra.id ? mantra : m]
        : [mantra, ...list];
  });

  @override
  Future<void> delete(String id) async =>
      _mantras.update((list) => list.where((m) => m.id != id).toList());

  @override
  Stream<MantraSettings> watchSettings() => _settings.watch();

  @override
  Future<void> saveSettings(MantraSettings settings) async =>
      _settings.value = settings;
}

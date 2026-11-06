import '../data/models/models.dart';
import '../data/repositories/repositories.dart';
import 'mock_cell.dart';

const List<Medicine> mockMedicines = [
  Medicine(
    id: 'm1',
    name: 'Vitamin D',
    dose: '1 tablet',
    times: [DayTime(9, 0)],
    refillCount: 24,
  ),
  Medicine(
    id: 'm2',
    name: 'Magnesium',
    dose: '200 mg · 1 tablet',
    times: [DayTime(22, 0)],
    refillCount: 6,
  ),
];

/// Seven days of doses, newest first. Thursday's 22:00 Magnesium was missed
/// and today's is still due.
List<DoseLog> mockDoses() {
  final logs = <DoseLog>[];
  for (var day = 0; day < 7; day++) {
    for (final m in mockMedicines) {
      final at = m.times.first.on(daysAgo(day));
      final status = switch ((day, m.id)) {
        (0, 'm2') => DoseStatus.due,
        (1, 'm2') => DoseStatus.missed,
        _ => DoseStatus.taken,
      };
      logs.add(DoseLog(medicineId: m.id, scheduledAt: at, status: status));
    }
  }
  logs.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
  return logs;
}

class MockMedicineRepository implements MedicineRepository {
  /// Off by default in the real app; on in the mock so its screens show.
  final MockCell<bool> _enabled = MockCell(true);
  final MockCell<List<Medicine>> _medicines = MockCell([...mockMedicines]);
  final MockCell<List<DoseLog>> _doses = MockCell(mockDoses());

  @override
  Stream<bool> watchEnabled() => _enabled.watch();

  @override
  Future<void> setEnabled(bool enabled) async => _enabled.value = enabled;

  @override
  Stream<List<Medicine>> watchMedicines() => _medicines.watch();

  @override
  Future<void> save(Medicine medicine) async => _medicines.update((list) {
    final exists = list.any((m) => m.id == medicine.id);
    return exists
        ? [for (final m in list) m.id == medicine.id ? medicine : m]
        : [...list, medicine];
  });

  @override
  Future<void> delete(String id) async {
    _medicines.update((list) => list.where((m) => m.id != id).toList());
    _doses.update((list) => list.where((d) => d.medicineId != id).toList());
  }

  @override
  Stream<List<DoseLog>> watchDoses() => _doses.watch();

  @override
  Future<void> setDoseStatus(DoseLog dose, DoseStatus status) async {
    _doses.update(
      (list) => [
        for (final d in list)
          d.medicineId == dose.medicineId && d.scheduledAt == dose.scheduledAt
              ? d.withStatus(status)
              : d,
      ],
    );
    if (status == DoseStatus.taken) {
      _medicines.update(
        (list) => [
          for (final m in list)
            m.id == dose.medicineId && m.refillCount > 0
                ? m.copyWith(refillCount: m.refillCount - 1)
                : m,
        ],
      );
    }
  }
}

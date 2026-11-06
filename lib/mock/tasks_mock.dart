import '../data/models/models.dart';
import '../data/repositories/repositories.dart';
import 'mock_cell.dart';

List<Task> mockTasks() => [
  Task(
    id: 't1',
    title: 'Renew passport',
    createdAt: daysAgo(10, minute: 14),
    dueAt: DateTime(2026, 11, 20),
    priority: TaskPriority.high,
    notes:
        'Photos from the shop on MG Road. Old passport is in the blue folder.',
  ),
  Task(id: 't2', title: 'Call the dentist', createdAt: daysAgo(8, hour: 18)),
  Task(id: 't3', title: 'Fix bike brakes', createdAt: daysAgo(5, hour: 11)),
  Task(id: 't4', title: 'Reply to Meera', createdAt: daysAgo(4, hour: 20)),
  Task(
    id: 't5',
    title: 'Buy olive oil',
    createdAt: daysAgo(1, hour: 13),
    priority: TaskPriority.low,
  ),
  Task(
    id: 't6',
    title: 'Read chapter 4',
    createdAt: daysAgo(0, hour: 8, minute: 30),
  ),
  Task(
    id: 't7',
    title: 'Pay electricity bill',
    createdAt: daysAgo(6),
    completedAt: daysAgo(2, hour: 19),
  ),
  Task(
    id: 't8',
    title: 'Book train tickets',
    createdAt: daysAgo(3),
    completedAt: daysAgo(1, hour: 10),
  ),
];

class MockTaskRepository implements TaskRepository {
  MockTaskRepository(this._now);

  final DateTime Function() _now;
  final MockCell<List<Task>> _tasks = MockCell(mockTasks());

  @override
  Stream<List<Task>> watchAll() => _tasks.watch();

  @override
  Future<Task> add({
    required String title,
    String notes = '',
    DateTime? dueAt,
  }) async {
    final task = Task(
      id: mockId('t'),
      title: title,
      notes: notes,
      dueAt: dueAt,
      createdAt: _now(),
    );
    _tasks.update((list) => [...list, task]);
    return task;
  }

  @override
  Future<void> update(Task task) async => _tasks.update(
    (list) => [for (final t in list) t.id == task.id ? task : t],
  );

  @override
  Future<void> setDone(String id, {required bool done}) async => _tasks.update(
    (list) => [
      for (final t in list)
        t.id == id
            ? (done
                  ? t.copyWith(completedAt: _now())
                  : t.copyWith(clearCompleted: true))
            : t,
    ],
  );

  @override
  Future<void> delete(String id) async =>
      _tasks.update((list) => list.where((t) => t.id != id).toList());
}

enum TaskPriority { low, mid, high }

/// A to-do that shows how long it has waited.
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.createdAt,
    this.notes = '',
    this.dueAt,
    this.completedAt,
    this.priority = TaskPriority.mid,
  });

  final String id;
  final String title;
  final String notes;
  final DateTime createdAt;
  final DateTime? dueAt;
  final DateTime? completedAt;
  final TaskPriority priority;

  bool get isDone => completedAt != null;

  /// Whole calendar days since the task was added.
  int ageDays(DateTime now) {
    final a = DateTime(createdAt.year, createdAt.month, createdAt.day);
    final b = DateTime(now.year, now.month, now.day);
    return b.difference(a).inDays;
  }

  Task copyWith({
    String? title,
    String? notes,
    DateTime? dueAt,
    bool clearDue = false,
    DateTime? completedAt,
    bool clearCompleted = false,
    TaskPriority? priority,
  }) => Task(
    id: id,
    title: title ?? this.title,
    notes: notes ?? this.notes,
    createdAt: createdAt,
    dueAt: clearDue ? null : (dueAt ?? this.dueAt),
    completedAt: clearCompleted ? null : (completedAt ?? this.completedAt),
    priority: priority ?? this.priority,
  );
}

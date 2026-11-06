import 'day_time.dart';

/// A medicine on a schedule.
class Medicine {
  const Medicine({
    required this.id,
    required this.name,
    required this.dose,
    required this.times,
    this.days = Weekdays.all,
    this.refillCount = 0,
    this.remindRefill = true,
    this.refillRemindAt = 5,
  });

  final String id;
  final String name;

  /// Free text, e.g. "200 mg · 1 tablet".
  final String dose;
  final List<DayTime> times;
  final Set<int> days;

  /// Tablets left.
  final int refillCount;
  final bool remindRefill;
  final int refillRemindAt;

  Medicine copyWith({
    String? name,
    String? dose,
    List<DayTime>? times,
    Set<int>? days,
    int? refillCount,
    bool? remindRefill,
  }) => Medicine(
    id: id,
    name: name ?? this.name,
    dose: dose ?? this.dose,
    times: times ?? this.times,
    days: days ?? this.days,
    refillCount: refillCount ?? this.refillCount,
    remindRefill: remindRefill ?? this.remindRefill,
    refillRemindAt: refillRemindAt,
  );
}

enum DoseStatus { due, taken, skipped, missed }

/// One scheduled dose and what happened to it.
class DoseLog {
  const DoseLog({
    required this.medicineId,
    required this.scheduledAt,
    required this.status,
  });

  final String medicineId;
  final DateTime scheduledAt;
  final DoseStatus status;

  DoseLog withStatus(DoseStatus status) =>
      DoseLog(medicineId: medicineId, scheduledAt: scheduledAt, status: status);
}

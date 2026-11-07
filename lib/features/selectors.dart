import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/format.dart';
import '../data/models/models.dart';
import '../data/providers.dart';

part 'selectors.g.dart';

/// The current second (falls back to the clock before the first tick).
@riverpod
DateTime currentTime(Ref ref) =>
    ref.watch(nowProvider).value ?? ref.watch(clockProvider).now();

/// The mantra shown today: the fixed one, or (rotating) one per calendar day.
@riverpod
Mantra? todayMantra(Ref ref) {
  final mantras = ref.watch(mantrasProvider).value ?? const <Mantra>[];
  final settings = ref.watch(mantraSettingsProvider).value;
  if (mantras.isEmpty) return null;
  if (settings != null && !settings.rotate && settings.fixedMantraId != null) {
    for (final m in mantras) {
      if (m.id == settings.fixedMantraId) return m;
    }
  }
  // Rotating: a different mantra each calendar day, the same all day.
  final now = ref.watch(currentTimeProvider);
  final day = DateTime.utc(
    now.year,
    now.month,
    now.day,
  ).difference(DateTime.utc(2024)).inDays;
  return mantras[day % mantras.length];
}

/// Open tasks, oldest first.
@riverpod
List<Task> openTasksOldestFirst(Ref ref) {
  final tasks = ref.watch(tasksProvider).value ?? const <Task>[];
  return tasks.where((t) => !t.isDone).toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
}

/// One row of the "Next up" card.
class NextUpItem {
  const NextUpItem(this.label, this.at);

  final String label;
  final DateTime at;
}

/// The next medicine dose (only when medicine is on), alarm and mantra.
@riverpod
List<NextUpItem> nextUp(Ref ref) {
  final now = ref.watch(currentTimeProvider);
  final items = <NextUpItem>[];

  final medicineOn = ref.watch(medicineEnabledProvider).value ?? false;
  if (medicineOn) {
    final meds = ref.watch(medicinesProvider).value ?? const <Medicine>[];
    NextUpItem? best;
    for (final m in meds) {
      final at = _nextOccurrence(now, m.times, m.days);
      if (at != null && (best == null || at.isBefore(best.at))) {
        best = NextUpItem('${m.name} · ${m.dose.split(' · ').first}', at);
      }
    }
    if (best != null) items.add(best);
  }

  final alarms = ref.watch(alarmsProvider).value ?? const <Alarm>[];
  NextUpItem? alarm;
  for (final a in alarms.where((a) => a.enabled)) {
    final at = _nextOccurrence(now, [a.time], a.days);
    if (at != null && (alarm == null || at.isBefore(alarm.at))) {
      alarm = NextUpItem('Alarm · ${VFormat.daysWord(a.days)}', at);
    }
  }
  if (alarm != null) items.add(alarm);

  final mantra = ref.watch(mantraSettingsProvider).value;
  if (mantra != null) {
    items.add(
      NextUpItem('Mantra', _nextOccurrence(now, [mantra.time], Weekdays.all)!),
    );
  }
  return items;
}

/// The next alarm that will ring, if any.
@riverpod
({Alarm alarm, DateTime at})? nextAlarm(Ref ref) {
  final now = ref.watch(currentTimeProvider);
  final alarms = ref.watch(alarmsProvider).value ?? const <Alarm>[];
  ({Alarm alarm, DateTime at})? best;
  for (final a in alarms.where((a) => a.enabled)) {
    final at = _nextOccurrence(now, [a.time], a.days);
    if (at != null && (best == null || at.isBefore(best.at))) {
      best = (alarm: a, at: at);
    }
  }
  return best;
}

DateTime? _nextOccurrence(DateTime now, List<DayTime> times, Set<int> days) {
  if (times.isEmpty || days.isEmpty) return null;
  for (var offset = 0; offset < 8; offset++) {
    final day = DateTime(now.year, now.month, now.day + offset);
    if (!days.contains(day.weekday)) continue;
    final sorted = [...times]..sort();
    for (final t in sorted) {
      final at = t.on(day);
      if (at.isAfter(now)) return at;
    }
  }
  return null;
}

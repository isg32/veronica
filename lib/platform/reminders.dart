import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show TableUpdate;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/ids.dart';
import '../data/db/database.dart';
import '../data/models/models.dart';
import '../data/providers.dart';
import '../features/selectors.dart';
import 'android_usage.dart';

part 'reminders.g.dart';

const _reminders = MethodChannel('veronica/reminders');
const _usage = MethodChannel('veronica/usage');

/// One planned reminder (see `Reminders.kt`).
class PlannedReminder {
  const PlannedReminder({
    required this.id,
    required this.at,
    required this.kind,
    required this.title,
    this.body = '',
    this.route,
  });

  final String id;
  final DateTime at;

  /// water, medicine, mantra, alarm or refill.
  final String kind;
  final String title;
  final String body;
  final String? route;

  Map<String, Object?> toJson() => {
    'id': id,
    'at': at.millisecondsSinceEpoch,
    'kind': kind,
    'title': title,
    'body': body,
    'route': ?route,
  };
}

/// Key of a snoozed alarm: `{"alarm": id, "at": epoch ms}`.
const snoozePrefKey = 'alarm.snooze';

/// A snoozed alarm, if any.
@riverpod
Stream<({String alarmId, DateTime at})?> alarmSnooze(Ref ref) =>
    ref.watch(databaseProvider).watchPref(snoozePrefKey).map((j) {
      if (j == null) return null;
      final m = jsonDecode(j) as Map<String, Object?>;
      return (
        alarmId: m['alarm']! as String,
        at: DateTime.fromMillisecondsSinceEpoch((m['at']! as num).toInt()),
      );
    });

/// Key of a snoozed medicine dose: `{"medicine": id, "at": epoch ms}`.
const medicineSnoozePrefKey = 'medicine.snooze';

/// A snoozed medicine dose, if any.
@riverpod
Stream<({String medicineId, DateTime at})?> medicineSnooze(Ref ref) =>
    ref.watch(databaseProvider).watchPref(medicineSnoozePrefKey).map((j) {
      if (j == null) return null;
      final m = jsonDecode(j) as Map<String, Object?>;
      return (
        medicineId: m['medicine']! as String,
        at: DateTime.fromMillisecondsSinceEpoch((m['at']! as num).toInt()),
      );
    });

/// Reminds about [medicineId] again in [minutes]; null clears the snooze.
Future<void> snoozeMedicine(
  VeronicaDatabase db,
  String? medicineId, {
  int minutes = 15,
}) => db.writePref(
  medicineSnoozePrefKey,
  medicineId == null
      ? null
      : jsonEncode({
          'medicine': medicineId,
          'at': DateTime.now()
              .add(Duration(minutes: minutes))
              .millisecondsSinceEpoch,
        }),
);

/// Snoozes [alarmId] for [minutes].
Future<void> snoozeAlarm(VeronicaDatabase db, String alarmId, int minutes) =>
    db.writePref(
      snoozePrefKey,
      jsonEncode({
        'alarm': alarmId,
        'at': DateTime.now()
            .add(Duration(minutes: minutes))
            .millisecondsSinceEpoch,
      }),
    );

/// Everything Veronica should remind about in the next 48 hours.
@riverpod
List<PlannedReminder> reminderPlan(Ref ref) {
  final now = ref
      .watch(currentMinuteProvider)
      .copyWith(second: 0, millisecond: 0);
  final horizon = now.add(const Duration(hours: 48));
  final plan = <PlannedReminder>[];
  bool inWindow(DateTime t) => t.isAfter(now) && t.isBefore(horizon);
  final days = [
    DateTime(now.year, now.month, now.day),
    DateTime(now.year, now.month, now.day + 1),
  ];

  // Water, unless the running mode turns it off or today's goal is met.
  final water = ref.watch(waterSettingsProvider).value;
  final drunk = ref.watch(waterTodayProvider).value?.length ?? 0;
  final active = ref.watch(activeModeProvider).value;
  final modes = ref.watch(modesProvider).value ?? const <Mode>[];
  final mode = modes.where((m) => m.id == active?.modeId).firstOrNull;
  if (water != null && (mode?.waterOn ?? true)) {
    for (final (i, day) in days.indexed) {
      if (i == 0 && drunk >= water.goalGlasses) continue;
      final start = water.wake.on(day);
      final end = start.add(
        Duration(minutes: water.wake.minutesUntil(water.sleep)),
      );
      for (
        var t = start.add(water.interval);
        !t.isAfter(end);
        t = t.add(water.interval)
      ) {
        if (!inWindow(t)) continue;
        plan.add(
          PlannedReminder(
            id: 'water-${t.millisecondsSinceEpoch}',
            at: t,
            kind: 'water',
            title: 'Time for water',
            body: i == 0
                ? '$drunk of ${water.goalGlasses} glasses today'
                : 'A glass now?',
            route: '/care',
          ),
        );
      }
    }
  }

  // Medicine doses not answered yet, and refill warnings.
  final medicineOn = ref.watch(medicineEnabledProvider).value ?? false;
  if (medicineOn) {
    final meds = ref.watch(medicinesProvider).value ?? const <Medicine>[];
    final doses = ref.watch(dosesProvider).value ?? const <DoseLog>[];
    for (final m in meds) {
      for (final day in days) {
        if (!m.days.contains(day.weekday)) continue;
        for (final time in m.times) {
          final at = time.on(day);
          if (!inWindow(at)) continue;
          final answered = doses.any(
            (d) =>
                d.medicineId == m.id &&
                d.scheduledAt == at &&
                d.status != DoseStatus.due,
          );
          if (answered) continue;
          plan.add(
            PlannedReminder(
              id: 'med-${m.id}-${at.millisecondsSinceEpoch}',
              at: at,
              kind: 'medicine',
              title: m.name,
              body: m.dose,
              route: '/now/medicine/${m.id}',
            ),
          );
        }
      }
      if (m.remindRefill && m.refillCount <= m.refillRemindAt) {
        final at = days
            .map((d) => const DayTime(10, 0).on(d))
            .firstWhere(
              inWindow,
              orElse: () => days[1].add(const Duration(hours: 10)),
            );
        plan.add(
          PlannedReminder(
            id: 'refill-${m.id}-${VeronicaDatabase.dayKey(at)}',
            at: at,
            kind: 'refill',
            title: 'Refill ${m.name}',
            body: '${m.refillCount} left',
            route: '/medicine/${m.id}',
          ),
        );
      }
    }

    // A snoozed dose.
    final snoozed = ref.watch(medicineSnoozeProvider).value;
    if (snoozed != null && inWindow(snoozed.at)) {
      final med = meds.where((m) => m.id == snoozed.medicineId).firstOrNull;
      if (med != null) {
        plan.add(
          PlannedReminder(
            id: 'med-snooze-${med.id}-${snoozed.at.millisecondsSinceEpoch}',
            at: snoozed.at,
            kind: 'medicine',
            title: med.name,
            body: med.dose,
            route: '/now/medicine/${med.id}',
          ),
        );
      }
    }
  }

  // The daily mantra.
  final mantra = ref.watch(mantraSettingsProvider).value;
  if (mantra != null) {
    final at = days
        .map(mantra.time.on)
        .firstWhere(inWindow, orElse: () => days[1]);
    if (inWindow(at)) {
      plan.add(
        PlannedReminder(
          id: 'mantra-${at.millisecondsSinceEpoch}',
          at: at,
          kind: 'mantra',
          title: 'Mantra time',
          body: ref.watch(todayMantraProvider)?.text ?? '',
          route: '/now/mantra-time',
        ),
      );
    }
  }

  // Calm alarms, and a snoozed one.
  for (final a in ref.watch(alarmsProvider).value ?? const <Alarm>[]) {
    if (!a.enabled) continue;
    for (final day in days) {
      if (!a.days.contains(day.weekday)) continue;
      final at = a.time.on(day);
      if (!inWindow(at)) continue;
      plan.add(
        PlannedReminder(
          id: 'alarm-${a.id}-${at.millisecondsSinceEpoch}',
          at: at,
          kind: 'alarm',
          title: 'Alarm ${a.time.label}',
          route: '/now/alarm/${a.id}',
        ),
      );
    }
  }
  final snooze = ref.watch(alarmSnoozeProvider).value;
  if (snooze != null && inWindow(snooze.at)) {
    plan.add(
      PlannedReminder(
        id: 'snooze-${snooze.alarmId}-${snooze.at.millisecondsSinceEpoch}',
        at: snooze.at,
        kind: 'alarm',
        title: 'Alarm (snoozed)',
        route: '/now/alarm/${snooze.alarmId}',
      ),
    );
  }

  return plan..sort((a, b) => a.at.compareTo(b.at));
}

/// Counts changes Android made while the app was running or away.
@Riverpod(keepAlive: true)
class ExternalChanges extends _$ExternalChanges {
  @override
  int build() => 0;

  void bump() => state++;
}

/// Sends the plan to Android whenever it changes, and refreshes the screens
/// when "+1 glass" was logged from a notification.
@Riverpod(keepAlive: true)
void reminderSync(Ref ref) {
  if (!isAndroid) return;
  String? last;
  Timer? debounce;

  void push() {
    final json = jsonEncode([
      for (final r in ref.read(reminderPlanProvider)) r.toJson(),
    ]);
    if (json == last) return;
    last = json;
    unawaited(_reminders.invokeMethod<void>('setPlan', json));
  }

  ref.listen(reminderPlanProvider, (_, _) {
    debounce?.cancel();
    debounce = Timer(const Duration(seconds: 1), push);
  }, fireImmediately: true);

  // Android wrote to the database (a notification or home widget action):
  // re-read what it may have touched, and adopt a mode it started or ended.
  void refresh() {
    final db = ref.read(databaseProvider);
    db.notifyUpdates({
      TableUpdate.onTable(db.waterLogs),
      TableUpdate.onTable(db.tasks),
    });
    ref.read(externalChangesProvider.notifier).bump();
  }

  _reminders.setMethodCallHandler((call) async {
    if (call.method == 'dataChanged') refresh();
  });
  final observer = _Resume(refresh);
  WidgetsBinding.instance.addObserver(observer);
  ref.onDispose(() {
    debounce?.cancel();
    WidgetsBinding.instance.removeObserver(observer);
  });
}

class _Resume with WidgetsBindingObserver {
  _Resume(this.onResume);

  final VoidCallback onResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) onResume();
  }
}

/// Nights estimated from screen-off time (see `UsageChannel.nights`).
Future<List<NightLog>> androidNights(SleepSchedule schedule) async {
  final raw = await _usage.invokeListMethod<Map<Object?, Object?>>('nights');
  return [
    for (final n in raw ?? const <Map<Object?, Object?>>[])
      NightLog(
        date: DateTime.fromMillisecondsSinceEpoch((n['date']! as num).toInt()),
        planned: schedule.sleepLength,
        actual: Duration(minutes: (n['minutes']! as num).toInt()),
      ),
  ];
}

/// Picks an audio file, copies it into the app and reads its length.
Future<({AlarmSound sound, String path})?> pickAlarmSound() async {
  final files = await FilePicker.pickFiles(type: FileType.audio);
  if (files.isEmpty) return null;
  final picked = files.single;
  final source = picked.path;
  if (source == null) return null;
  final dir = Directory(
    '${(await getApplicationSupportDirectory()).path}/sounds',
  );
  await dir.create(recursive: true);
  final id = newId('sound');
  final ext = source.contains('.')
      ? source.substring(source.lastIndexOf('.'))
      : '';
  final copy = await File(source).copy('${dir.path}/$id$ext');

  final player = AudioPlayer();
  Duration length;
  try {
    length = await player.setFilePath(copy.path) ?? Duration.zero;
  } finally {
    await player.dispose();
  }
  final name = picked.name;
  return (
    sound: AlarmSound(
      id: id,
      name: name.contains('.')
          ? name.substring(0, name.lastIndexOf('.'))
          : name,
      length: length,
      importedAt: DateTime.now(),
    ),
    path: copy.path,
  );
}

/// Wind-down as a schedule for the mode engine: from bedtime minus the
/// wind-down until wake, greyscale and Do Not Disturb. It overrides any mode.
Map<String, Object?> windDownSchedule(SleepSchedule s) => {
  'id': 'wind-down',
  'name': 'Wind-down',
  'config': {
    'greyscale': true,
    'dnd': DndPolicy.starred.name,
    'hideNotifications': false,
    'brightness': null,
    'ringer': null,
    'media': null,
    'blackWallpaper': false,
  },
  'policy': AppPolicy.usual.name,
  'blocked': const <String>[],
  'nudgeAfter': 5,
  'days': const [1, 2, 3, 4, 5, 6, 7],
  'start': s.windDownStart.label,
  'end': s.wake.label,
};

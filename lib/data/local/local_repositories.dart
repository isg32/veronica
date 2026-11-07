import 'dart:async';

import 'package:drift/drift.dart';

import '../../core/ids.dart';
import '../db/codecs.dart';
import '../db/database.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

/// Keys of the single-value settings in the `prefs` table.
abstract final class PrefKeys {
  static const profile = 'profile';
  static const water = 'water';
  static const sleep = 'sleep';
  static const mantra = 'mantra';
  static const listening = 'listening';
  static const voice = 'voice';
  static const glyph = 'glyph';
  static const medicineEnabled = 'medicine.enabled';
  static const activeMode = 'mode.active';
}

DateTime _startOfDay(DateTime t) => DateTime(t.year, t.month, t.day);

/// Combines several streams: emits [build] once all have a value, and again
/// whenever any of them changes.
Stream<T> _combine<T>(
  List<Stream<Object?>> sources,
  T Function(List<Object?> values) build,
) {
  late final StreamController<T> controller;
  final values = List<Object?>.filled(sources.length, null);
  final seen = List<bool>.filled(sources.length, false);
  final subs = <StreamSubscription<Object?>>[];
  controller = StreamController<T>(
    onListen: () {
      for (var i = 0; i < sources.length; i++) {
        subs.add(
          sources[i].listen((v) {
            values[i] = v;
            seen[i] = true;
            if (seen.every((s) => s)) controller.add(build(values));
          }, onError: controller.addError),
        );
      }
    },
    onCancel: () async {
      for (final s in subs) {
        await s.cancel();
      }
    },
  );
  return controller.stream;
}

// Profile.

class DriftProfileRepository implements ProfileRepository {
  DriftProfileRepository(this._db);

  final VeronicaDatabase _db;

  @override
  Stream<Profile> watch() => _db
      .watchPref(PrefKeys.profile)
      .map(
        (json) => json == null
            ? const Profile(name: '', onboarded: false)
            : Codecs.parseProfile(json),
      );

  @override
  Future<void> save(Profile profile) =>
      _db.writePref(PrefKeys.profile, Codecs.profile(profile));
}

// Tasks.

class DriftTaskRepository implements TaskRepository {
  DriftTaskRepository(this._db, this._now);

  final VeronicaDatabase _db;
  final DateTime Function() _now;

  static Task _task(TaskRow r) => Task(
    id: r.id,
    title: r.title,
    notes: r.notes,
    createdAt: DateTime.fromMillisecondsSinceEpoch(r.createdAt),
    dueAt: r.dueAt == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(r.dueAt!),
    completedAt: r.completedAt == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(r.completedAt!),
    priority: TaskPriority.values[r.priority.clamp(0, 2)],
  );

  static TasksCompanion _row(Task t) => TasksCompanion.insert(
    id: t.id,
    title: t.title,
    notes: Value(t.notes),
    createdAt: t.createdAt.millisecondsSinceEpoch,
    dueAt: Value(t.dueAt?.millisecondsSinceEpoch),
    completedAt: Value(t.completedAt?.millisecondsSinceEpoch),
    priority: Value(t.priority.index),
  );

  @override
  Stream<List<Task>> watchAll() =>
      _db.select(_db.tasks).watch().map((rows) => rows.map(_task).toList());

  @override
  Future<Task> add({
    required String title,
    String notes = '',
    DateTime? dueAt,
  }) async {
    final task = Task(
      id: newId('task'),
      title: title,
      notes: notes,
      dueAt: dueAt,
      createdAt: _now(),
    );
    await _db.into(_db.tasks).insert(_row(task));
    return task;
  }

  @override
  Future<void> update(Task task) =>
      _db.into(_db.tasks).insertOnConflictUpdate(_row(task));

  @override
  Future<void> setDone(String id, {required bool done}) =>
      (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
        TasksCompanion(
          completedAt: Value(done ? _now().millisecondsSinceEpoch : null),
        ),
      );

  @override
  Future<void> delete(String id) =>
      (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();
}

// Water.

class DriftWaterRepository implements WaterRepository {
  DriftWaterRepository(this._db, this._now);

  final VeronicaDatabase _db;
  final DateTime Function() _now;

  @override
  Stream<WaterSettings> watchSettings() => _db
      .watchPref(PrefKeys.water)
      .map((j) => j == null ? const WaterSettings() : Codecs.parseWater(j));

  @override
  Future<void> saveSettings(WaterSettings settings) =>
      _db.writePref(PrefKeys.water, Codecs.water(settings));

  Stream<List<WaterLogRow>> _since(DateTime from) =>
      (_db.select(_db.waterLogs)
            ..where(
              (t) => t.at.isBiggerOrEqualValue(from.millisecondsSinceEpoch),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.at)]))
          .watch();

  @override
  Stream<List<WaterLog>> watchToday() => _since(_startOfDay(_now())).map(
    (rows) => [
      for (final r in rows)
        WaterLog(
          id: r.id,
          at: DateTime.fromMillisecondsSinceEpoch(r.at),
          ml: r.ml,
        ),
    ],
  );

  @override
  Future<void> logGlass() async {
    final settings = await watchSettings().first;
    await _db
        .into(_db.waterLogs)
        .insert(
          WaterLogsCompanion.insert(
            id: newId('water'),
            at: _now().millisecondsSinceEpoch,
            ml: settings.glassMl,
          ),
        );
  }

  @override
  Future<void> undoLast() async {
    final today = await watchToday().first;
    if (today.isEmpty) return;
    await (_db.delete(
      _db.waterLogs,
    )..where((t) => t.id.equals(today.last.id))).go();
  }

  @override
  Stream<List<WaterDay>> watchWeek() {
    final first = _startOfDay(_now()).subtract(const Duration(days: 6));
    return _combine([_since(first), watchSettings()], (v) {
      final rows = v[0]! as List<WaterLogRow>;
      final goal = (v[1]! as WaterSettings).goalGlasses;
      return [
        for (var i = 0; i < 7; i++)
          () {
            final day = DateTime(first.year, first.month, first.day + i);
            final next = DateTime(day.year, day.month, day.day + 1);
            final count = rows.where((r) {
              final at = DateTime.fromMillisecondsSinceEpoch(r.at);
              return !at.isBefore(day) && at.isBefore(next);
            }).length;
            return WaterDay(date: day, glasses: count, goal: goal);
          }(),
      ];
    });
  }
}

// Medicine.

class DriftMedicineRepository implements MedicineRepository {
  DriftMedicineRepository(this._db, this._now);

  final VeronicaDatabase _db;
  final DateTime Function() _now;

  /// An unanswered dose becomes "missed" this long after its time.
  static const missedAfter = Duration(hours: 2);

  static Medicine _medicine(MedicineRow r) => Medicine(
    id: r.id,
    name: r.name,
    dose: r.dose,
    times: Codecs.parseTimes(r.times),
    days: Codecs.parseDays(r.days),
    refillCount: r.refillCount,
    remindRefill: r.remindRefill,
    refillRemindAt: r.refillRemindAt,
  );

  @override
  Stream<bool> watchEnabled() =>
      _db.watchPref(PrefKeys.medicineEnabled).map((v) => v == 'true');

  @override
  Future<void> setEnabled(bool enabled) =>
      _db.writePref(PrefKeys.medicineEnabled, enabled ? 'true' : 'false');

  @override
  Stream<List<Medicine>> watchMedicines() => _db
      .select(_db.medicines)
      .watch()
      .map((rows) => rows.map(_medicine).toList());

  @override
  Future<void> save(Medicine m) => _db
      .into(_db.medicines)
      .insertOnConflictUpdate(
        MedicinesCompanion.insert(
          id: m.id,
          name: m.name,
          dose: m.dose,
          times: Codecs.times(m.times),
          days: Codecs.days(m.days),
          refillCount: Value(m.refillCount),
          remindRefill: Value(m.remindRefill),
          refillRemindAt: Value(m.refillRemindAt),
        ),
      );

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.medicines)..where((t) => t.id.equals(id))).go();
    await (_db.delete(_db.doses)..where((t) => t.medicineId.equals(id))).go();
  }

  /// The last seven days of scheduled doses, newest first: answered ones as
  /// stored, the rest due until [missedAfter] past their time, then missed.
  @override
  Stream<List<DoseLog>> watchDoses() {
    final first = _startOfDay(_now()).subtract(const Duration(days: 6));
    final answered =
        (_db.select(_db.doses)..where(
              (t) => t.scheduledAt.isBiggerOrEqualValue(
                first.millisecondsSinceEpoch,
              ),
            ))
            .watch();
    return _combine([watchMedicines(), answered], (v) {
      final meds = v[0]! as List<Medicine>;
      final rows = v[1]! as List<DoseRow>;
      final now = _now();
      final logs = <DoseLog>[];
      for (var i = 0; i < 7; i++) {
        final day = DateTime(first.year, first.month, first.day + i);
        for (final m in meds) {
          if (!m.days.contains(day.weekday)) continue;
          for (final t in m.times) {
            final at = t.on(day);
            final row = rows
                .where(
                  (r) =>
                      r.medicineId == m.id &&
                      r.scheduledAt == at.millisecondsSinceEpoch,
                )
                .firstOrNull;
            final status = row != null
                ? DoseStatus.values[row.status]
                : now.difference(at) > missedAfter
                ? DoseStatus.missed
                : DoseStatus.due;
            logs.add(
              DoseLog(medicineId: m.id, scheduledAt: at, status: status),
            );
          }
        }
      }
      logs.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
      return logs;
    });
  }

  @override
  Future<void> setDoseStatus(DoseLog dose, DoseStatus status) async {
    await _db
        .into(_db.doses)
        .insertOnConflictUpdate(
          DosesCompanion.insert(
            medicineId: dose.medicineId,
            scheduledAt: dose.scheduledAt.millisecondsSinceEpoch,
            status: status.index,
          ),
        );
    if (status == DoseStatus.taken && dose.status != DoseStatus.taken) {
      await _db.customUpdate(
        'UPDATE medicines SET refill_count = MAX(refill_count - 1, 0) WHERE id = ?',
        variables: [Variable.withString(dose.medicineId)],
        updates: {_db.medicines},
      );
    }
  }
}

// Modes.

/// The three presets, created on first run. They can be edited and reset but
/// not deleted.
const List<Mode> presetModes = [
  Mode(
    id: 'work',
    name: 'Work',
    purpose: 'Deep focus',
    isPreset: true,
    greyscale: true,
    dnd: DndPolicy.starred,
    appPolicy: AppPolicy.blocked,
    timer: ModeTimer.pomodoro25,
    glyph: GlyphPattern.focusPulse,
  ),
  Mode(
    id: 'go-out',
    name: 'Go Out',
    purpose: 'Be present with people',
    isPreset: true,
    greyscale: true,
    dnd: DndPolicy.calls,
    appPolicy: AppPolicy.nudgeAfter,
    waterOn: false,
    glyph: GlyphPattern.callsOnly,
  ),
  Mode(
    id: 'binge',
    name: 'Binge Time',
    purpose: 'Guilt-free leisure, with a cap',
    isPreset: true,
    appPolicy: AppPolicy.allowed,
    timer: ModeTimer.fixed,
    timerMin: 60,
    glyph: GlyphPattern.countdown,
  ),
];

class DriftModeRepository implements ModeRepository {
  DriftModeRepository(this._db, this._now);

  final VeronicaDatabase _db;
  final DateTime Function() _now;

  /// Creates the presets the first time the modes are read.
  Future<void> _seed() async {
    final count = await _db.select(_db.modes).get();
    if (count.isNotEmpty) return;
    for (final (i, m) in presetModes.indexed) {
      await _db
          .into(_db.modes)
          .insert(
            ModesCompanion.insert(id: m.id, position: i, json: Codecs.mode(m)),
            mode: InsertMode.insertOrIgnore,
          );
    }
  }

  @override
  Stream<List<Mode>> watchModes() async* {
    await _seed();
    yield* (_db.select(_db.modes)
          ..orderBy([(t) => OrderingTerm.asc(t.position)]))
        .watch()
        .map((rows) => [for (final r in rows) Codecs.parseMode(r.json)]);
  }

  @override
  Future<void> save(Mode mode) async {
    final rows = await _db.select(_db.modes).get();
    final existing = rows.where((r) => r.id == mode.id).firstOrNull;
    final position =
        existing?.position ??
        rows.fold<int>(-1, (p, r) => r.position > p ? r.position : p) + 1;
    await _db
        .into(_db.modes)
        .insertOnConflictUpdate(
          ModesCompanion.insert(
            id: mode.id,
            position: position,
            json: Codecs.mode(mode),
          ),
        );
  }

  @override
  Future<void> delete(String id) async {
    final modes = await watchModes().first;
    final mode = modes.where((m) => m.id == id).firstOrNull;
    if (mode == null || mode.isPreset) return;
    final active = await watchActive().first;
    if (active?.modeId == id) await end();
    await (_db.delete(_db.modes)..where((t) => t.id.equals(id))).go();
  }

  @override
  Stream<ActiveMode?> watchActive() => _db
      .watchPref(PrefKeys.activeMode)
      .map((j) => j == null ? null : Codecs.parseActiveMode(j));

  @override
  Future<void> start(String modeId, {int? minutes}) {
    final now = _now();
    return _db.writePref(
      PrefKeys.activeMode,
      Codecs.activeMode(
        ActiveMode(
          modeId: modeId,
          startedAt: now,
          endsAt: minutes == null ? null : now.add(Duration(minutes: minutes)),
        ),
      ),
    );
  }

  @override
  Future<void> end() => _db.writePref(PrefKeys.activeMode, null);

  @override
  Future<void> adopt(ActiveMode? active) => _db.writePref(
    PrefKeys.activeMode,
    active == null ? null : Codecs.activeMode(active),
  );
}

// Sleep, alarms and sounds.

/// Picks an audio file and copies it into the app: the sound and where its
/// copy is, or null if cancelled.
typedef SoundPicker = Future<({AlarmSound sound, String path})?> Function();

/// Estimated nights (from screen-off time on the phone).
typedef NightSource = Future<List<NightLog>> Function(SleepSchedule schedule);

class DriftSleepRepository implements SleepRepository {
  DriftSleepRepository(
    this._db, {
    required this.pickSound,
    required this.nights,
    required this.deleteFile,
  });

  final VeronicaDatabase _db;
  final SoundPicker pickSound;
  final NightSource nights;
  final Future<void> Function(String path) deleteFile;

  @override
  Stream<SleepSchedule> watchSchedule() => _db
      .watchPref(PrefKeys.sleep)
      .map((j) => j == null ? const SleepSchedule() : Codecs.parseSleep(j));

  @override
  Future<void> saveSchedule(SleepSchedule schedule) =>
      _db.writePref(PrefKeys.sleep, Codecs.sleep(schedule));

  @override
  Stream<List<Alarm>> watchAlarms() => _db
      .select(_db.alarms)
      .watch()
      .map(
        (rows) =>
            [for (final r in rows) Codecs.parseAlarm(r.json)]
              ..sort((a, b) => a.time.compareTo(b.time)),
      );

  @override
  Future<void> saveAlarm(Alarm alarm) => _db
      .into(_db.alarms)
      .insertOnConflictUpdate(
        AlarmsCompanion.insert(id: alarm.id, json: Codecs.alarm(alarm)),
      );

  @override
  Future<void> deleteAlarm(String id) =>
      (_db.delete(_db.alarms)..where((t) => t.id.equals(id))).go();

  @override
  Stream<List<NightLog>> watchNights() =>
      watchSchedule().asyncMap((s) => nights(s));

  static AlarmSound _sound(SoundRow r) => AlarmSound(
    id: r.id,
    name: r.name,
    length: Duration(milliseconds: r.lengthMs),
    importedAt: DateTime.fromMillisecondsSinceEpoch(r.importedAt),
  );

  @override
  Stream<List<AlarmSound>> watchSounds() =>
      (_db.select(_db.sounds)..orderBy([(t) => OrderingTerm.asc(t.importedAt)]))
          .watch()
          .map((rows) => rows.map(_sound).toList());

  @override
  Future<String?> soundPath(String id) async => (await (_db.select(
    _db.sounds,
  )..where((t) => t.id.equals(id))).getSingleOrNull())?.path;

  @override
  Future<void> importSound() async {
    final picked = await pickSound();
    if (picked != null) await addSound(picked.sound, picked.path);
  }

  @override
  Future<void> syncPhoneSounds(List<(String, String, Duration)> tones) =>
      _db.transaction(() async {
        final keep = <String>{};
        for (final (i, (title, uri, length)) in tones.indexed) {
          final id = '${AlarmSound.phonePrefix}${_stableHash(uri)}';
          keep.add(id);
          // Before every import, the default tone first.
          await _db
              .into(_db.sounds)
              .insertOnConflictUpdate(
                SoundsCompanion.insert(
                  id: id,
                  name: title,
                  lengthMs: length.inMilliseconds,
                  importedAt: i,
                  path: uri,
                ),
              );
        }
        // Tones no longer on the phone.
        await (_db.delete(_db.sounds)..where(
              (t) =>
                  t.id.like('${AlarmSound.phonePrefix}%') & t.id.isNotIn(keep),
            ))
            .go();
      });

  static String _stableHash(String s) {
    var h = 0x811c9dc5;
    for (final c in s.codeUnits) {
      h = ((h ^ c) * 0x01000193) & 0xffffffff;
    }
    return h.toRadixString(16);
  }

  /// Stores a sound whose audio is already copied into the app.
  Future<void> addSound(AlarmSound sound, String path) => _db
      .into(_db.sounds)
      .insertOnConflictUpdate(
        SoundsCompanion.insert(
          id: sound.id,
          name: sound.name,
          lengthMs: sound.length.inMilliseconds,
          importedAt: sound.importedAt.millisecondsSinceEpoch,
          path: path,
        ),
      );

  @override
  Future<void> renameSound(String id, String name) => (_db.update(
    _db.sounds,
  )..where((t) => t.id.equals(id))).write(SoundsCompanion(name: Value(name)));

  @override
  Future<void> deleteSound(String id) async {
    final path = await soundPath(id);
    await (_db.delete(_db.sounds)..where((t) => t.id.equals(id))).go();
    if (path != null && path.isNotEmpty) await deleteFile(path);
  }
}

// Mantras.

const List<String> starterMantras = [
  'I am here. This is enough.',
  'One thing at a time.',
  'The phone can wait.',
  'Breathe out longer than in.',
  'Small steps count.',
  'Rest is part of the work.',
];

class DriftMantraRepository implements MantraRepository {
  DriftMantraRepository(this._db, this._now);

  final VeronicaDatabase _db;
  final DateTime Function() _now;

  Future<void> _seed() async {
    final rows = await _db.select(_db.mantras).get();
    if (rows.isNotEmpty) return;
    final now = _now().millisecondsSinceEpoch;
    for (final (i, text) in starterMantras.indexed) {
      await _db
          .into(_db.mantras)
          .insert(
            MantrasCompanion.insert(
              id: 'starter-$i',
              body: text,
              isStarter: const Value(true),
              addedAt: now + i,
            ),
            mode: InsertMode.insertOrIgnore,
          );
    }
  }

  @override
  Stream<List<Mantra>> watchMantras() async* {
    await _seed();
    yield* (_db.select(
      _db.mantras,
    )..orderBy([(t) => OrderingTerm.asc(t.addedAt)])).watch().map(
      (rows) => [
        for (final r in rows)
          Mantra(
            id: r.id,
            text: r.body,
            isStarter: r.isStarter,
            lastShownAt: r.lastShownAt == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(r.lastShownAt!),
          ),
      ],
    );
  }

  @override
  Future<void> save(Mantra mantra) async {
    final existing = await (_db.select(
      _db.mantras,
    )..where((t) => t.id.equals(mantra.id))).getSingleOrNull();
    await _db
        .into(_db.mantras)
        .insertOnConflictUpdate(
          MantrasCompanion.insert(
            id: mantra.id,
            body: mantra.text,
            isStarter: Value(mantra.isStarter),
            lastShownAt: Value(mantra.lastShownAt?.millisecondsSinceEpoch),
            addedAt: existing?.addedAt ?? _now().millisecondsSinceEpoch,
          ),
        );
  }

  @override
  Future<void> delete(String id) =>
      (_db.delete(_db.mantras)..where((t) => t.id.equals(id))).go();

  @override
  Stream<MantraSettings> watchSettings() => _db
      .watchPref(PrefKeys.mantra)
      .map(
        (j) =>
            j == null ? const MantraSettings() : Codecs.parseMantraSettings(j),
      );

  @override
  Future<void> saveSettings(MantraSettings settings) =>
      _db.writePref(PrefKeys.mantra, Codecs.mantraSettings(settings));
}

// Voice and Glyph settings.

class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._db, {required this.voiceModel});

  final VeronicaDatabase _db;

  /// Whether the offline voice model is downloaded.
  final Stream<VoiceModelState> voiceModel;

  @override
  Stream<VoiceSettings> watchVoice() => _combine(
    [_db.watchPref(PrefKeys.voice), voiceModel],
    (v) => Codecs.parseVoice(
      (v[0] as String?) ?? Codecs.voice(const VoiceSettings()),
      model: v[1]! as VoiceModelState,
    ),
  );

  @override
  Future<void> saveVoice(VoiceSettings settings) =>
      _db.writePref(PrefKeys.voice, Codecs.voice(settings));

  @override
  Stream<GlyphSettings> watchGlyph() => _db
      .watchPref(PrefKeys.glyph)
      .map((j) => j == null ? const GlyphSettings() : Codecs.parseGlyph(j));

  @override
  Future<void> saveGlyph(GlyphSettings settings) =>
      _db.writePref(PrefKeys.glyph, Codecs.glyph(settings));
}

// Audio mantras.

/// Picks audio files and copies them into the app: (title, path, length).
typedef MantraFilePicker = Future<List<(String, String, Duration)>> Function();

/// Looks up YouTube links: (title, link, length) per video, a playlist
/// expanded to its videos.
typedef YouTubeLookup = Future<List<(String, String, Duration)>> Function(
  List<String> links,
);

class DriftListeningRepository implements ListeningRepository {
  DriftListeningRepository(
    this._db,
    this._now, {
    required this.pickFiles,
    required this.lookUp,
    required this.deleteFile,
  });

  final VeronicaDatabase _db;
  final DateTime Function() _now;
  final MantraFilePicker pickFiles;
  final YouTubeLookup lookUp;
  final Future<void> Function(String path) deleteFile;

  static AudioMantra _mantra(AudioMantraRow r) => AudioMantra(
    id: r.id,
    title: r.title,
    source: r.source,
    youTube: r.youTube,
    length: Duration(milliseconds: r.lengthMs),
    addedAt: DateTime.fromMillisecondsSinceEpoch(r.addedAt),
  );

  @override
  Stream<List<AudioMantra>> watchAudio() =>
      (_db.select(_db.audioMantras)
            ..orderBy([(t) => OrderingTerm.asc(t.addedAt)]))
          .watch()
          .map((rows) => rows.map(_mantra).toList());

  Future<void> _add(
    List<(String, String, Duration)> items, {
    required bool youTube,
  }) async {
    final base = _now().microsecondsSinceEpoch;
    for (final (i, (title, source, length)) in items.indexed) {
      await _db
          .into(_db.audioMantras)
          .insert(
            AudioMantrasCompanion.insert(
              id: 'listen-${(base + i).toRadixString(36)}',
              title: title,
              source: source,
              youTube: Value(youTube),
              lengthMs: Value(length.inMilliseconds),
              // In the order they were picked.
              addedAt: base ~/ 1000 + i,
            ),
          );
    }
  }

  @override
  Future<void> importFiles() async => _add(await pickFiles(), youTube: false);

  @override
  Future<int> addYouTube(List<String> links) async {
    final videos = await lookUp(links);
    await _add(videos, youTube: true);
    return videos.length;
  }

  @override
  Future<void> rename(String id, String title) =>
      (_db.update(_db.audioMantras)..where((t) => t.id.equals(id))).write(
        AudioMantrasCompanion(title: Value(title)),
      );

  @override
  Future<void> setLength(String id, Duration length) =>
      (_db.update(_db.audioMantras)..where((t) => t.id.equals(id))).write(
        AudioMantrasCompanion(lengthMs: Value(length.inMilliseconds)),
      );

  @override
  Future<void> delete(String id) async {
    final row = await (_db.select(
      _db.audioMantras,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    await (_db.delete(_db.audioMantras)..where((t) => t.id.equals(id))).go();
    if (row != null && !row.youTube) await deleteFile(row.source);
    final settings = await watchSettings().first;
    if (settings.playId == id) {
      await saveSettings(settings.copyWith(playId: () => null));
    }
  }

  @override
  Stream<ListeningSettings> watchSettings() => _db
      .watchPref(PrefKeys.listening)
      .map(
        (j) => j == null ? const ListeningSettings() : Codecs.parseListening(j),
      );

  @override
  Future<void> saveSettings(ListeningSettings settings) =>
      _db.writePref(PrefKeys.listening, Codecs.listening(settings));
}

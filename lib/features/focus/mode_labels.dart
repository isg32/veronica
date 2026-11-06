import '../../core/format.dart';
import '../../data/models/models.dart';

/// A short label for what a mode turns on, shown as a chip.
class ModeChip {
  const ModeChip(this.label, {this.off = false});

  final String label;

  /// Something the mode turns *off* (drawn dashed), e.g. "Water off".
  final bool off;
}

abstract final class ModeLabels {
  /// "Deep focus · weekdays 10:00".
  static String subtitle(Mode mode) {
    final s = mode.schedule;
    if (s == null || s.days.isEmpty) return mode.purpose;
    final days = VFormat.daysWord(s.days);
    return '${mode.purpose} · $days ${s.start.label}';
  }

  static List<ModeChip> chips(Mode mode) {
    return [
      if (mode.greyscale) const ModeChip('Greyscale'),
      if (mode.dnd == DndPolicy.starred) const ModeChip('DND · starred'),
      if (mode.dnd == DndPolicy.calls) const ModeChip('DND · calls'),
      switch (mode.appPolicy) {
        AppPolicy.blocked => ModeChip(
          'Block ${VFormat.count(mode.blockedApps.length, 'app')}',
        ),
        AppPolicy.nudgeAfter => ModeChip(
          'Nudge after ${mode.nudgeAfterMin} min',
        ),
        AppPolicy.allowed => const ModeChip('Apps allowed'),
        AppPolicy.usual => const ModeChip('Usual limits'),
      },
      if (mode.timer == ModeTimer.pomodoro25) const ModeChip('Pomodoro 25/5'),
      if (mode.timer == ModeTimer.pomodoro50) const ModeChip('Pomodoro 50/10'),
      if (mode.timer == ModeTimer.fixed && mode.timerMin != null)
        ModeChip('${mode.timerMin} min'),
      if (mode.glyph == GlyphPattern.countdown)
        const ModeChip('Glyph countdown'),
      if (mode.brightness != null)
        ModeChip('Dim ${(mode.brightness! * 100).round()}%'),
      if (mode.ringer == RingerMode.silent) const ModeChip('Silent'),
      if (mode.ringer == RingerMode.vibrate) const ModeChip('Vibrate'),
      if (mode.hideNotifications) const ModeChip('Hide notifications'),
      if (mode.blackWallpaper) const ModeChip('Black wallpaper'),
      mode.waterOn
          ? (mode.appPolicy == AppPolicy.allowed
                ? const ModeChip('Water on')
                : null)
          : const ModeChip('Water off', off: true),
    ].whereType<ModeChip>().toList();
  }

  /// Chips on the active mode screen: what is in effect right now.
  static List<String> activeChips(Mode mode) => [
    if (mode.greyscale) 'Greyscale',
    if (mode.dnd != DndPolicy.off) 'DND',
    if (mode.appPolicy == AppPolicy.blocked)
      '${VFormat.count(mode.blockedApps.length, 'app')} blocked',
    if (mode.ringer == RingerMode.silent) 'Silent',
  ];
}

/// Where a running mode is, for countdowns and the Pomodoro ring.
class ModeProgress {
  const ModeProgress({
    required this.display,
    required this.ringValue,
    required this.caption,
    this.eyebrow,
    this.finished = false,
  });

  factory ModeProgress.of(Mode mode, ActiveMode active, DateTime now) {
    final elapsed = now.difference(active.startedAt);

    if (active.endsAt != null) {
      final total = active.endsAt!.difference(active.startedAt);
      final left = active.endsAt!.difference(now);
      final done = left <= Duration.zero;
      return ModeProgress(
        display: VFormat.clock(done ? Duration.zero : left),
        ringValue: done ? 0 : left.inSeconds / total.inSeconds,
        caption: done ? "time's up" : 'then put it down',
        finished: done,
      );
    }

    final (focus, rest) = switch (mode.timer) {
      ModeTimer.pomodoro25 => (25, 5),
      ModeTimer.pomodoro50 => (50, 10),
      _ => (0, 0),
    };
    if (focus > 0) {
      final cycle = Duration(minutes: focus + rest);
      final round = elapsed.inSeconds ~/ cycle.inSeconds;
      final into = Duration(seconds: elapsed.inSeconds % cycle.inSeconds);
      final inFocus = into < Duration(minutes: focus);
      final phase = Duration(minutes: inFocus ? focus : rest);
      final left = (inFocus ? Duration(minutes: focus) : cycle) - into;
      return ModeProgress(
        eyebrow: inFocus ? 'FOCUS ${round % 4 + 1} OF 4' : 'BREAK',
        display: VFormat.clock(left),
        ringValue: left.inSeconds / phase.inSeconds,
        caption: inFocus ? 'then a $rest min break' : 'then back to focus',
      );
    }

    return ModeProgress(
      display: VFormat.clock(elapsed),
      ringValue: 1,
      caption: 'since ${VFormat.time(active.startedAt)}',
    );
  }

  final String? eyebrow;
  final String display;
  final double ringValue;
  final String caption;
  final bool finished;
}

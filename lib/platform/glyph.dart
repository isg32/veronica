import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nothing_glyph_interface/nothing_glyph_interface.dart';

import '../core/widgets/v_glyph_preview.dart';
import '../data/models/models.dart';
import '../data/providers.dart';
import '../features/settings/glyph_frames.dart';
import 'android_usage.dart';

/// Plays Veronica's patterns on the Nothing Phone (2a) Glyph lights.
///
/// The 2a has the strip C1–C24 (channels 0–23), B (24) and A (25). Patterns
/// are the same timings as the preview in Settings ([glyphFrameAt]), drawn
/// at about eight frames a second. Only an app in the foreground may light
/// the Glyphs, so patterns play while their page is open.
class GlyphPlayer {
  GlyphPlayer._();

  static final GlyphPlayer instance = GlyphPlayer._();

  static const _a = 25;
  static const _b = 24;
  static const _frame = Duration(milliseconds: 125);

  final NothingGlyphInterface _glyph = NothingGlyphInterface();
  Future<bool>? _ready;
  Timer? _timer;
  String? _lastFrame;

  /// True on a Phone (2a) whose Glyph service connected.
  Future<bool> get available => _ready ??= _connect();

  Future<bool> _connect() async {
    if (!isAndroid) return false;
    try {
      if (await _glyph.is23111() != true && await _glyph.is23113() != true) {
        return false;
      }
      await _glyph.init();
      return true;
    } on Object {
      return false;
    }
  }

  /// Plays [signal] until [stop] (or another pattern starts).
  Future<void> play(GlyphSignal signal) async {
    if (!await available) return;
    stop();
    final start = DateTime.now();
    _timer = Timer.periodic(_frame, (_) {
      final t = DateTime.now().difference(start).inMilliseconds / 1000;
      unawaited(_show(glyphFrameAt(signal, t)));
    });
  }

  Future<void> _show(GlyphFrame frame) async {
    final key = '${frame.lit}:${frame.only}:${frame.a}:${frame.b}';
    if (key == _lastFrame) return;
    _lastFrame = key;
    final channels = [
      for (var i = 0; i < 24; i++)
        if (frame.litC(i)) i,
      if (frame.b) _b,
      if (frame.a) _a,
    ];
    try {
      if (channels.isEmpty) {
        await _glyph.turnOff();
        return;
      }
      var builder = GlyphFrameBuilder();
      for (final c in channels) {
        builder = builder.buildChannel(c);
      }
      await _glyph.buildGlyphFrame(builder.build());
      await _glyph.toggle();
    } on Object {
      // A missed frame is fine; the next one redraws.
    }
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _lastFrame = null;
    if (_ready != null) {
      unawaited(_glyph.turnOff().catchError((Object _) {}));
    }
  }
}

/// Whether this phone has Glyph lights Veronica can drive.
final glyphAvailableProvider = FutureProvider<bool>(
  (ref) => GlyphPlayer.instance.available,
);

/// Plays [signal] on the Glyph lights while this widget is on screen,
/// except during the Glyph quiet hours.
class GlyphWhileShown extends ConsumerStatefulWidget {
  const GlyphWhileShown({super.key, required this.signal, required this.child});

  final GlyphSignal signal;
  final Widget child;

  @override
  ConsumerState<GlyphWhileShown> createState() => _GlyphWhileShownState();
}

class _GlyphWhileShownState extends ConsumerState<GlyphWhileShown> {
  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  Future<void> _start() async {
    final settings = await ref
        .read(settingsRepositoryProvider)
        .watchGlyph()
        .first;
    if (!mounted || _quiet(settings, DateTime.now())) return;
    await GlyphPlayer.instance.play(widget.signal);
  }

  static bool _quiet(GlyphSettings s, DateTime now) {
    final t = DayTime.of(now).inMinutes;
    final from = s.quietFrom.inMinutes, to = s.quietTo.inMinutes;
    return from <= to ? (t >= from && t < to) : (t >= from || t < to);
  }

  @override
  void dispose() {
    GlyphPlayer.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

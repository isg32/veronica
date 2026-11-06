import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/home_widgets/home_widget_views.dart';

part 'wallpaper.g.dart';

bool get _android => !kIsWeb && Platform.isAndroid;

/// Reads the home-screen wallpaper (needs "All files access").
/// See `android/.../widgets/WallpaperChannel.kt`.
abstract final class WallpaperService {
  static const _channel = MethodChannel('veronica/wallpaper');

  static Future<bool> hasAccess() async =>
      _android && (await _channel.invokeMethod<bool>('hasAccess') ?? false);

  static Future<void> requestAccess() async {
    if (_android) await _channel.invokeMethod<void>('requestAccess');
  }

  /// Changes whenever the wallpaper changes.
  static Future<int> wallpaperId() async =>
      _android ? await _channel.invokeMethod<int>('wallpaperId') ?? -1 : -1;

  /// The wallpaper centre-cropped to the screen's aspect ratio, or null.
  static Future<ui.Image?> image() async {
    if (!_android) return null;
    final bytes = await _channel.invokeMethod<Uint8List>('wallpaper');
    if (bytes == null) return null;
    final codec = await ui.instantiateImageCodec(bytes);
    return (await codec.getNextFrame()).image;
  }
}

enum WidgetGlass { tinted, blur }

/// How the home widgets draw their glass, and where each one sits on the
/// home screen (as a fraction of the screen, top-left corner). The launcher
/// doesn't tell apps where a widget is, so the user places them once.
class WidgetGlassSettings {
  const WidgetGlassSettings({required this.style, required this.positions});

  final WidgetGlass style;
  final Map<HomeWidgetKind, ui.Offset> positions;

  /// A reasonable starting layout: the widgets stacked from the top.
  static ui.Offset defaultPosition(HomeWidgetKind kind) => switch (kind) {
    HomeWidgetKind.screenTime => const ui.Offset(0.05, 0.12),
    HomeWidgetKind.water => const ui.Offset(0.52, 0.12),
    HomeWidgetKind.nextAlarm => const ui.Offset(0.52, 0.22),
    HomeWidgetKind.modeSwitch => const ui.Offset(0.05, 0.33),
    HomeWidgetKind.oldestTasks => const ui.Offset(0.05, 0.44),
    HomeWidgetKind.mantra => const ui.Offset(0.05, 0.66),
  };

  ui.Offset positionOf(HomeWidgetKind kind) =>
      positions[kind] ?? defaultPosition(kind);

  String get signature => [
    style.name,
    for (final k in HomeWidgetKind.values)
      '${positionOf(k).dx.toStringAsFixed(3)},${positionOf(k).dy.toStringAsFixed(3)}',
  ].join('|');
}

/// Persisted in the widgets' native shared preferences (via home_widget), so
/// it survives restarts and needs no extra storage.
@Riverpod(keepAlive: true)
class WidgetGlassController extends _$WidgetGlassController {
  static const _styleKey = 'widget_glass_style';
  static String _xKey(HomeWidgetKind k) => 'widget_${k.name}_x';
  static String _yKey(HomeWidgetKind k) => 'widget_${k.name}_y';

  @override
  Future<WidgetGlassSettings> build() async {
    if (!_android) {
      return const WidgetGlassSettings(
        style: WidgetGlass.tinted,
        positions: {},
      );
    }
    final style = await HomeWidget.getWidgetData<String>(_styleKey);
    final positions = <HomeWidgetKind, ui.Offset>{};
    for (final k in HomeWidgetKind.values) {
      final x = await HomeWidget.getWidgetData<double>(_xKey(k));
      final y = await HomeWidget.getWidgetData<double>(_yKey(k));
      if (x != null && y != null) positions[k] = ui.Offset(x, y);
    }
    return WidgetGlassSettings(
      style: style == WidgetGlass.blur.name
          ? WidgetGlass.blur
          : WidgetGlass.tinted,
      positions: positions,
    );
  }

  Future<void> setStyle(WidgetGlass style) async {
    if (_android) {
      await HomeWidget.saveWidgetData<String>(_styleKey, style.name);
    }
    final current = await future;
    state = AsyncData(
      WidgetGlassSettings(style: style, positions: current.positions),
    );
  }

  Future<void> setPosition(HomeWidgetKind kind, ui.Offset position) async {
    final p = ui.Offset(position.dx.clamp(0, 1), position.dy.clamp(0, 1));
    if (_android) {
      await HomeWidget.saveWidgetData<double>(_xKey(kind), p.dx);
      await HomeWidget.saveWidgetData<double>(_yKey(kind), p.dy);
    }
    final current = await future;
    state = AsyncData(
      WidgetGlassSettings(
        style: current.style,
        positions: {...current.positions, kind: p},
      ),
    );
  }
}

/// Whether Veronica may read the wallpaper. Re-checked on demand.
@riverpod
Future<bool> wallpaperAccess(Ref ref) => WallpaperService.hasAccess();

/// The current wallpaper, re-read only when its id changes.
@Riverpod(keepAlive: true)
class WallpaperImage extends _$WallpaperImage {
  int? _id;

  @override
  Future<ui.Image?> build() async {
    _id = await WallpaperService.wallpaperId();
    return WallpaperService.image();
  }

  /// Re-reads the wallpaper if it changed (or access was just granted).
  Future<void> refreshIfChanged({bool force = false}) async {
    final id = await WallpaperService.wallpaperId();
    if (!force && id == _id && state.value != null) return;
    _id = id;
    state = AsyncData(await WallpaperService.image());
  }
}

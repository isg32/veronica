import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:home_widget/home_widget.dart';

import '../../app/routes.dart';
import '../../core/theme/v_palette.dart';
import '../../core/theme/v_text.dart';
import '../../core/widgets/v_buttons.dart';
import '../../core/widgets/v_controls.dart';
import '../../core/widgets/v_list.dart';
import '../../core/widgets/v_page.dart';
import '../../core/widgets/v_surface.dart';
import '../../platform/wallpaper.dart';
import '../home_widgets/home_widget_views.dart';

/// "Glass style" on the Widgets settings page: tinted, or a fake frosted
/// blur made from the wallpaper (needs wallpaper access and placement).
class GlassStyleSection extends ConsumerStatefulWidget {
  const GlassStyleSection({super.key});

  @override
  ConsumerState<GlassStyleSection> createState() => _GlassStyleSectionState();
}

class _GlassStyleSectionState extends ConsumerState<GlassStyleSection>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Back from the system "All files access" screen.
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(wallpaperAccessProvider);
      ref.read(wallpaperImageProvider.notifier).refreshIfChanged(force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final glass = ref.watch(widgetGlassControllerProvider).value;
    final access = ref.watch(wallpaperAccessProvider).value ?? false;
    if (glass == null) return const SizedBox.shrink();
    final blur = glass.style == WidgetGlass.blur;

    return VListSection(
      header: const VEyebrow('Glass style'),
      children: [
        VListRow(
          title: 'Style',
          trailing: VSegmented<WidgetGlass>(
            compact: true,
            segments: const {
              WidgetGlass.tinted: 'Tinted',
              WidgetGlass.blur: 'Blur',
            },
            value: glass.style,
            onChanged: (s) =>
                ref.read(widgetGlassControllerProvider.notifier).setStyle(s),
          ),
        ),
        if (blur && !access)
          VListRow(
            title: 'Allow wallpaper access',
            subtitle:
                'Android only lets apps read the wallpaper with "All files '
                'access". Veronica reads nothing else.',
            trailing: VPill(
              'Allow',
              style: VText.inter(12, weight: 600),
              onTap: WallpaperService.requestAccess,
            ),
          ),
        if (blur && access)
          VListRow(
            title: 'Place widgets',
            subtitle: 'Line each one up with your home screen',
            onTap: () => context.push(Routes.settingsWidgetsPlace),
          ),
        VListRow(
          title: blur ? 'Blur' : 'Tinted',
          subtitle: blur
              ? 'The wallpaper behind each widget is blurred into it. Re-place '
                    'a widget if you move it.'
              : 'Black or white at low opacity. Works with any wallpaper.',
        ),
      ],
    );
  }
}

/// Drag each widget over the wallpaper to where it sits on the home screen,
/// so the blur behind it matches. The launcher doesn't tell apps where a
/// widget is, so this is done by hand once.
class WidgetPlacementPage extends ConsumerStatefulWidget {
  const WidgetPlacementPage({super.key});

  @override
  ConsumerState<WidgetPlacementPage> createState() =>
      _WidgetPlacementPageState();
}

class _WidgetPlacementPageState extends ConsumerState<WidgetPlacementPage> {
  /// Positions while dragging, before they are saved.
  final Map<HomeWidgetKind, Offset> _dragging = {};
  Set<HomeWidgetKind>? _installed;

  @override
  void initState() {
    super.initState();
    _loadInstalled();
  }

  Future<void> _loadInstalled() async {
    if (kIsWeb || !Platform.isAndroid) return;
    final infos = await HomeWidget.getInstalledWidgets();
    final names = infos.map((i) => i.androidClassName ?? '').toSet();
    if (!mounted) return;
    setState(() {
      _installed = {
        for (final k in HomeWidgetKind.values)
          if (names.any((n) => n.endsWith(k.androidClass))) k,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final glass = ref.watch(widgetGlassControllerProvider).value;
    final wallpaper = ref.watch(wallpaperImageProvider).value;
    final data = ref.watch(homeWidgetSnapshotProvider);
    final light = !VPalette.of(context).isDark;
    final screen = MediaQuery.sizeOf(context);
    final installed = _installed;
    final kinds = installed == null || installed.isEmpty
        ? HomeWidgetKind.values
        : HomeWidgetKind.values.where(installed.contains).toList();

    return VDetailPage(
      backLabel: 'Widgets',
      title: 'Place widgets',
      children: [
        Text(
          installed != null && installed.isEmpty
              ? 'Add Veronica widgets to your home screen first. Until then, '
                    'all six are shown here.'
              : 'Drag each widget to where it sits on your home screen. The '
                    'blur behind it follows.',
          style: VText.secondary,
        ),
        if (glass == null || wallpaper == null)
          const VCard(child: Text('Reading your wallpaper…'))
        else
          LayoutBuilder(
            builder: (context, box) {
              final width = box.maxWidth;
              final scale = width / screen.width;
              final height = screen.height * scale;
              return ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: RawImage(image: wallpaper, fit: BoxFit.fill),
                      ),
                      for (final kind in kinds)
                        _draggable(
                          kind: kind,
                          position: _dragging[kind] ?? glass.positionOf(kind),
                          preview: Size(width, height),
                          scale: scale,
                          child: HomeWidgetView(
                            kind: kind,
                            data: data,
                            light: light,
                            backdrop: WidgetBackdrop(
                              wallpaper: wallpaper,
                              screen: screen,
                              topLeft:
                                  (_dragging[kind] ?? glass.positionOf(kind))
                                      .scale(screen.width, screen.height),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        VButton.ghost(
          'Reset positions',
          onPressed: () async {
            final c = ref.read(widgetGlassControllerProvider.notifier);
            for (final k in HomeWidgetKind.values) {
              await c.setPosition(k, WidgetGlassSettings.defaultPosition(k));
            }
          },
        ),
      ],
    );
  }

  Widget _draggable({
    required HomeWidgetKind kind,
    required Offset position,
    required Size preview,
    required double scale,
    required Widget child,
  }) {
    return Positioned(
      left: position.dx * preview.width,
      top: position.dy * preview.height,
      width: kind.size.width * scale,
      height: kind.size.height * scale,
      child: GestureDetector(
        onPanUpdate: (d) => setState(() {
          final p = _dragging[kind] ?? position;
          _dragging[kind] = Offset(
            (p.dx + d.delta.dx / preview.width).clamp(0, 1),
            (p.dy + d.delta.dy / preview.height).clamp(0, 1),
          );
        }),
        onPanEnd: (_) async {
          final p = _dragging[kind];
          if (p == null) return;
          await ref
              .read(widgetGlassControllerProvider.notifier)
              .setPosition(kind, p);
          if (mounted) setState(() => _dragging.remove(kind));
        },
        child: FittedBox(child: child),
      ),
    );
  }
}

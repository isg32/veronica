import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../icons/v_icons.dart';
import '../theme/v_colors.dart';
import '../theme/v_text.dart';
import '../theme/v_tokens.dart';
import 'v_ink.dart';
import 'v_surface.dart';

/// Frosted glass: the only translucency in the app. It blurs what is behind
/// it, adds one of the named tints from [VColors] and a 1 px border.
class VGlass extends StatelessWidget {
  const VGlass({
    super.key,
    required this.child,
    required this.radius,
    this.tint = VColors.glassBar,
    this.blur = 18,
    this.border = true,
    this.borderRadius,
  });

  final Widget child;
  final double radius;
  final Color tint;
  final double blur;
  final bool border;

  /// Overrides [radius] for shapes like a sheet with only top corners.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final shape = borderRadius ?? BorderRadius.circular(radius);
    return ClipRRect(
      borderRadius: shape,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tint,
            borderRadius: shape,
            border: border
                ? Border.all(color: VInk.of(context), width: VSpace.hairline)
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// One tab of [VTabBar].
class VTabItem {
  const VTabItem(this.label, this.icon);

  final String label;
  final VIcon icon;
}

/// The floating glass capsule tab bar. The active tab is a white pill with
/// icon and label; the others show only their icon.
class VTabBar extends StatelessWidget {
  const VTabBar({
    super.key,
    required this.items,
    required this.index,
    required this.onTap,
  });

  final List<VTabItem> items;
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 22),
      child: VGlass(
        radius: 31,
        child: SizedBox(
          height: 62,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < items.length; i++)
                  _Tab(
                    item: items[i],
                    selected: i == index,
                    onTap: () => onTap(i),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.item, required this.selected, required this.onTap});

  final VTabItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: VMotion.standard,
          curve: VMotion.curve,
          padding: selected
              ? const EdgeInsets.symmetric(horizontal: 14, vertical: 10)
              : const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: selected ? VColors.white : VColors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              VIconView(
                item.icon,
                size: selected ? 18 : 20,
                strokeWidth: selected ? 2 : 1.5,
                color: selected ? VColors.black : VColors.white,
              ),
              if (selected) ...[
                const SizedBox(width: 6),
                Text(
                  item.label,
                  style: VText.inter(
                    12,
                    weight: 600,
                  ).copyWith(color: VColors.black),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows a glass bottom sheet with a handle and an eyebrow title.
Future<T?> showVSheet<T>(
  BuildContext context, {
  required String title,
  required WidgetBuilder builder,
}) {
  return showCupertinoModalPopup<T>(
    context: context,
    barrierColor: VColors.transparent,
    builder: (context) => VSheet(title: title, child: builder(context)),
  );
}

/// The glass bottom sheet used by [showVSheet].
class VSheet extends StatelessWidget {
  const VSheet({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: VInkScope(
        ink: VColors.white,
        child: VGlass(
          radius: VRadius.sheet,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(VRadius.sheet),
          ),
          tint: VColors.glassSheet,
          blur: 14,
          border: false,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: VColors.white)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: VColors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(title.toUpperCase(), style: VText.eyebrow),
                    const SizedBox(height: 14),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A text field in an outlined (or dashed) box, for sheets and editors.
class VTextField extends StatelessWidget {
  const VTextField({
    super.key,
    required this.controller,
    this.placeholder,
    this.dashed = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.style,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? placeholder;
  final bool dashed;
  final bool autofocus;
  final int maxLines;
  final TextStyle? style;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final ink = VInk.of(context);
    return VOutlined(
      radius: 16,
      outline: dashed ? VOutline.dashed : VOutline.solid,
      child: CupertinoTextField(
        controller: controller,
        autofocus: autofocus,
        maxLines: maxLines,
        minLines: 1,
        onSubmitted: onSubmitted,
        cursorColor: ink,
        padding: const EdgeInsets.all(14),
        placeholder: placeholder,
        placeholderStyle: VText.inter(14, weight: 300).copyWith(color: ink),
        style: (style ?? VText.inter(17)).copyWith(color: ink),
        decoration: const BoxDecoration(color: VColors.transparent),
      ),
    );
  }
}

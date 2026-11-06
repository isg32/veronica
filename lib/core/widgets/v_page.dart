import 'package:flutter/cupertino.dart';

import '../icons/v_icons.dart';
import 'v_ink.dart';
import '../theme/v_text.dart';
import '../theme/v_tokens.dart';
import 'v_buttons.dart';

/// Page title row: large Doto title with an optional trailing action, and an
/// optional eyebrow above it (the date on Today).
class VPageTitle extends StatelessWidget {
  const VPageTitle(
    this.title, {
    super.key,
    this.eyebrow,
    this.trailing,
    this.style,
  });

  final String title;
  final String? eyebrow;
  final Widget? trailing;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        VSpace.titleGutter,
        16,
        VSpace.titleGutter,
        14,
      ),
      child: Row(
        crossAxisAlignment: eyebrow == null
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (eyebrow != null) ...[
                  Text(eyebrow!.toUpperCase(), style: VText.eyebrow),
                  const SizedBox(height: 8),
                ],
                Text(title, style: style ?? VText.title),
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );
  }
}

/// "‹ Parent" link at the top of a detail page.
class VBackLink extends StatelessWidget {
  const VBackLink(this.label, {super.key, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VTappable(
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VIconView(VIcon.back, size: 18, strokeWidth: 1.6),
            const SizedBox(width: 4),
            Text(label, style: VText.inter(14)),
          ],
        ),
      ),
    );
  }
}

/// Frame for a tab page: title, then scrolling content that clears the
/// floating tab bar.
class VTabPage extends StatelessWidget {
  const VTabPage({
    super.key,
    required this.title,
    required this.children,
    this.eyebrow,
    this.trailing,
    this.titleStyle,
    this.header,
  });

  final String title;
  final String? eyebrow;
  final Widget? trailing;
  final TextStyle? titleStyle;

  /// Widget between the title and the cards (e.g. a segmented control).
  final Widget? header;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: VInk.surfaceOf(context),
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: VPageTitle(
                title,
                eyebrow: eyebrow,
                trailing: trailing,
                style: titleStyle,
              ),
            ),
            if (header != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: VSpace.gutter,
                  ),
                  child: header,
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                VSpace.gutter,
                0,
                VSpace.gutter,
                VSpace.tabBarClearance,
              ),
              sliver: SliverList.list(children: _gapped(children)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Frame for a pushed detail page: back link, title, optional action, then
/// scrolling content.
class VDetailPage extends StatelessWidget {
  const VDetailPage({
    super.key,
    required this.backLabel,
    required this.title,
    required this.children,
    this.action,
    this.titleStyle,
  });

  final String backLabel;
  final String title;
  final Widget? action;
  final TextStyle? titleStyle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: VInk.surfaceOf(context),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VBackLink(backLabel),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Transform.translate(
                      offset: const Offset(0, -6),
                      child: VPageTitle(
                        title,
                        trailing: action,
                        style: titleStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                VSpace.gutter,
                0,
                VSpace.gutter,
                40,
              ),
              sliver: SliverList.list(children: _gapped(children)),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> _gapped(List<Widget> children) => [
  for (var i = 0; i < children.length; i++) ...[
    if (i > 0) const SizedBox(height: VSpace.cardGap),
    children[i],
  ],
];

import 'package:flutter/widgets.dart';

import '../core/widgets/v_list.dart';
import '../core/widgets/v_page.dart';

/// Stand-in for a page that hasn't been built yet.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return VTabPage(
      title: title,
      children: const [VFootnote('Coming in Phase 0.')],
    );
  }
}

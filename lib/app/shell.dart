import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../core/icons/v_icons.dart';
import '../core/widgets/v_glass.dart';

/// The five tabs with the floating glass tab bar over them.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const tabs = [
    VTabItem('Today', VIcon.today),
    VTabItem('Focus', VIcon.focus),
    VTabItem('Tasks', VIcon.tasks),
    VTabItem('Care', VIcon.care),
    VTabItem('Sleep', VIcon.sleep),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: shell),
        Positioned(
          left: 0,
          right: 0,
          bottom: MediaQuery.paddingOf(context).bottom,
          child: VTabBar(
            items: tabs,
            index: shell.currentIndex,
            onTap: (i) =>
                shell.goBranch(i, initialLocation: i == shell.currentIndex),
          ),
        ),
      ],
    );
  }
}

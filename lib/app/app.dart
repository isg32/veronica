import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/v_colors.dart';
import '../core/theme/v_text.dart';
import '../core/theme/v_theme.dart';
import 'router.dart';

class VeronicaApp extends ConsumerWidget {
  const VeronicaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoApp.router(
      title: 'Veronica',
      debugShowCheckedModeBanner: false,
      theme: VTheme.data,
      color: VColors.black,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => DefaultTextStyle(
        style: VText.body.copyWith(color: VColors.white),
        child: ColoredBox(color: VColors.black, child: child),
      ),
    );
  }
}

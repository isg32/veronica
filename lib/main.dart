import 'package:flutter/cupertino.dart';

import 'core/theme/v_text.dart';
import 'core/theme/v_theme.dart';

void main() => runApp(const VeronicaApp());

class VeronicaApp extends StatelessWidget {
  const VeronicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Veronica',
      debugShowCheckedModeBanner: false,
      theme: VTheme.data,
      home: CupertinoPageScaffold(
        child: Center(child: Text('VERONICA', style: VText.title)),
      ),
    );
  }
}

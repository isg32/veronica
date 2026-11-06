import 'package:flutter/cupertino.dart';

import 'v_colors.dart';
import 'v_text.dart';

/// Cupertino theme with every default colour replaced by black or white.
abstract final class VTheme {
  static final CupertinoThemeData data = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: VColors.white,
    primaryContrastingColor: VColors.black,
    scaffoldBackgroundColor: VColors.black,
    barBackgroundColor: VColors.black,
    applyThemeToAll: true,
    textTheme: CupertinoTextThemeData(
      primaryColor: VColors.white,
      textStyle: VText.body.copyWith(color: VColors.white),
      actionTextStyle: VText.body.copyWith(color: VColors.white),
      navTitleTextStyle: VText.rowTitle.copyWith(color: VColors.white),
      navLargeTitleTextStyle: VText.title.copyWith(color: VColors.white),
      pickerTextStyle: VText.doto(22).copyWith(color: VColors.white),
      dateTimePickerTextStyle: VText.doto(22).copyWith(color: VColors.white),
      tabLabelTextStyle: VText.inter(
        12,
        weight: 600,
      ).copyWith(color: VColors.white),
    ),
  );
}

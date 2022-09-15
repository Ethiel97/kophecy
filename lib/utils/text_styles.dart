import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

//sora
//epilogue
//oxygen
//work sans

mixin TextStyles {
  static TextStyle get textStyle => GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.normal,
        // fontFeatures: [FontFeature.liningFigures(),],
        color:
            WidgetsBinding.instance.window.platformBrightness == Brightness.dark
                ? AppColors.darkColor
                : Colors.white,
        decoration: TextDecoration.none,
      );

  static TextStyle get secondaryTextStyle => GoogleFonts.sora(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        decoration: TextDecoration.none,
      );

  var textStyleLight = textStyle.apply(
    fontWeightDelta: -3,
    decoration: TextDecoration.none,
  );
}

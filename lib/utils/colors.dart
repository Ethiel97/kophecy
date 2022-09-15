import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

mixin AppColors {
  // static Color get primaryColor => Color();

  static Color get darkBackgroundColor => const Color(0xff060606);

  static Color get textColor => Colors.white.toTinyColor().lighten(2).color;

  static Color get whiteBackgroundColor => const Color(0xfff5f6f7);

  static Color get secondaryColor => const Color(0xff5F6F94);

  static Color get screenBackgroundColor => const Color(0xff2e537d).darken();

  static Color get darkColor => TinyColor.fromString('#140F2D').color;

  static Color get primaryColor => const Color(0xff12c2e9);

  static Color get accentColor => const Color(0xffE94560);
// static Color get accentColor => const Color(0xffE2282A);

}

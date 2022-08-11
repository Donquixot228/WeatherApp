import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Light Mode
  static const Color cl_background = Color(0xffefeeee);
  static const Color cl_darkShadow = Color(0xffd1cdc7);
  static const Color cl_lightShadow = Color(0xffffffff);
  static const Color tl_primary = Color(0xff323232);

  // Dark Mode
  static const Color cd_background = const Color(0xff292d32);
  static const Color cd_darkShadow = const Color(0xff23262b);
  static const Color cd_lightShadow = const Color(0xff2f343a);
  static const Color td_primary = const Color(0xffffffff);

  // Another Colors

  static const Color white = Color(0xFFFFFFFF);
  static const Color redButton = Color(0xFFBC222B);
  static const Color redButton52 = Color(0x52BC222B);
  static const Color darkTextColor = Color(0xFF333333);
  static const Color darkTextColor8F = Color(0x8F333333);
  static const Color colorPaleRose = Color(0xFFF0CDCF);
  static const Color colorPalePink = Color(0xFFF4DBDD);



}
BoxShadow setBoxShadowDark(bool darkMode) {
  return BoxShadow(
    color: darkMode != true ? AppColors.cl_darkShadow.withOpacity(0.65) : AppColors.cd_darkShadow,
    offset: Offset(6.0, 6.0),
    blurRadius: 15.0,
    spreadRadius: 1.0,
  );
}

BoxShadow setBoxShadowLight(bool darkMode) {
  return BoxShadow(
    color:
    darkMode != true ? AppColors.cl_lightShadow.withOpacity(0.8) : AppColors.cd_lightShadow,
    offset: Offset(-6.0, -6.0),
    blurRadius: 15.0,
    spreadRadius: 1.0,
  );
}
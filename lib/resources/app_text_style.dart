import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/resources/app_colors.dart';
import 'package:weather/resources/app_fonts.dart';


abstract class AppTextStyle {
  static const snackText = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    fontFamily: AppFonts.carina,
    color: AppColors.darkTextColor,
    letterSpacing: 0.4,
  );

  static const bookText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    fontFamily: AppFonts.ttNormsRegular,
    letterSpacing: 0.2,
  );
  static const bookTextBold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    fontFamily: AppFonts.ttNormsBold,
    color: AppColors.darkTextColor,
    letterSpacing: 0.2,
  );

  static const bookTextSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
    fontFamily: AppFonts.ttNormsMedium,
    letterSpacing: 0.24,
  );
  static const bookTextMediumNormal = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 15,
    color: AppColors.white,
    fontStyle: FontStyle.normal,
    fontFamily: AppFonts.ttNormsMedium,
    letterSpacing: 0.24,
  );
}

import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    // scaffoldBackgroundColor: AppColors.white,
    //  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    //    backgroundColor: AppColors.white,
    //    selectedItemColor: AppColors.white,
    //    unselectedItemColor: AppColors.greyForTextBottonNavBarText,
    //  ),
  );
  static final dark = ThemeData(
    brightness: Brightness.dark,
    // scaffoldBackgroundColor: AppColors.,
    //  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    //    backgroundColor: AppColors.white,
    //    selectedItemColor: AppColors.white,
    //    unselectedItemColor: AppColors.greyForTextBottonNavBarText,
    //  ),
  );
}

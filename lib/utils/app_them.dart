import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "app_color.dart";

class AppTheme {
  ///convert app orange color in MaterialColor for app theme
  ///

  ///green primary color
  static const int _greenPrimaryValue = 0xFF001F42;

  static const MaterialColor primaryGreen =
      MaterialColor(_greenPrimaryValue, <int, Color>{
        50: Color(0xFF001F42),
        100: Color(0xFF001F42),
        200: Color(0xFF001F42),
        300: Color(0xFF001F42),
        400: Color(0xFF001F42),
        500: Color(_greenPrimaryValue),
        600: Color(0xFF001F42),
        700: Color(0xFF001F42),
        800: Color(0xFF001F42),
        900: Color(0xFF001F42),
      });

  ///define light theme
  static ThemeData lightTheme = ThemeData(
    fontFamily: "Inter",
    primarySwatch: primaryGreen,
    useMaterial3: false,
    primaryColor:  AppColor.whiteColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: AppColor.whiteColor,
    iconTheme: const IconThemeData(color: AppColor.blackColor),
    cupertinoOverrideTheme: CupertinoThemeData(primaryColor: AppColor.appColor),
    textSelectionTheme: TextSelectionThemeData(cursorColor: AppColor.appColor),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.whiteColor,
      centerTitle: true,
      elevation: 0.0,
      iconTheme: IconThemeData(color: AppColor.blackColor),
    ),

    sliderTheme: const SliderThemeData(
      showValueIndicator: ShowValueIndicator.onDrag,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: "Inter",
    primaryColor: AppColor.blackColor,
    useMaterial3: false,
    primarySwatch: primaryGreen,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.transparent,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.blackColor,
      centerTitle: true,
      elevation: 0.0,
      iconTheme: IconThemeData(color: AppColor.blackColor),
    ),
    iconTheme: const IconThemeData(color: AppColor.blackColor),
  );

  static const int _darkPrimary = 0xff474747;
  static const MaterialColor primaryDark =
      MaterialColor(_darkPrimary, <int, Color>{
        50: Color(0xff474747),
        100: Color(0xff474747),
        200: Color(0xff474747),
        300: Color(0xff474747),
        400: Color(0xff474747),
        500: Color(_darkPrimary),
        600: Color(0xff474747),
        700: Color(0xff474747),
        800: Color(0xff474747),
        900: Color(0xff474747),
      });
}

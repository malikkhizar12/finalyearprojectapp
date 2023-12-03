import 'package:flutter/material.dart';
class ThemeClass
{
   Color kPrimaryColor = Color(0xff231A21);
   Color kSecondaryColor = Color(0xffEF511C);
   Color kPrimaryLightColor = Color(0xffFEEEEC);
   Color kSecondaryLightColor = Color(0xffFDEEE8);
  static ThemeData lightTheme = ThemeData(
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    colorScheme:  const ColorScheme.light().copyWith(
      primary: _themeClass.kPrimaryLightColor,
      secondary: _themeClass.kSecondaryLightColor
    )
  );
  static ThemeData darkTheme = ThemeData(
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
      colorScheme:  const ColorScheme.dark().copyWith(
          primary: _themeClass.kPrimaryColor,
          secondary: _themeClass.kSecondaryColor
      )
  );

}
ThemeClass  _themeClass = ThemeClass();
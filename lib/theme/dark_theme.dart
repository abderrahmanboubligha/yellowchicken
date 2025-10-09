import 'package:flutter/material.dart';
import 'package:flutter_restaurant/theme/custom_theme_colors.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Rubik',
  primaryColor: const Color(0xFFa1143f),
  secondaryHeaderColor: const Color(0xff04B200),
  brightness: Brightness.dark,
  cardColor: const Color(0xFF252525),
  hintColor: const Color(0xFFbebebe),
  disabledColor: const Color(0xffa2a7ad),
  shadowColor: Colors.black.withValues(alpha: 0.4),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
  popupMenuTheme: const PopupMenuThemeData(
      color: Color(0xFF29292D), surfaceTintColor: Color(0xFF29292D)),
  dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white10),
  extensions: <ThemeExtension<CustomThemeColors>>[
    CustomThemeColors.dark(),
  ],
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFa1143f),
    secondary: Color(0xff04B200),
    error: Colors.redAccent,
  ),
  textTheme: const TextTheme(
    labelLarge: TextStyle(color: Color(0xFF252525)),
    displayLarge: TextStyle(
        fontWeight: FontWeight.w300, fontSize: Dimensions.fontSizeLarge),
    displayMedium: TextStyle(
        fontWeight: FontWeight.w400, fontSize: Dimensions.fontSizeLarge),
    displaySmall: TextStyle(
        fontWeight: FontWeight.w500, fontSize: Dimensions.fontSizeDefault),
    headlineMedium: TextStyle(
        fontWeight: FontWeight.w600, fontSize: Dimensions.fontSizeExtraLarge),
    headlineSmall: TextStyle(
        fontWeight: FontWeight.w700, fontSize: Dimensions.fontSizeLarge),
    titleLarge: TextStyle(
        fontWeight: FontWeight.w800, fontSize: Dimensions.fontSizeExtraLarge),
    bodySmall: TextStyle(
        fontWeight: FontWeight.w900, fontSize: Dimensions.fontSizeDefault),
    titleMedium: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: 14.0),
    bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFa1143f),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: false,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  ),
  tabBarTheme: const TabBarThemeData(indicatorColor: Color(0xFF1981E0)),
);

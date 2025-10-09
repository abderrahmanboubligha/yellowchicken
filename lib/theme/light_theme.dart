import 'package:flutter/material.dart';
import 'package:flutter_restaurant/theme/custom_theme_colors.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

ThemeData light = ThemeData(
  fontFamily: 'Rubik',
  primaryColor: const Color(0xFFa1143f),
  // primaryColor: const Color(0xFFFC6A57),
  //#a1143f
  secondaryHeaderColor: const Color(0xff04B200),
  brightness: Brightness.light,
  cardColor: Colors.white,
  hintColor: const Color(0xFF9F9F9F),
  disabledColor: const Color(0xFFBABFC4),
  shadowColor: Colors.grey[300],
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),

  popupMenuTheme: const PopupMenuThemeData(
      color: Colors.white, surfaceTintColor: Colors.white),
  dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white),

  extensions: <ThemeExtension<CustomThemeColors>>[
    CustomThemeColors.light(),
  ],

  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFFa1143f),
    onPrimary: const Color(0xFFa1143f),
    secondary: const Color(0xff04B200),
    onSecondary: const Color(0xFFEFE6FE),
    error: Colors.redAccent,
    onError: Colors.redAccent,
    surface: Colors.white,
    onSurface: const Color(0xFF002349),
    shadow: Colors.grey[300],
  ),

  textTheme: const TextTheme(
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

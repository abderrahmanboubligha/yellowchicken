import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_restaurant/theme/custom_theme_colors.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

// Helper function to get responsive font sizes based on platform
double _getResponsiveFontSize(double webSize) {
  if (kIsWeb) {
    return webSize; // Keep original size for web
  } else {
    return webSize +
        8.0; // Increase by 8px for mobile apps (Android/iOS) - increased from 6px for MAXIMUM readability
  }
}

// Helper function to create responsive text theme
TextTheme _createResponsiveTextTheme() {
  return TextTheme(
    labelLarge: const TextStyle(color: Color(0xFF252525)),
    displayLarge: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: _getResponsiveFontSize(
            Dimensions.fontSizeExtraLarge)), // increased from fontSizeLarge
    displayMedium: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: _getResponsiveFontSize(
            Dimensions.fontSizeExtraLarge)), // increased from fontSizeLarge
    displaySmall: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: _getResponsiveFontSize(
            Dimensions.fontSizeLarge)), // increased from fontSizeDefault
    headlineMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: _getResponsiveFontSize(
            Dimensions.fontSizeOverLarge)), // increased from fontSizeExtraLarge
    headlineSmall: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: _getResponsiveFontSize(
            Dimensions.fontSizeExtraLarge)), // increased from fontSizeLarge
    titleLarge: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: _getResponsiveFontSize(
            Dimensions.fontSizeOverLarge)), // increased from fontSizeExtraLarge
    bodySmall: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: _getResponsiveFontSize(
            Dimensions.fontSizeLarge)), // increased from fontSizeDefault
    titleMedium: TextStyle(
        fontSize: _getResponsiveFontSize(23.0),
        fontWeight: FontWeight.w500), // increased from 21.0 to 23.0
    bodyMedium: TextStyle(
        fontSize: _getResponsiveFontSize(20.0)), // increased from 18.0 to 20.0
    bodyLarge: TextStyle(
        fontSize: _getResponsiveFontSize(22.0),
        fontWeight: FontWeight.w600), // increased from 20.0 to 22.0
  );
}

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
  textTheme: _createResponsiveTextTheme(),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFFa1143f),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: false,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: _getResponsiveFontSize(26.0), // increased from 24.0 to 26.0
      fontWeight: FontWeight.w500,
    ),
  ),
  tabBarTheme: const TabBarThemeData(indicatorColor: Color(0xFF1981E0)),
);

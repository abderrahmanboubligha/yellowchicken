import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/responsive_dimensions.dart';

class ResponsiveTextStyles {
  // Display text styles
  static TextStyle displayLarge(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: ResponsiveDimensions.getFontSizeLarge(context),
    );
  }

  static TextStyle displayMedium(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: ResponsiveDimensions.getFontSizeLarge(context),
    );
  }

  static TextStyle displaySmall(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: ResponsiveDimensions.getFontSizeDefault(context),
    );
  }

  // Headline text styles
  static TextStyle headlineMedium(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: ResponsiveDimensions.getFontSizeExtraLarge(context),
    );
  }

  static TextStyle headlineSmall(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: ResponsiveDimensions.getFontSizeLarge(context),
    );
  }

  // Title text styles
  static TextStyle titleLarge(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: ResponsiveDimensions.getFontSizeExtraLarge(context),
    );
  }

  static TextStyle titleMedium(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveDimensions.getTitleMediumFontSize(context),
      fontWeight: FontWeight.w500,
    );
  }

  // Body text styles
  static TextStyle bodySmall(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: ResponsiveDimensions.getFontSizeDefault(context),
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveDimensions.getBodyMediumFontSize(context),
    );
  }

  static TextStyle bodyLarge(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveDimensions.getBodyLargeFontSize(context),
      fontWeight: FontWeight.w600,
    );
  }

  // App bar title style
  static TextStyle appBarTitle(BuildContext context) {
    return TextStyle(
      color: Colors.white,
      fontSize: ResponsiveDimensions.getAppBarTitleFontSize(context),
      fontWeight: FontWeight.w500,
    );
  }

  // Button text style
  static TextStyle buttonText(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveDimensions.getButtonFontSize(context),
      fontWeight: FontWeight.w600,
    );
  }

  // Utility methods for common text styles
  static TextStyle customStyle({
    required BuildContext context,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize ?? ResponsiveDimensions.getFontSizeDefault(context),
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
    );
  }
}

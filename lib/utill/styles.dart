import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/responsive_dimensions.dart';

const rubikRegular = TextStyle(
  fontFamily: 'Rubik',
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w400,
);

const rubikMedium = TextStyle(
  fontFamily: 'Rubik',
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w500,
);

const rubikSemiBold = TextStyle(
  fontFamily: 'Rubik',
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w600,
);

const rubikBold = TextStyle(
  fontFamily: 'Rubik',
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w700,
);

const poppinsRegular = TextStyle(
  fontFamily: 'Poppins',
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w400,
);

const robotoRegular = TextStyle(
  fontFamily: 'Roboto',
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w400,
);

// Responsive text styles for better mobile readability
class ResponsiveStyles {
  // Product-specific responsive styles
  static TextStyle productTitle(BuildContext context) {
    return rubikSemiBold.copyWith(
        fontSize: ResponsiveDimensions.getProductTitleFontSize());
  }

  static TextStyle productDescription(BuildContext context) {
    return rubikRegular.copyWith(
        fontSize: ResponsiveDimensions.getProductDescriptionFontSize());
  }

  static TextStyle productPrice(BuildContext context) {
    return rubikBold.copyWith(
        fontSize: ResponsiveDimensions.getPriceFontSize());
  }

  // General responsive styles
  static TextStyle responsiveRegular(BuildContext context) {
    return rubikRegular.copyWith(
        fontSize: ResponsiveDimensions.getFontSizeDefault(context));
  }

  static TextStyle responsiveMedium(BuildContext context) {
    return rubikMedium.copyWith(
        fontSize: ResponsiveDimensions.getFontSizeDefault(context));
  }

  static TextStyle responsiveSemiBold(BuildContext context) {
    return rubikSemiBold.copyWith(
        fontSize: ResponsiveDimensions.getFontSizeDefault(context));
  }

  static TextStyle responsiveBold(BuildContext context) {
    return rubikBold.copyWith(
        fontSize: ResponsiveDimensions.getFontSizeDefault(context));
  }

  // Size-specific responsive styles
  static TextStyle responsiveSmall(BuildContext context) {
    return rubikRegular.copyWith(
        fontSize: ResponsiveDimensions.getFontSizeSmall(context));
  }

  static TextStyle responsiveLarge(BuildContext context) {
    return rubikSemiBold.copyWith(
        fontSize: ResponsiveDimensions.getFontSizeLarge(context));
  }

  static TextStyle responsiveExtraLarge(BuildContext context) {
    return rubikBold.copyWith(
        fontSize: ResponsiveDimensions.getFontSizeExtraLarge(context));
  }
}

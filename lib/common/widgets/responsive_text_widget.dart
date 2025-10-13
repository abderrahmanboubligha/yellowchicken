import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/responsive_dimensions.dart';

/// A widget that provides responsive text with automatic font size adjustment
/// for mobile devices while maintaining web design integrity
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    double responsiveFontSize = fontSize ?? 16.0;

    // Apply responsive font size adjustment
    responsiveFontSize =
        ResponsiveDimensions.getResponsiveFontSize(responsiveFontSize);

    TextStyle finalStyle = style ?? const TextStyle();
    finalStyle = finalStyle.copyWith(
      fontSize: responsiveFontSize,
      fontWeight: fontWeight ?? finalStyle.fontWeight,
      color: color ?? finalStyle.color,
    );

    return Text(
      text,
      style: finalStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}

/// A utility class providing predefined responsive text styles
class ResponsiveTextStyles {
  // Heading styles
  static TextStyle heading1(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveDimensions.getFontSizeOverLarge(context),
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle heading2(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveDimensions.getFontSizeExtraLarge(context),
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle heading3(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveDimensions.getFontSizeLarge(context),
      fontWeight: FontWeight.w600,
    );
  }

  // Body text styles
  static TextStyle bodyText(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveDimensions.getFontSizeDefault(context),
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle bodyTextMedium(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveDimensions.getBodyMediumFontSize(context),
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle bodyTextSmall(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveDimensions.getFontSizeSmall(context),
      fontWeight: FontWeight.normal,
    );
  }

  // Button text style
  static TextStyle buttonText(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveDimensions.getButtonFontSize(context),
      fontWeight: FontWeight.w600,
    );
  }

  // Caption style
  static TextStyle caption(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveDimensions.getFontSizeExtraSmall(context),
      fontWeight: FontWeight.normal,
    );
  }

  // Subtitle style
  static TextStyle subtitle(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveDimensions.getTitleMediumFontSize(context),
      fontWeight: FontWeight.w500,
    );
  }
}

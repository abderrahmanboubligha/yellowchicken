import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ResponsiveDimensions {
  // Base font size increase for mobile devices - increased to 8.0 for MAXIMUM readability
  static const double mobileFontSizeIncrease = 8.0;

  static double getFontSizeExtraSmall(BuildContext context) {
    if (kIsWeb) {
      return 12.0;
    } else {
      // MUCH LARGER font size for mobile apps (Android/iOS)
      return 20.0; // increased from 18.0 to 20.0 (+8px from web)
    }
  }

  static double getFontSizeSmall(BuildContext context) {
    if (kIsWeb) {
      return 14.0;
    } else {
      // MUCH LARGER font size for mobile apps (Android/iOS)
      return 22.0; // increased from 20.0 to 22.0 (+8px from web)
    }
  }

  static double getFontSizeDefault(BuildContext context) {
    if (kIsWeb) {
      return 16.0;
    } else {
      // MUCH LARGER font size for mobile apps (Android/iOS)
      return 24.0; // increased from 22.0 to 24.0 (+8px from web)
    }
  }

  static double getFontSizeLarge(BuildContext context) {
    if (kIsWeb) {
      return 18.0;
    } else {
      // MUCH LARGER font size for mobile apps (Android/iOS)
      return 26.0; // increased from 24.0 to 26.0 (+8px from web)
    }
  }

  static double getFontSizeExtraLarge(BuildContext context) {
    if (kIsWeb) {
      return 20.0;
    } else {
      // MUCH LARGER font size for mobile apps (Android/iOS)
      return 28.0; // increased from 26.0 to 28.0 (+8px from web)
    }
  }

  static double getFontSizeOverLarge(BuildContext context) {
    if (kIsWeb) {
      return 26.0;
    } else {
      // MUCH LARGER font size for mobile apps (Android/iOS)
      return 34.0; // increased from 32.0 to 34.0 (+8px from web)
    }
  }

  // App bar title font size
  static double getAppBarTitleFontSize(BuildContext context) {
    if (kIsWeb) {
      return 20.0;
    } else {
      // MUCH LARGER font size for mobile apps (Android/iOS)
      return 28.0; // increased from 26.0 to 28.0
    }
  }

  // Button text font size
  static double getButtonFontSize(BuildContext context) {
    if (kIsWeb) {
      return 16.0;
    } else {
      // MUCH LARGER font size for mobile apps (Android/iOS)
      return 24.0; // increased from 22.0 to 24.0
    }
  }

  // Body text font sizes
  static double getBodySmallFontSize(BuildContext context) {
    if (kIsWeb) {
      return 14.0;
    } else {
      return 22.0; // increased from 20.0 to 22.0
    }
  }

  static double getBodyMediumFontSize(BuildContext context) {
    if (kIsWeb) {
      return 16.0;
    } else {
      return 24.0; // increased from 22.0 to 24.0
    }
  }

  static double getBodyLargeFontSize(BuildContext context) {
    if (kIsWeb) {
      return 18.0;
    } else {
      return 26.0; // increased from 24.0 to 26.0
    }
  }

  // Title font sizes
  static double getTitleMediumFontSize(BuildContext context) {
    if (kIsWeb) {
      return 17.0;
    } else {
      return 25.0; // increased from 23.0 to 25.0
    }
  }

  // Generic responsive font size method
  static double getResponsiveFontSize(double baseFontSize) {
    if (kIsWeb) {
      return baseFontSize;
    } else {
      return baseFontSize +
          mobileFontSizeIncrease; // Now +8px for MAXIMUM readability
    }
  }

  // Method to get minimum touch target size for mobile
  static double getMinTouchTargetSize() {
    if (kIsWeb) {
      return 40.0;
    } else {
      return 48.0; // Material Design recommended minimum
    }
  }

  // Icon sizes
  static double getIconSizeSmall() {
    if (kIsWeb) {
      return 16.0;
    } else {
      return 18.0;
    }
  }

  static double getIconSizeDefault() {
    if (kIsWeb) {
      return 24.0;
    } else {
      return 26.0;
    }
  }

  static double getIconSizeLarge() {
    if (kIsWeb) {
      return 32.0;
    } else {
      return 34.0;
    }
  }

  // Additional methods for specific screen elements

  // Product/Meal title font size (for home screen, meal detail screen)
  static double getProductTitleFontSize() {
    if (kIsWeb) {
      return 18.0;
    } else {
      return 26.0; // Much larger for mobile (+8px)
    }
  }

  // Product/Meal description font size
  static double getProductDescriptionFontSize() {
    if (kIsWeb) {
      return 14.0;
    } else {
      return 22.0; // Much larger for mobile (+8px)
    }
  }

  // Price text font size
  static double getPriceFontSize() {
    if (kIsWeb) {
      return 16.0;
    } else {
      return 24.0; // Much larger for mobile (+8px)
    }
  }

  // Category title font size
  static double getCategoryTitleFontSize() {
    if (kIsWeb) {
      return 20.0;
    } else {
      return 28.0; // Much larger for mobile (+8px)
    }
  }

  // Banner text font size
  static double getBannerTextFontSize() {
    if (kIsWeb) {
      return 22.0;
    } else {
      return 30.0; // Much larger for mobile (+8px)
    }
  }

  // Branch name font size
  static double getBranchNameFontSize() {
    if (kIsWeb) {
      return 18.0;
    } else {
      return 26.0; // Much larger for mobile (+8px)
    }
  }

  // Branch address font size
  static double getBranchAddressFontSize() {
    if (kIsWeb) {
      return 14.0;
    } else {
      return 22.0; // Much larger for mobile (+8px)
    }
  }

  // Card title font size (for various cards throughout the app)
  static double getCardTitleFontSize() {
    if (kIsWeb) {
      return 16.0;
    } else {
      return 24.0; // Much larger for mobile (+8px)
    }
  }

  // Card subtitle font size
  static double getCardSubtitleFontSize() {
    if (kIsWeb) {
      return 14.0;
    } else {
      return 22.0; // Much larger for mobile (+8px)
    }
  }
}

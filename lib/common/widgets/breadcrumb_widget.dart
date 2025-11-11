import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class BreadcrumbItem {
  final String title;
  final VoidCallback? onTap;

  BreadcrumbItem({required this.title, this.onTap});
}

class BreadcrumbWidget extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const BreadcrumbWidget({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeLarge,
        vertical: Dimensions.paddingSizeDefault,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: _buildBreadcrumbItems(context),
      ),
    );
  }

  List<Widget> _buildBreadcrumbItems(BuildContext context) {
    List<Widget> widgets = [];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == items.length - 1;

      // Add the breadcrumb item
      widgets.add(
        InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeExtraSmall,
              vertical: Dimensions.paddingSizeExtraSmall,
            ),
            child: Text(
              item.title,
              style: rubikMedium.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: isLast
                    ? Theme.of(context).textTheme.bodyLarge?.color
                    : Theme.of(context).primaryColor,
                fontWeight: isLast ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      );

      // Add separator bullet if not last item
      if (!isLast) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall,
            ),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }
}

// Helper function to create breadcrumb items for common screens
class BreadcrumbHelper {
  static List<BreadcrumbItem> getCartBreadcrumb() {
    return [
      BreadcrumbItem(
        title: 'Home',
        onTap: () => RouterHelper.getMainRoute(),
      ),
      BreadcrumbItem(
        title: 'Cart',
      ),
    ];
  }

  static List<BreadcrumbItem> getAboutProductBreadcrumb(String productName) {
    return [
      BreadcrumbItem(
        title: 'Home',
        onTap: () => RouterHelper.getMainRoute(),
      ),
      BreadcrumbItem(
        title: 'About Product',
      ),
    ];
  }

  static List<BreadcrumbItem> getCategoryBreadcrumb(String categoryName) {
    return [
      BreadcrumbItem(
        title: 'Home',
        onTap: () => RouterHelper.getMainRoute(),
      ),
      BreadcrumbItem(
        title: categoryName,
      ),
    ];
  }

  static List<BreadcrumbItem> getOrdersBreadcrumb() {
    return [
      BreadcrumbItem(
        title: 'Home',
        onTap: () => RouterHelper.getMainRoute(),
      ),
      BreadcrumbItem(
        title: 'Orders',
      ),
    ];
  }

  static List<BreadcrumbItem> getProfileBreadcrumb() {
    return [
      BreadcrumbItem(
        title: 'Home',
        onTap: () => RouterHelper.getMainRoute(),
      ),
      BreadcrumbItem(
        title: 'Profile',
      ),
    ];
  }

  static List<BreadcrumbItem> getCheckoutBreadcrumb() {
    return [
      BreadcrumbItem(
        title: 'Home',
        onTap: () => RouterHelper.getMainRoute(),
      ),
      BreadcrumbItem(
        title: 'Cart',
        onTap: () => RouterHelper.getDashboardRoute('cart'),
      ),
      BreadcrumbItem(
        title: 'Checkout',
      ),
    ];
  }

  static List<BreadcrumbItem> getAddressBreadcrumb() {
    return [
      BreadcrumbItem(
        title: 'Home',
        onTap: () => RouterHelper.getMainRoute(),
      ),
      BreadcrumbItem(
        title: 'Profile',
        onTap: () => RouterHelper.getProfileRoute(),
      ),
      BreadcrumbItem(
        title: 'Address',
      ),
    ];
  }

  static List<BreadcrumbItem> getWishlistBreadcrumb() {
    return [
      BreadcrumbItem(
        title: 'Home',
        onTap: () => RouterHelper.getMainRoute(),
      ),
      BreadcrumbItem(
        title: 'Favourite',
      ),
    ];
  }

  static List<BreadcrumbItem> getNotificationBreadcrumb() {
    return [
      BreadcrumbItem(
        title: 'Home',
        onTap: () => RouterHelper.getMainRoute(),
      ),
      BreadcrumbItem(
        title: 'Notification',
      ),
    ];
  }

  static List<BreadcrumbItem> getSetMenuBreadcrumb() {
    return [
      BreadcrumbItem(
        title: 'Home',
        onTap: () => RouterHelper.getMainRoute(),
      ),
      BreadcrumbItem(
        title: 'Set Menu',
      ),
    ];
  }

  static List<BreadcrumbItem> getSearchBreadcrumb() {
    return [
      BreadcrumbItem(
        title: 'Home',
        onTap: () => RouterHelper.getMainRoute(),
      ),
      BreadcrumbItem(
        title: 'Search',
      ),
    ];
  }

  static List<BreadcrumbItem> getCouponBreadcrumb() {
    return [
      BreadcrumbItem(
        title: 'Home',
        onTap: () => RouterHelper.getMainRoute(),
      ),
      BreadcrumbItem(
        title: 'Coupons',
      ),
    ];
  }

  static List<BreadcrumbItem> getSupportBreadcrumb() {
    return [
      BreadcrumbItem(
        title: 'Home',
        onTap: () => RouterHelper.getMainRoute(),
      ),
      BreadcrumbItem(
        title: 'Support',
      ),
    ];
  }
}

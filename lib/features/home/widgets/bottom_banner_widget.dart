import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/features/category/domain/category_model.dart';
import 'package:flutter_restaurant/features/home/providers/banner_provider.dart';
import 'package:flutter_restaurant/features/home/widgets/cart_bottom_sheet_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BottomBannerWidget extends StatelessWidget {
  const BottomBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final isMobile = ResponsiveHelper.isMobile();

    return Consumer<BannerProvider>(
      builder: (context, bannerProvider, child) {
        if (bannerProvider.bannerList == null) {
          return const _BottomBannerShimmer();
        }

        if (bannerProvider.bannerList?.isEmpty ?? true) {
          return const SizedBox();
        }

        // Get only first 4 banners
        final bannersToShow = bannerProvider.bannerList!.take(4).toList();

        return Container(
          width: double.infinity,
          color: Theme.of(context).cardColor,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 0 : Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSizeLarge,
          ),
          child: Center(
            child: SizedBox(
              width: isDesktop ? Dimensions.webScreenWidth : double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 0 : Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSmall,
                    ),
                    child: Text(
                      getTranslated('featured_offers', context)!,
                      style: rubikBold.copyWith(
                        fontSize: isDesktop
                            ? Dimensions.fontSizeOverLarge
                            : Dimensions.fontSizeLarge,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  // Banner Grid
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 0 : Dimensions.paddingSizeDefault,
                    ),
                    child: _buildBannerGrid(
                      context,
                      bannersToShow,
                      splashProvider,
                      isDesktop,
                      isMobile,
                      bannerProvider,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBannerGrid(
    BuildContext context,
    List banners,
    SplashProvider splashProvider,
    bool isDesktop,
    bool isMobile,
    BannerProvider bannerProvider,
  ) {
    if (isDesktop) {
      // Desktop: 2x2 Grid with proper aspect ratio for 3780x1890 banners (2:1 ratio)
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio:
              2.0, // Changed to 2.0 to match 3780x1890 banner ratio (2:1)
          crossAxisSpacing: Dimensions.paddingSizeDefault,
          mainAxisSpacing: Dimensions.paddingSizeDefault,
        ),
        itemCount: banners.length > 4 ? 4 : banners.length,
        itemBuilder: (context, index) {
          return _buildBannerCard(
            context,
            banners[index],
            splashProvider,
            isDesktop,
          );
        },
      );
    } else {
      // Mobile: 1x1 Stacked with consistent height and See More button
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner list
          ...banners.take(4).map<Widget>((banner) {
            return Container(
              margin:
                  const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              height: 180, // Fixed height for consistent mobile banner size
              child: _buildBannerCard(
                context,
                banner,
                splashProvider,
                isDesktop,
              ),
            );
          }),

          // See More button - only show if there are more than 4 banners
          if (bannerProvider.bannerList!.length > 4) ...[
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
              ),
              child: OutlinedButton(
                onPressed: () {
                  // Navigate to search result screen to show more dishes
                  RouterHelper.getSearchResultRoute('');
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeDefault),
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                ),
                child: Text(
                  'Discover more dishes ...',
                  style: rubikMedium.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
              ),
            ),
          ],
        ],
      );
    }
  }

  Widget _buildBannerCard(
    BuildContext context,
    dynamic banner,
    SplashProvider splashProvider,
    bool isDesktop,
  ) {
    final bannerProvider = Provider.of<BannerProvider>(context, listen: false);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(16.0), // Larger border radius like the image
        color: isDesktop
            ? Theme.of(context).cardColor
            : Colors.transparent, // Add background color for desktop
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(16.0), // Match the container border radius
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (banner.productId != null) {
                Product? product;
                for (Product prod in bannerProvider.productList) {
                  if (prod.id == banner.productId) {
                    product = prod;
                    break;
                  }
                }
                if (product != null &&
                    (product.branchProduct?.isAvailable ?? false)) {
                  // Show bottom sheet for product selection
                  ResponsiveHelper.showDialogOrBottomSheet(
                    context,
                    CartBottomSheetWidget(
                      product: product,
                      fromSetMenu: true,
                      callback: (cartModel) {
                        showCustomSnackBarHelper(
                          getTranslated('added_to_cart', context),
                          isError: false,
                        );
                      },
                    ),
                  );
                } else {
                  showCustomSnackBarHelper(
                    getTranslated('not_available_in_current_branch', context),
                  );
                }
              } else if (banner.categoryId != null) {
                // Navigate to category
                CategoryModel category = CategoryModel(
                  id: int.parse(banner.categoryId.toString()),
                  name: '',
                  image: '',
                );
                RouterHelper.getCategoryRoute(category);
              }
            },
            child: CustomImageWidget(
              image:
                  '${splashProvider.baseUrls!.bannerImageUrl}/${banner.image}',
              width: double.infinity,
              height: double.infinity,
              fit: isDesktop
                  ? BoxFit.contain
                  : BoxFit
                      .cover, // Use contain for desktop to prevent stretching
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomBannerShimmer extends StatelessWidget {
  const _BottomBannerShimmer();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Container(
      width: double.infinity,
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 0 : Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeLarge,
      ),
      child: Center(
        child: SizedBox(
          width: isDesktop ? Dimensions.webScreenWidth : double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title shimmer
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 0 : Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeSmall,
                ),
                child: Shimmer(
                  duration: const Duration(seconds: 2),
                  child: Container(
                    height: 20,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeDefault),

              // Banner grid shimmer
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 0 : Dimensions.paddingSizeDefault,
                ),
                child: isDesktop
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio:
                              2.0, // Updated to match banner ratio (2:1)
                          crossAxisSpacing: Dimensions.paddingSizeDefault,
                          mainAxisSpacing: Dimensions.paddingSizeDefault,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Shimmer(
                            duration: const Duration(seconds: 2),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).shadowColor,
                                borderRadius: BorderRadius.circular(
                                    16.0), // Updated border radius
                              ),
                            ),
                          );
                        },
                      )
                    : Column(
                        children: List.generate(
                          4,
                          (index) => Container(
                            margin: const EdgeInsets.only(
                                bottom: Dimensions.paddingSizeDefault),
                            height: 180, // Updated to match new mobile height
                            child: Shimmer(
                              duration: const Duration(seconds: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).shadowColor,
                                  borderRadius: BorderRadius.circular(
                                      16.0), // Updated border radius
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

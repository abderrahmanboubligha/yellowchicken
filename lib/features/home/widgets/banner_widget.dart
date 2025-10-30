import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/cart_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/features/category/domain/category_model.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/home/providers/banner_provider.dart';
import 'package:flutter_restaurant/features/home/widgets/cart_bottom_sheet_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final CarouselSliderController _mainBannerController =
      CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Column(children: [
      Consumer<BannerProvider>(
        builder: (context, bannerProvider, child) {
          return bannerProvider.bannerList == null
              ? const _BannerShimmer()
              : (bannerProvider.bannerList?.isNotEmpty ?? false) &&
                      bannerProvider.bannerList!.length > 4
                  ? Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title - Modern styling
                            if (!ResponsiveHelper.isDesktop(context))
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeLarge,
                                    vertical: Dimensions.paddingSizeSmall),
                                child: Text(
                                    getTranslated('today_specials', context)!,
                                    style: rubikBold.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                      fontSize: Dimensions.fontSizeDefault,
                                    )),
                              ),

                            // Full Width Banner Carousel - Modern Hero Style
                            Container(
                              height: ResponsiveHelper.isDesktop(context)
                                  ? 500
                                  : 170,
                              width: double.infinity,
                              padding: ResponsiveHelper.isDesktop(context)
                                  ? EdgeInsets.zero
                                  : const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeLarge),
                              child: Stack(
                                children: [
                                  // Main banner slider
                                  CarouselSlider.builder(
                                    disableGesture: false,
                                    itemCount:
                                        bannerProvider.bannerList!.length > 4
                                            ? (bannerProvider.bannerList!
                                                            .length -
                                                        4 <=
                                                    10
                                                ? bannerProvider
                                                        .bannerList!.length -
                                                    4
                                                : 10)
                                            : 0,
                                    carouselController: _mainBannerController,
                                    options: CarouselOptions(
                                      height:
                                          ResponsiveHelper.isDesktop(context)
                                              ? 480
                                              : 150,
                                      viewportFraction: 1.0,
                                      initialPage: _currentIndex,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: true,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      onPageChanged: (index, _) {
                                        _currentIndex = index;
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                      scrollDirection: Axis.horizontal,
                                    ),
                                    itemBuilder: (context, index, realIndex) {
                                      // Skip the first 4 banners - start from index 4
                                      final bannerIndex = index + 4;
                                      return Container(
                                        width: double.infinity,
                                        margin:
                                            ResponsiveHelper.isDesktop(context)
                                                ? EdgeInsets.zero
                                                : const EdgeInsets.symmetric(
                                                    horizontal: 5),
                                        child: Material(
                                          borderRadius:
                                              ResponsiveHelper.isDesktop(
                                                      context)
                                                  ? BorderRadius.zero
                                                  : BorderRadius.circular(
                                                      Dimensions.radiusDefault),
                                          clipBehavior: Clip.hardEdge,
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              if (bannerProvider
                                                      .bannerList![bannerIndex]
                                                      .productId !=
                                                  null) {
                                                Product? product;
                                                for (Product prod
                                                    in bannerProvider
                                                        .productList) {
                                                  if (prod.id ==
                                                      bannerProvider
                                                          .bannerList![
                                                              bannerIndex]
                                                          .productId) {
                                                    product = prod;
                                                    break;
                                                  }
                                                }
                                                if (product != null &&
                                                    (product.branchProduct
                                                            ?.isAvailable ??
                                                        false)) {
                                                  ResponsiveHelper
                                                      .showDialogOrBottomSheet(
                                                          context,
                                                          CartBottomSheetWidget(
                                                            product: product,
                                                            fromSetMenu: true,
                                                            callback: (CartModel
                                                                cartModel) {
                                                              showCustomSnackBarHelper(
                                                                  getTranslated(
                                                                      'added_to_cart',
                                                                      context),
                                                                  isError:
                                                                      false);
                                                            },
                                                          ));
                                                }
                                              } else if (bannerProvider
                                                      .bannerList![bannerIndex]
                                                      .categoryId !=
                                                  null) {
                                                CategoryModel? category;
                                                for (CategoryModel categoryModel
                                                    in Provider.of<
                                                                CategoryProvider>(
                                                            context,
                                                            listen: false)
                                                        .categoryList!) {
                                                  if (categoryModel.id ==
                                                      bannerProvider
                                                          .bannerList![
                                                              bannerIndex]
                                                          .categoryId) {
                                                    category = categoryModel;
                                                    break;
                                                  }
                                                }
                                                if (category != null &&
                                                    category.status == 1) {
                                                  RouterHelper.getCategoryRoute(
                                                      category);
                                                }
                                              }
                                            },
                                            borderRadius: ResponsiveHelper
                                                    .isDesktop(context)
                                                ? BorderRadius.zero
                                                : BorderRadius.circular(
                                                    Dimensions.radiusDefault),
                                            child: ClipRRect(
                                              borderRadius: ResponsiveHelper
                                                      .isDesktop(context)
                                                  ? BorderRadius.zero
                                                  : BorderRadius.circular(
                                                      Dimensions.radiusDefault),
                                              child: CustomImageWidget(
                                                placeholder:
                                                    Images.placeholderBanner,
                                                width: double.infinity,
                                                height:
                                                    ResponsiveHelper.isDesktop(
                                                            context)
                                                        ? 480
                                                        : 150,
                                                fit: BoxFit.cover,
                                                image:
                                                    '${splashProvider.baseUrls!.bannerImageUrl}/${bannerProvider.bannerList![bannerIndex].image}',
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Animated Indicator Dots - Modern positioning
                            if (ResponsiveHelper.isDesktop(context))
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge)
                            else
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),
                            Center(
                              child: SizedBox(
                                height: 8,
                                child: ListView.builder(
                                  itemCount: bannerProvider.bannerList!.length >
                                          4
                                      ? (bannerProvider.bannerList!.length -
                                                  4 <=
                                              10
                                          ? bannerProvider.bannerList!.length -
                                              4
                                          : 10)
                                      : 0,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      width: _currentIndex == index
                                          ? Dimensions.paddingSizeLarge
                                          : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusLarge),
                                        color: ResponsiveHelper.isDesktop(
                                                context)
                                            ? (_currentIndex == index
                                                ? Colors.white
                                                : Colors.white
                                                    .withValues(alpha: 0.4))
                                            : (_currentIndex == index
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                    .primaryColor
                                                    .withValues(alpha: 0.3)),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeExtraSmall),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                          ]),
                    )
                  : const SizedBox();
        },
      ),
    ]);
  }
}

class _BannerShimmer extends StatelessWidget {
  const _BannerShimmer();

  @override
  Widget build(BuildContext context) {
    final bannerProvider = Provider.of<BannerProvider>(context, listen: false);

    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: bannerProvider.bannerList == null,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault,
              vertical: Dimensions.paddingSizeSmall),
          child: Container(
            height: Dimensions.paddingSizeLarge,
            width: 150,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
          ),
        ),
        SizedBox(
          height: ResponsiveHelper.isDesktop(context) ? 370 : 190,
          child: Column(children: [
            // Banner shimmer
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeDefault),

            // Indicator dots shimmer
            Container(
              height: 8,
              width: 100,
              margin:
                  const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

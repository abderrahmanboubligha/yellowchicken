import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class OurDiscoveriesWidget extends StatelessWidget {
  const OurDiscoveriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final isTablet = ResponsiveHelper.isTab(context);

    // Bigger card dimensions
    final double cardWidth = isDesktop
        ? 160
        : isTablet
            ? 140
            : 120;
    final double cardHeight = isDesktop
        ? 180
        : isTablet
            ? 160
            : 140;
    final double imageSize = isDesktop
        ? 100
        : isTablet
            ? 90
            : 70;

    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        final splashProvider =
            Provider.of<SplashProvider>(context, listen: false);

        return categoryProvider.categoryList == null
            ? _buildShimmer(
                cardWidth, cardHeight, imageSize, isDesktop, isTablet, context)
            : categoryProvider.categoryList!.isEmpty
                ? const SizedBox()
                : Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeLarge,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: Dimensions.webScreenWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section title
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeLarge,
                              ),
                              child: Text(
                                'Our Discoveries',
                                style: rubikBold.copyWith(
                                  fontSize: 22,
                                  color: const Color(0xFF4B1E00),
                                ),
                              ),
                            ),
                            SizedBox(
                                height: isDesktop
                                    ? Dimensions.paddingSizeLarge
                                    : Dimensions.paddingSizeDefault),

                            // Horizontal scrollable list
                            SizedBox(
                              height: cardHeight + 20,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeLarge,
                                ),
                                itemCount:
                                    categoryProvider.categoryList!.length > 8
                                        ? 8
                                        : categoryProvider.categoryList!.length,
                                itemBuilder: (context, index) {
                                  final category =
                                      categoryProvider.categoryList![index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right: index <
                                              (categoryProvider.categoryList!
                                                          .length >
                                                      8
                                                  ? 7
                                                  : categoryProvider
                                                          .categoryList!
                                                          .length -
                                                      1)
                                          ? Dimensions.paddingSizeDefault
                                          : 0,
                                    ),
                                    child: _DiscoveryItem(
                                      category: category,
                                      splashProvider: splashProvider,
                                      cardWidth: cardWidth,
                                      cardHeight: cardHeight,
                                      imageSize: imageSize,
                                      isDesktop: isDesktop,
                                      isMoreButton: index == 7 &&
                                          categoryProvider
                                                  .categoryList!.length >
                                              8,
                                    ),
                                  );
                                },
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

  Widget _buildShimmer(double cardWidth, double cardHeight, double imageSize,
      bool isDesktop, bool isTablet, BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeLarge,
      ),
      child: Center(
        child: SizedBox(
          width: Dimensions.webScreenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title shimmer
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeLarge,
                ),
                child: Shimmer(
                  duration: const Duration(seconds: 2),
                  enabled: true,
                  child: Container(
                    height: 22,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: isDesktop
                    ? Dimensions.paddingSizeLarge
                    : Dimensions.paddingSizeDefault,
              ),

              // Cards shimmer
              SizedBox(
                height: cardHeight + 20,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge,
                  ),
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return Container(
                      width: cardWidth,
                      margin: const EdgeInsets.only(
                        right: Dimensions.paddingSizeDefault,
                      ),
                      child: Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: true,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeDefault),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: imageSize,
                                  width: imageSize,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                Container(
                                  height: 12,
                                  width: cardWidth * 0.7,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiscoveryItem extends StatefulWidget {
  final dynamic category;
  final SplashProvider splashProvider;
  final double cardWidth;
  final double cardHeight;
  final double imageSize;
  final bool isDesktop;
  final bool isMoreButton;

  const _DiscoveryItem({
    required this.category,
    required this.splashProvider,
    required this.cardWidth,
    required this.cardHeight,
    required this.imageSize,
    required this.isDesktop,
    this.isMoreButton = false,
  });

  @override
  State<_DiscoveryItem> createState() => _DiscoveryItemState();
}

class _DiscoveryItemState extends State<_DiscoveryItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          if (widget.isMoreButton) {
            RouterHelper.getAllCategoryRoute();
          } else {
            RouterHelper.getCategoryRoute(widget.category);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.cardWidth,
          height: widget.cardHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? const Color(0xFFFF8C42) : Colors.transparent,
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF8C42).withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: widget.isMoreButton
                ? Container(
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFFF8C42).withValues(alpha: 0.1),
                    ),
                    child: Icon(
                      Icons.more_horiz,
                      size: widget.isDesktop ? 36 : 32,
                      color: const Color(0xFFFF8C42),
                    ),
                  )
                : CustomImageWidget(
                    fit: BoxFit.cover,
                    placeholder: Images.placeholderImage,
                    image: widget.splashProvider.baseUrls != null
                        ? '${widget.splashProvider.baseUrls!.categoryImageUrl}/${widget.category.image}'
                        : '',
                  ),
          ),
        ),
      ),
    );
  }
}

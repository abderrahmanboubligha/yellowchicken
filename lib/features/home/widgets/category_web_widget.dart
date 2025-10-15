import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/home/widgets/category_page_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryWebWidget extends StatefulWidget {
  const CategoryWebWidget({super.key});

  @override
  State<CategoryWebWidget> createState() => _CategoryWebWidgetState();
}

class _CategoryWebWidgetState extends State<CategoryWebWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, category, _) {
      return category.categoryList == null
          ? const _CategoryShimmer()
          : category.categoryList!.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(
                    color: ColorResources.getTertiaryColor(context),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeDefault,
                  ),
                  child: CategoryPageWidget(
                    categoryProvider: category,
                  ),
                )
              : const SizedBox();
    });
  }
}

class _CategoryShimmer extends StatelessWidget {
  const _CategoryShimmer();

  @override
  Widget build(BuildContext context) {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final isTablet = ResponsiveHelper.isTab(context);

    final double cardWidth = isDesktop
        ? 140
        : isTablet
            ? 120
            : 100;
    final double cardHeight = isDesktop
        ? 160
        : isTablet
            ? 140
            : 120;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimensions.paddingSizeDefault),

        // Title shimmer
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: categoryProvider.categoryList == null,
            child: Container(
              height: isDesktop
                  ? 28
                  : isTablet
                      ? 24
                      : 20,
              width: 180,
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
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

        // Horizontal list shimmer
        SizedBox(
          height: cardHeight + 20,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault,
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
                  enabled: categoryProvider.categoryList == null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image shimmer
                          Container(
                            height: isDesktop
                                ? 80
                                : isTablet
                                    ? 70
                                    : 60,
                            width: isDesktop
                                ? 80
                                : isTablet
                                    ? 70
                                    : 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Theme.of(context)
                                  .shadowColor
                                  .withValues(alpha: 0.3),
                            ),
                          ),

                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          // Text shimmer
                          Container(
                            height: 12,
                            width: cardWidth * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Theme.of(context)
                                  .shadowColor
                                  .withValues(alpha: 0.3),
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

        const SizedBox(height: Dimensions.paddingSizeDefault),
      ],
    );
  }
}

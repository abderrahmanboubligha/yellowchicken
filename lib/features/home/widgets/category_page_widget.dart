import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class CategoryPageWidget extends StatefulWidget {
  final CategoryProvider categoryProvider;

  const CategoryPageWidget({super.key, required this.categoryProvider});

  @override
  State<CategoryPageWidget> createState() => _CategoryPageWidgetState();
}

class _CategoryPageWidgetState extends State<CategoryPageWidget> {
  int categoryLength = 0;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final isTablet = ResponsiveHelper.isTab(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    categoryLength = widget.categoryProvider.categoryList!.length;

    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);

    // Calculate card dimensions based on screen size
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
    final double imageSize = isDesktop
        ? 80
        : isTablet
            ? 70
            : 60;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Dimensions.paddingSizeDefault),

        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
          ),
          child: Text(
            getTranslated('dish_discoveries', context)!,
            style: rubikBold.copyWith(
              fontSize: isDesktop
                  ? Dimensions.fontSizeOverLarge
                  : isTablet
                      ? Dimensions.fontSizeExtraLarge
                      : Dimensions.fontSizeLarge,
              color: themeProvider.darkTheme
                  ? Theme.of(context).primaryColor
                  : ColorResources.homePageSectionTitleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        SizedBox(
          height: isDesktop
              ? Dimensions.paddingSizeLarge
              : Dimensions.paddingSizeDefault,
        ),

        // Horizontal Scrollable List
        SizedBox(
          height: cardHeight + 20, // Extra space to prevent overflow
          child: Directionality(
            textDirection: Localizations.localeOf(context).languageCode == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
              ),
              itemCount: categoryLength > 8 ? 8 : categoryLength,
              itemBuilder: (context, index) {
                String? name =
                    widget.categoryProvider.categoryList![index].name;
                return Container(
                  width: cardWidth,
                  margin: EdgeInsets.only(
                    right: Localizations.localeOf(context).languageCode == 'ar'
                        ? 0
                        : Dimensions.paddingSizeDefault,
                    left: Localizations.localeOf(context).languageCode == 'ar'
                        ? Dimensions.paddingSizeDefault
                        : 0,
                  ),
                  child: _categoryCard(
                    index: index,
                    isDesktop: isDesktop,
                    cardWidth: cardWidth,
                    cardHeight: cardHeight,
                    imageSize: imageSize,
                    context: context,
                    splashProvider: splashProvider,
                    name: name,
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: Dimensions.paddingSizeDefault),
      ],
    );
  }

  Widget _categoryCard({
    required int index,
    required bool isDesktop,
    required double cardWidth,
    required double cardHeight,
    required double imageSize,
    required BuildContext context,
    required SplashProvider splashProvider,
    String? name,
  }) {
    return InkWell(
      onTap: () {
        if (index == 7) {
          RouterHelper.getAllCategoryRoute();
        } else {
          RouterHelper.getCategoryRoute(
              widget.categoryProvider.categoryList![index]);
        }
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        height: cardHeight,
        width: cardWidth,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: index == 7
              ? Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .primaryColor
                        .withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Icons.more_horiz,
                    size: isDesktop ? 32 : 28,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : CustomImageWidget(
                  fit: BoxFit.cover,
                  placeholder: Images.placeholderImage,
                  image: splashProvider.baseUrls != null
                      ? '${splashProvider.baseUrls!.categoryImageUrl}/${widget.categoryProvider.categoryList![index].image}'
                      : '',
                ),
        ),
      ),
    );
  }
}

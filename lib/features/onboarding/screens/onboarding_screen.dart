import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_restaurant/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<OnBoardingProvider>(context, listen: false)
        .initBoardingList(context);

    final size = MediaQuery.sizeOf(context);
    final isRtl =
        !Provider.of<LocalizationProvider>(context, listen: false).isLtr;

    return Consumer<OnBoardingProvider>(
      builder: (context, onBoardingProvider, child) => CustomPopScopeWidget(
        child: Scaffold(
          body: onBoardingProvider.onBoardingList.isNotEmpty
              ? SafeArea(
                  child: Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          ColorResources.onBoardingBgColor,
                          Theme.of(context).cardColor
                        ],
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Center(
                          child: SizedBox(
                              width: Dimensions.webScreenWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  onBoardingProvider.selectedIndex <
                                          onBoardingProvider
                                                  .onBoardingList.length -
                                              1
                                      ? Align(
                                          alignment: isRtl
                                              ? Alignment.topLeft
                                              : Alignment.topRight,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              top:
                                                  Dimensions.paddingSizeDefault,
                                              right: isRtl
                                                  ? 0
                                                  : Dimensions
                                                      .paddingSizeDefault,
                                              left: isRtl
                                                  ? Dimensions
                                                      .paddingSizeDefault
                                                  : 0,
                                            ),
                                            child: InkWell(
                                              onTap: () =>
                                                  RouterHelper.getLoginRoute(
                                                      action: RouteAction
                                                          .pushNamedAndRemoveUntil),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    Dimensions
                                                        .paddingSizeDefault),
                                                child: Text(
                                                    getTranslated(
                                                        'skip', context)!,
                                                    style:
                                                        rubikRegular.copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor)),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(height: 48),

                                  // Responsive height based on screen size
                                  SizedBox(
                                      height: size.height *
                                          (size.height < 700 ? 0.1 : 0.15)),

                                  // Responsive height for content
                                  SizedBox(
                                    height: size.height *
                                        (size.height < 700 ? 0.6 : 0.55),
                                    child: PageView.builder(
                                      itemCount: onBoardingProvider
                                          .onBoardingList.length,
                                      controller: _pageController,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            // Responsive image sizing
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: size.width * 0.1,
                                                vertical:
                                                    size.height < 700 ? 15 : 30,
                                              ),
                                              child: CustomAssetImageWidget(
                                                onBoardingProvider
                                                    .onBoardingList[index]
                                                    .imageUrl,
                                                width: size.width * 0.6,
                                                height: size.height *
                                                    (size.height < 700
                                                        ? 0.2
                                                        : 0.22),
                                                fit: BoxFit.contain,
                                              ),
                                            ),

                                            // Responsive title with better font sizing
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: size.width * 0.08,
                                                vertical: size.height < 700
                                                    ? 8
                                                    : Dimensions
                                                        .paddingSizeDefault,
                                              ),
                                              child: Text(
                                                onBoardingProvider
                                                            .selectedIndex ==
                                                        0
                                                    ? onBoardingProvider
                                                        .onBoardingList[0].title
                                                    : onBoardingProvider
                                                                .selectedIndex ==
                                                            1
                                                        ? onBoardingProvider
                                                            .onBoardingList[1]
                                                            .title
                                                        : onBoardingProvider
                                                            .onBoardingList[2]
                                                            .title,
                                                style: rubikSemiBold.copyWith(
                                                  fontSize:
                                                      _getResponsiveTitleFontSize(
                                                          size, isRtl),
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color,
                                                  height: isRtl
                                                      ? 1.4
                                                      : 1.2, // Better line height for Arabic
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),

                                            // Responsive description with improved Arabic support
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: size.width * 0.06,
                                                ),
                                                child: Text(
                                                  onBoardingProvider
                                                              .selectedIndex ==
                                                          0
                                                      ? onBoardingProvider
                                                          .onBoardingList[0]
                                                          .description
                                                      : onBoardingProvider
                                                                  .selectedIndex ==
                                                              1
                                                          ? onBoardingProvider
                                                              .onBoardingList[1]
                                                              .description
                                                          : onBoardingProvider
                                                              .onBoardingList[2]
                                                              .description,
                                                  style: rubikRegular.copyWith(
                                                    fontSize:
                                                        _getResponsiveDescriptionFontSize(
                                                            size, isRtl),
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .color
                                                        ?.withValues(
                                                            alpha: 0.7),
                                                    height: isRtl
                                                        ? 1.6
                                                        : 1.4, // Better line height for Arabic
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines:
                                                      size.height < 700 ? 4 : 6,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                      onPageChanged: (index) {
                                        onBoardingProvider
                                            .changeSelectIndex(index);
                                      },
                                    ),
                                  ),

                                  // Responsive button positioning
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        if (onBoardingProvider.selectedIndex <
                                            onBoardingProvider
                                                    .onBoardingList.length -
                                                1) {
                                          _pageController.nextPage(
                                              duration:
                                                  const Duration(seconds: 1),
                                              curve: Curves.ease);
                                        } else {
                                          RouterHelper.getLoginRoute(
                                              action: RouteAction
                                                  .pushNamedAndRemoveUntil);
                                        }
                                      },
                                      child: Stack(children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).cardColor,
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withValues(alpha: 0.2),
                                                width: 2),
                                          ),
                                          padding: EdgeInsets.all(size.height <
                                                  700
                                              ? 12
                                              : Dimensions.paddingSizeLarge),
                                          margin: EdgeInsets.symmetric(
                                            vertical: size.height < 700
                                                ? 20
                                                : Dimensions
                                                    .paddingSizeExtraLarge,
                                          ),
                                          child: Icon(
                                            isRtl
                                                ? Icons.arrow_back_ios
                                                : Icons.arrow_forward_ios,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: size.height < 700 ? 20 : 24,
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              width:
                                                  size.height < 700 ? 80 : 100,
                                              height:
                                                  size.height < 700 ? 50 : 65,
                                              child: CircularProgressIndicator(
                                                value: (onBoardingProvider
                                                        .selectedIndex) /
                                                    (onBoardingProvider
                                                            .onBoardingList
                                                            .length -
                                                        1),
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                backgroundColor:
                                                    Colors.transparent,
                                                strokeCap: StrokeCap.round,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ],
                              ))),
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }

  // Helper function to get responsive title font size
  double _getResponsiveTitleFontSize(Size size, bool isRtl) {
    if (size.height < 700) {
      return isRtl ? 18 : 16; // Slightly larger for Arabic
    } else if (size.height < 900) {
      return isRtl ? 22 : 20;
    } else {
      return Dimensions.fontSizeExtraLarge;
    }
  }

  // Helper function to get responsive description font size
  double _getResponsiveDescriptionFontSize(Size size, bool isRtl) {
    if (size.height < 700) {
      return isRtl ? 14 : 12; // Slightly larger for Arabic
    } else if (size.height < 900) {
      return isRtl ? 16 : 14;
    } else {
      return Dimensions.fontSizeLarge;
    }
  }
}

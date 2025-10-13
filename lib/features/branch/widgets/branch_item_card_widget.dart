import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class BranchItemCardWidget extends StatelessWidget {
  final BranchValue? branchesValue;

  const BranchItemCardWidget({super.key, this.branchesValue});

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Consumer<BranchProvider>(builder: (context, branchProvider, _) {
      return GestureDetector(
        onTap: () {
          if (branchesValue!.branches!.status!) {
            branchProvider.updateBranchId(branchesValue!.branches!.id);
          } else {
            showCustomSnackBarHelper(
                '${branchesValue!.branches!.name} ${getTranslated('close_now', context)}');
          }
        },
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(
                      alpha: branchProvider.selectedBranchId ==
                              branchesValue!.branches!.id
                          ? 1
                          : 0),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                color: branchProvider.selectedBranchId ==
                        branchesValue!.branches!.id
                    ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                    : Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                      color:
                          Theme.of(context).hintColor.withValues(alpha: 0.25),
                      blurRadius: 36,
                      offset: const Offset(18, 18))
                ]),
            child: Column(children: [
              /// for Branch banner
              Expanded(
                  flex: ResponsiveHelper.isMobile() ? 65 : 60,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(Dimensions.radiusLarge),
                      topLeft: Radius.circular(Dimensions.radiusLarge),
                    ),
                    child: Stack(children: [
                      CustomImageWidget(
                        placeholder: Images.branchBanner,
                        image:
                            '${splashProvider.baseUrls!.branchImageUrl}/${branchesValue!.branches!.coverImage}',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      if (!branchesValue!.branches!.status!)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(Dimensions.radiusLarge),
                              topLeft: Radius.circular(Dimensions.radiusLarge),
                            ),
                          ),
                          child: Center(
                              child: Container(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusExtraLarge),
                            ),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Icon(Icons.schedule_outlined,
                                      color: Colors.white,
                                      size: Dimensions.paddingSizeLarge),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                    getTranslated('close_now', context)!,
                                    style: rubikRegular.copyWith(
                                      fontSize: ResponsiveHelper.isMobile()
                                          ? Dimensions.fontSizeSmall
                                          : ResponsiveHelper.isTab(context)
                                              ? Dimensions.fontSizeDefault
                                              : Dimensions.fontSizeLarge,
                                      color: Colors.white,
                                    ),
                                  ),
                                ]),
                          )),
                        ),
                    ]),
                  )),

              /// for Branch info
              Expanded(
                  flex: ResponsiveHelper.isMobile() ? 35 : 40,
                  child: Padding(
                    padding: EdgeInsets.all(ResponsiveHelper.isMobile()
                        ? Dimensions.paddingSizeExtraSmall
                        : Dimensions.paddingSizeSmall),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: ResponsiveHelper.isMobile()
                                  ? 70
                                  : ResponsiveHelper.isTab(context)
                                      ? 80
                                      : 90),
                          Expanded(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxHeight:
                                                ResponsiveHelper.isMobile()
                                                    ? 55
                                                    : 60,
                                          ),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  branchesValue!
                                                      .branches!.name!,
                                                  style: rubikSemiBold.copyWith(
                                                    fontSize: ResponsiveHelper
                                                            .isMobile()
                                                        ? Dimensions
                                                            .fontSizeExtraSmall
                                                        : ResponsiveHelper
                                                                .isTab(context)
                                                            ? Dimensions
                                                                .fontSizeSmall
                                                            : Dimensions
                                                                .fontSizeLarge,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.color,
                                                    fontWeight: FontWeight.w600,
                                                    shadows: [
                                                      Shadow(
                                                        offset: const Offset(
                                                            0.5, 0.5),
                                                        blurRadius: 1,
                                                        color: Colors.black
                                                            .withValues(
                                                                alpha: 0.1),
                                                      ),
                                                    ],
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Row(children: [
                                                  Icon(
                                                      Icons.location_on_rounded,
                                                      size: ResponsiveHelper
                                                              .isMobile()
                                                          ? Dimensions
                                                              .fontSizeExtraSmall
                                                          : Dimensions
                                                              .fontSizeSmall,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  SizedBox(
                                                      width: ResponsiveHelper
                                                              .isMobile()
                                                          ? 2
                                                          : Dimensions
                                                                  .paddingSizeExtraSmall /
                                                              2),
                                                  Expanded(
                                                      child: Text(
                                                    branchesValue?.branches
                                                            ?.address ??
                                                        '',
                                                    style:
                                                        rubikSemiBold.copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: ResponsiveHelper
                                                              .isMobile()
                                                          ? 8
                                                          : ResponsiveHelper
                                                                  .isTab(
                                                                      context)
                                                              ? 10
                                                              : Dimensions
                                                                  .fontSizeExtraSmall,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      shadows: [
                                                        Shadow(
                                                          offset: const Offset(
                                                              0.5, 0.5),
                                                          blurRadius: 1,
                                                          color: Colors.black
                                                              .withValues(
                                                                  alpha: 0.08),
                                                        ),
                                                      ],
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                                ]),
                                              ]),
                                        ),
                                      ),
                                      if (branchesValue!.distance != -1 &&
                                          splashProvider.configModel
                                                  ?.googleMapStatus ==
                                              1)
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                              Text(
                                                '${branchesValue!.distance.toStringAsFixed(3)} ${getTranslated('km', context)}',
                                                style: rubikBold.copyWith(
                                                  fontSize: ResponsiveHelper
                                                          .isMobile()
                                                      ? 8
                                                      : ResponsiveHelper.isTab(
                                                              context)
                                                          ? 10
                                                          : Dimensions
                                                              .fontSizeExtraSmall,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                      offset: const Offset(
                                                          0.5, 0.5),
                                                      blurRadius: 1,
                                                      color: Colors.black
                                                          .withValues(
                                                              alpha: 0.1),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                  getTranslated(
                                                      'away', context)!,
                                                  style: rubikSemiBold.copyWith(
                                                    fontSize: ResponsiveHelper
                                                            .isMobile()
                                                        ? 7
                                                        : ResponsiveHelper
                                                                .isTab(context)
                                                            ? 8
                                                            : 9,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    shadows: [
                                                      Shadow(
                                                        offset: const Offset(
                                                            0.5, 0.5),
                                                        blurRadius: 1,
                                                        color: Colors.black
                                                            .withValues(
                                                                alpha: 0.08),
                                                      ),
                                                    ],
                                                  )),
                                            ])),
                                    ]),
                              ])),
                        ]),
                  )),
            ]),
          ),

          /// for Branch image
          Positioned(
            bottom: ResponsiveHelper.isMobile() ? 15 : 20,
            left: ResponsiveHelper.isMobile() ? 10 : 15,
            child: Container(
              height: ResponsiveHelper.isMobile()
                  ? 60
                  : ResponsiveHelper.isTab(context)
                      ? 65
                      : 70,
              width: ResponsiveHelper.isMobile()
                  ? 60
                  : ResponsiveHelper.isTab(context)
                      ? 65
                      : 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: EdgeInsets.only(
                  right: ResponsiveHelper.isMobile()
                      ? Dimensions.paddingSizeExtraSmall
                      : Dimensions.paddingSizeSmall),
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  border: Border.all(color: Colors.white, width: 1),
                  color: Theme.of(context).cardColor,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: CustomImageWidget(
                      placeholder: Images.placeholderImage,
                      image:
                          '${splashProvider.baseUrls!.branchImageUrl}/${branchesValue!.branches!.image}',
                      height: ResponsiveHelper.isMobile()
                          ? 60
                          : ResponsiveHelper.isTab(context)
                              ? 65
                              : 70,
                      width: ResponsiveHelper.isMobile()
                          ? 60
                          : ResponsiveHelper.isTab(context)
                              ? 65
                              : 70,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          ),
        ]),
      );
    });
  }
}

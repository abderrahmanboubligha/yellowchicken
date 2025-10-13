import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class BranchButtonWidget extends StatelessWidget {
  final Color? color;
  final bool isRow;
  final bool isPopup;

  const BranchButtonWidget({
    super.key,
    this.isRow = true,
    this.color,
    this.isPopup = false,
  });

  @override
  Widget build(BuildContext context) {
    // Debug: Check branch data
    print(
        'Debug - Current branch: ${Provider.of<BranchProvider>(context, listen: false).getBranch()?.name}');

    return Consumer<SplashProvider>(builder: (context, splashProvider, _) {
      return splashProvider.isBranchSelectDisable()
          ? Consumer<BranchProvider>(
              builder: (context, branchProvider, _) {
                return branchProvider.getBranchId() != -1
                    ? isPopup
                        ? const BranchPopUpButton()
                        : InkWell(
                            onTap: () => RouterHelper.getBranchListScreen(),
                            child: isRow
                                ? Row(children: [
                                    Row(children: [
                                      CustomAssetImageWidget(
                                        Images.branchIcon,
                                        color: color ??
                                            Theme.of(context).primaryColor,
                                        height: Dimensions.paddingSizeDefault,
                                      ),
                                      RotatedBox(
                                          quarterTurns: 1,
                                          child: Icon(Icons.sync_alt,
                                              color: color ??
                                                  Theme.of(context)
                                                      .primaryColor,
                                              size: Dimensions
                                                  .paddingSizeDefault)),
                                      const SizedBox(width: 2),
                                      Text(
                                        branchProvider.getBranch()?.name ??
                                            getTranslated(
                                                'select_branch', context) ??
                                            'Select Branch',
                                        style: rubikRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall,
                                            color: color ??
                                                Theme.of(context).primaryColor),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ]),
                                  ])
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(
                                          height: Dimensions.paddingSizeSmall),
                                      Row(children: [
                                        CustomAssetImageWidget(
                                          Images.branchIcon,
                                          color: color ??
                                              Theme.of(context).primaryColor,
                                          height: Dimensions.paddingSizeDefault,
                                        ),
                                        RotatedBox(
                                            quarterTurns: 1,
                                            child: Icon(Icons.sync_alt,
                                                color: color ??
                                                    Theme.of(context)
                                                        .primaryColor,
                                                size: Dimensions
                                                    .paddingSizeDefault))
                                      ]),
                                      const SizedBox(height: 8),
                                      Text(
                                        branchProvider.getBranch()?.name ??
                                            getTranslated(
                                                'select_branch', context) ??
                                            'Select Branch',
                                        style: rubikRegular.copyWith(
                                            color: color ??
                                                Theme.of(context).primaryColor,
                                            fontSize: Dimensions.fontSizeSmall),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ))
                    : const SizedBox();
              },
            )
          : const SizedBox();
    });
  }
}

class BranchPopUpButton extends StatelessWidget {
  const BranchPopUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => RouterHelper.getBranchListScreen(),
      child: Consumer<BranchProvider>(builder: (context, branchProvider, _) {
        return Row(
            mainAxisSize: MainAxisSize.min, // Take only the space needed
            children: [
              Flexible(
                // Make the column flexible
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(getTranslated('branch', context)!,
                            style: rubikRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).hintColor,
                            )),
                        const SizedBox(height: 2), // Small gap between texts
                        Text(
                          branchProvider.getBranch()?.name ??
                              getTranslated('select_branch', context) ??
                              'Select Branch',
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ]),
                ), // Close Padding
              ), // Close Flexible
              const SizedBox(
                  width: 1), // Minimal spacing between text and arrow
              Icon(Icons.expand_more,
                  size: Dimensions.paddingSizeDefault,
                  color: Theme.of(context).hintColor),
            ]);
      }),
    );
  }
}

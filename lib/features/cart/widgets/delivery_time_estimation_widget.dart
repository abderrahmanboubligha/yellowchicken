import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/branch_list_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class DeliveryTimeEstimationWidget extends StatelessWidget {
  const DeliveryTimeEstimationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final BranchProvider branchProvider = Provider.of<BranchProvider>(context, listen: false);

    final bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // Light yellow/cream background
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      padding: const EdgeInsets.only(
        top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            const CustomAssetImageWidget(Images.locationPinSvg, width: 24, height: 24, color: Color(0xFFFF8C00)),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text(branchProvider.getBranch()?.name ?? '', style: rubikSemiBold.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: isDesktop ? FontWeight.w600 : FontWeight.w400,
              color: const Color(0xFF8B4513), // Brown text color
            )),
          ]),

          InkWell(
            onTap: (){
              ResponsiveHelper.showDialogOrBottomSheet(context, CustomAlertDialogWidget(
                width: 500,

                child: Padding(
                  padding: isDesktop ?  const EdgeInsets.symmetric(vertical: 40, horizontal: Dimensions.paddingSizeDefault) : EdgeInsets.zero,
                  child: BranchListWidget(controller: ScrollController(), isItemChange: true),
                ),
              ));
            },
            child: Text(getTranslated('change', context)!, style: rubikSemiBold.copyWith(
              fontSize: Dimensions.fontSizeSmall, color: const Color(0xFF8B4513), // Brown text color
            )),
          ),
        ]),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Divider(color: const Color(0xFFFF8C00).withOpacity(0.3), height: Dimensions.paddingSizeLarge, thickness: 0.5),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            const SizedBox(width: 45, height: 45, child: CustomAssetImageWidget(
              Images.deliveryPersonSvg, width: 40, height: 40,
            )),

            Expanded(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(getTranslated('estimate_delivery_time', context)!, style: rubikRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: const Color(0xFF8B4513), // Brown text color
                )),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Text('30min - 40min', style: rubikSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF8B4513), // Brown text color
                )),
              ]),
            ),

            const SizedBox(width: 45, height: 45, child: CustomAssetImageWidget(
              Images.deliveryScooterSvg, width: 40, height: 40,
            )),

          ]),
        ),

      ]),
    );
  }
}
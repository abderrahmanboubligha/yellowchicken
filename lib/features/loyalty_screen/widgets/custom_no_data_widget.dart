import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class CustomNoDataWidget extends StatelessWidget {
  final bool isEarning;
  
  const CustomNoDataWidget({
    super.key,
    this.isEarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: CustomAssetImageWidget(
              isEarning ? Images.loyaltyNothingFound : Images.convertedNothingFound,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Text(
            getTranslated('loyalty_nothing_found', context)!,
            style: rubikMedium.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }
}

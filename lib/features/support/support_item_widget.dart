import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class SupportItemWidget extends StatelessWidget {
  final String? label;
  final String? info;
  final IconData? iconData;
  final String? imageAsset;
  final Function()? onTap;
  const SupportItemWidget({
    super.key, 
    this.label, 
    this.info, 
    this.iconData, 
    this.imageAsset,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with orange background
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeSmall,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5E0), // Light orange background
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              ),
              child: Row(
                children: [
                  if (imageAsset != null)
                    Padding(
                      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      child: CustomAssetImageWidget(
                        imageAsset!,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  Text(
                    label ?? '',
                    style: rubikMedium.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: const Color(0xFFB54708), // Brown text color
                    ),
                  ),
                ],
              ),
            ),
            
            // Content with white background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeSmall,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    info ?? '',
                    style: rubikRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      color: Theme.of(context).primaryColor.withOpacity(0.1)
                    ),
                    child: Icon(
                      iconData ?? (label?.toLowerCase().contains('call') == true ? Icons.call_rounded : 
                      label?.toLowerCase().contains('email') == true ? Icons.email : 
                      Icons.location_on),
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

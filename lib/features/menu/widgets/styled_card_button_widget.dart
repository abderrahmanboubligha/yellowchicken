import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class StyledCardButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String image;
  final String title;
  
  const StyledCardButtonWidget({
    super.key, 
    required this.image, 
    required this.title, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110, 
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).cardColor,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                CustomAssetImageWidget(
                  image, 
                  height: 25, 
                  width: 25, 
                  color: Theme.of(context).primaryColor
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Text(
                  title, 
                  style: rubikMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).primaryColor,
                  )
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}

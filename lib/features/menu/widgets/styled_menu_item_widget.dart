import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class StyledMenuItemWidget extends StatelessWidget {
  final String? imageIcon;
  final IconData? icon;
  final String title;
  final VoidCallback? onRoute;
  final Color? iconColor;
  final String? suffix;

  const StyledMenuItemWidget({
    super.key, 
    this.imageIcon, 
    required this.title,
    this.suffix, 
    this.icon, 
    this.onRoute,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: onRoute,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              if (icon != null)
                Icon(icon, color: iconColor ?? Theme.of(context).primaryColor, size: 20)
              else if (imageIcon != null)
                CustomAssetImageWidget(
                  imageIcon!, 
                  height: 20, 
                  width: 20, 
                  color: iconColor ?? Theme.of(context).primaryColor,
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: rubikMedium.copyWith(
                    color: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.color ??
                        Colors.black,
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),
              ),
              if (suffix != null)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeExtraSmall, 
                    horizontal: Dimensions.paddingSizeSmall
                  ),
                  margin: const EdgeInsets.only(right: 8),
                  child: Text(
                    suffix!, 
                    style: rubikRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall, 
                      color: Theme.of(context).cardColor
                    )
                  ),
                ),
              Icon(Icons.chevron_right, color: Theme.of(context).hintColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

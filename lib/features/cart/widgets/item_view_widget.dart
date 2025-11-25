import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class ItemViewWidget extends StatelessWidget {
  const ItemViewWidget({
    super.key,
    required this.title,
    required this.subTitle,
    this.titleStyle,
    this.subTitleStyle,
  });

  final String title;
  final String subTitle;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title,
          style: titleStyle ?? ResponsiveStyles.responsiveSemiBold(context).copyWith(
            color: Colors.black, // Changed title text color to black
          )),
      CustomDirectionalityWidget(
          child: Text(subTitle,
              style: subTitleStyle ??
                  ResponsiveStyles.responsiveRegular(context).copyWith(
                    color: const Color(0xFFFF8C00), // Orange text for price
                    fontWeight: FontWeight.w600,
                  ))),
    ]);
  }
}

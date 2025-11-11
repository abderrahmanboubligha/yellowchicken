import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';

import '../../utill/color_resources.dart';


class NotLoggedInWidget extends StatelessWidget {
  const NotLoggedInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(

                padding: ResponsiveHelper.isDesktop(context)?
                const EdgeInsets.all(Dimensions.paddingSizeExtraLarge): const EdgeInsets.all(0),

                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
                  child: Center(
                    child: Container(
                      decoration:ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color:ColorResources.cardShadowColor.withValues(alpha:0.2),
                              blurRadius: 10,
                            )
                          ]
                      ) : const BoxDecoration(),
                      child: Padding(
                        padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)?100:10),
                        child: Column( children: [

                          Image.asset(
                            Images.guestLogin,
                            width: MediaQuery.of(context).size.height * 0.25,
                            height: MediaQuery.of(context).size.height * 0.25,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.03),

                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: Text(
                              getTranslated('guest_mode', context)!,
                              style: rubikBold.copyWith(fontSize: 18),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.02),

                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: Text(
                              getTranslated('now_you_are_in_guest_mode', context)!,
                              style: rubikRegular.copyWith(fontSize: 14),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.03),

                          SizedBox(
                            width: 120,
                            height: 45,
                            child: CustomButtonWidget(
                              btnTxt: getTranslated('login', context),
                              backgroundColor: const Color(0xFFFF8C00),
                              borderRadius: 25,
                              onTap: () {
                                RouterHelper.getLoginRoute(action: RouteAction.pushReplacement);
                              }),
                          ),

                        ]),
                      ),
                    ),
                  ),
                ),
              ),
              if(ResponsiveHelper.isDesktop(context)) const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

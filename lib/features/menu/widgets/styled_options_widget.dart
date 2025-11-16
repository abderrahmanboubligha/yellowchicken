import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/menu/widgets/styled_card_button_widget.dart';
import 'package:flutter_restaurant/features/menu/widgets/styled_menu_item_widget.dart';
import 'package:flutter_restaurant/features/scaner/screens/scaner_screen.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class StyledOptionsWidget extends StatelessWidget {
  final Function? onTap;
  const StyledOptionsWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // Card buttons row
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.13,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Row(
                    children: [
                      Expanded(
                        child: StyledCardButtonWidget(
                          title: getTranslated('favourite', context)!,
                          image: Images.favoriteSvg,
                          onTap: () => RouterHelper.getDashboardRoute('favourite'),
                        ),
                      ),
                      if(splashProvider.configModel?.walletStatus ?? false) Expanded(
                        child: StyledCardButtonWidget(
                          title: getTranslated('wallet', context)!,
                          image: Images.walletSvg,
                          onTap: () => RouterHelper.getWalletRoute(),
                        ),
                      ),
                      if(splashProvider.configModel?.loyaltyPointStatus ?? false) Expanded(
                        child: StyledCardButtonWidget(
                          title: getTranslated('loyalty_point', context)!,
                          image: Images.loyaltyPointsSvg,
                          onTap: () => RouterHelper.getLoyaltyScreen(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              // General section
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getTranslated('general', context)!, 
                      style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault)
                    ),
                    const SizedBox(height: 16),
                    
                    // General menu items
                    StyledMenuItemWidget(
                      imageIcon: Images.profileSvg, 
                      title: getTranslated('profile', context)!, 
                      onRoute: () => RouterHelper.getProfileRoute()
                    ),
                    StyledMenuItemWidget(
                      imageIcon: Images.ordersSvg, 
                      title: getTranslated('my_order', context)!, 
                      onRoute: () => RouterHelper.getDashboardRoute('order')
                    ),
                    StyledMenuItemWidget(
                      imageIcon: Images.trackOrder, 
                      title: getTranslated('order_details', context)!, 
                      onRoute: () => RouterHelper.getOrderSearchScreen()
                    ),
                    StyledMenuItemWidget(
                      imageIcon: Images.notification, 
                      title: getTranslated('notification', context)!, 
                      onRoute: () => RouterHelper.getNotificationRoute()
                    ),
                    if(!kIsWeb) StyledMenuItemWidget(
                      imageIcon: Images.scanner, 
                      title: getTranslated('qr_scan', context)!, 
                      onRoute: () => Get.navigator!.push(MaterialPageRoute(builder: (context) => const ScannerScreen()))
                    ),
                    StyledMenuItemWidget(
                      imageIcon: Images.addressSvg, 
                      title: getTranslated('address', context)!, 
                      onRoute: () => RouterHelper.getAddressRoute()
                    ),
                    StyledMenuItemWidget(
                      imageIcon: Images.messageSvg, 
                      title: getTranslated('message', context)!, 
                      onRoute: () => RouterHelper.getChatRoute()
                    ),
                    StyledMenuItemWidget(
                      imageIcon: Images.couponSvg, 
                      title: getTranslated('coupon', context)!, 
                      onRoute: () => RouterHelper.getCouponRoute()
                    ),
                    if(splashProvider.configModel?.referEarnStatus ?? false) StyledMenuItemWidget(
                      imageIcon: Images.usersSvg, 
                      title: getTranslated('refer_and_earn', context)!, 
                      onRoute: () => RouterHelper.getReferAndEarnRoute()
                    ),
                    StyledMenuItemWidget(
                      imageIcon: Images.languageSvg, 
                      title: getTranslated('language', context)!, 
                      onRoute: () => RouterHelper.getLanguageRoute(true)
                    ),
                    
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          // Show more options
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) => _buildMoreView(context, authProvider, splashProvider),
                          );
                        },
                        child: Text(
                          'More', 
                          style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              Text(
                '${getTranslated('version', context)} ${AppConstants.appVersion}', 
                style: rubikRegular.copyWith(
                  color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.4),
                )
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreView(BuildContext context, AuthProvider authProvider, SplashProvider splashProvider) {
    final bool isLoggedIn = authProvider.isLoggedIn();
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.chevron_left,
                      color: Theme.of(context).hintColor,
                      size: 22,
                    ),
                  ),
                ),
                Text(
                  'More',
                  style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            StyledMenuItemWidget(
              imageIcon: Images.supportSvg, 
              title: getTranslated('help_and_support', context)!, 
              onRoute: () {
                Navigator.pop(context);
                RouterHelper.getSupportRoute();
              }
            ),
            StyledMenuItemWidget(
              imageIcon: Images.documentSvg, 
              title: getTranslated('privacy_policy', context)!, 
              onRoute: () {
                Navigator.pop(context);
                RouterHelper.getPolicyRoute();
              }
            ),
            StyledMenuItemWidget(
              imageIcon: Images.documentAltSvg, 
              title: getTranslated('terms_and_condition', context)!, 
              onRoute: () {
                Navigator.pop(context);
                RouterHelper.getTermsRoute();
              }
            ),
            if(splashProvider.policyModel?.returnPage?.status ?? false)
              StyledMenuItemWidget(
                imageIcon: Images.invoiceSvg, 
                title: getTranslated('return_policy', context)!, 
                onRoute: () {
                  Navigator.pop(context);
                  RouterHelper.getReturnPolicyRoute();
                }
              ),
            if(splashProvider.policyModel?.refundPage?.status ?? false)
              StyledMenuItemWidget(
                imageIcon: Images.refundSvg, 
                title: getTranslated('refund_policy', context)!, 
                onRoute: () {
                  Navigator.pop(context);
                  RouterHelper.getRefundPolicyRoute();
                }
              ),
            if(splashProvider.policyModel?.cancellationPage?.status ?? false)
              StyledMenuItemWidget(
                imageIcon: Images.cancellationSvg, 
                title: getTranslated('cancellation_policy', context)!, 
                onRoute: () {
                  Navigator.pop(context);
                  RouterHelper.getCancellationPolicyRoute();
                }
              ),
            StyledMenuItemWidget(
              imageIcon: Images.infoSvg, 
              title: getTranslated('about_us', context)!, 
              onRoute: () {
                Navigator.pop(context);
                RouterHelper.getAboutUsRoute();
              }
            ),
            if(isLoggedIn) StyledMenuItemWidget(
              icon: Icons.delete,
              iconColor: Theme.of(context).primaryColor,
              title: getTranslated('delete_account', context)!,
              onRoute: () {
                Navigator.pop(context);
                ResponsiveHelper.showDialogOrBottomSheet(
                  context, 
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      return CustomAlertDialogWidget(
                        isLoading: authProvider.isLoading,
                        title: getTranslated('are_you_sure_to_delete_account', context),
                        subTitle: getTranslated('it_will_remove_your_all_information', context),
                        icon: Icons.question_mark_sharp,
                        isSingleButton: authProvider.isLoading,
                        leftButtonText: getTranslated('yes', context),
                        rightButtonText: getTranslated('no', context),
                        onPressLeft: () => authProvider.deleteUser(),
                      );
                    }
                  )
                );
              }
            ),
            StyledMenuItemWidget(
              imageIcon: isLoggedIn ? Images.logoutSvg : Images.login,
              title: getTranslated(isLoggedIn ? 'logout' : 'login', context)!,
              onRoute: () {
                Navigator.pop(context);
                if(isLoggedIn) {
                  ResponsiveHelper.showDialogOrBottomSheet(
                    context, 
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return CustomAlertDialogWidget(
                          isLoading: authProvider.isLoading,
                          title: getTranslated('want_to_sign_out', context),
                          icon: Icons.contact_support,
                          isSingleButton: authProvider.isLoading,
                          leftButtonText: getTranslated('yes', context),
                          rightButtonText: getTranslated('no', context),
                          onPressLeft: () {
                            authProvider.clearSharedData(context).then((condition) {
                              if(context.mounted){
                                if(ResponsiveHelper.isWeb()) {
                                  RouterHelper.getLoginRoute(action: RouteAction.popAndPush);
                                }else {
                                  context.pop();
                                  RouterHelper.getMainRoute();
                                }
                              }
                            });
                          },
                        );
                      }
                    )
                  );
                } else {
                  RouterHelper.getLoginRoute();
                }
              }
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/not_logged_in_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/refer_and_earn/widgets/refer_and_earn_web_widget.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final List<String?> hintList = [
    getTranslated('invite_your_friends', Get.context!),
    '${getTranslated('they_register', Get.context!)} ${AppConstants.appName} ${getTranslated('with_special_offer', Get.context!)}',
    getTranslated('you_made_your_earning', Get.context!),
  ];
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
          : CustomAppBarWidget(
                context: context,
                title: getTranslated('refer_and_earn', context),
                titleColor: Theme.of(context).primaryColor,
                centerTitle: true,
              )) as PreferredSizeWidget?,

      body: _isLoggedIn ? configModel.referEarnStatus!
        ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  width: ResponsiveHelper.isDesktop(context) ? Dimensions.webScreenWidth : double.maxFinite,
                  child: Consumer<ProfileProvider>(
                    builder: (context, profileProvider, _) {
                      if (profileProvider.userInfoModel == null) {
                        return const SizedBox();
                      }
                      
                      if (ResponsiveHelper.isDesktop(context)) {
                        return ReferAndEarnWebWidget(hintList: hintList);
                      }
                      
                      return Directionality(
                        textDirection: Directionality.of(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, 
                            children: [
                              const SizedBox(height: 20),
                              
                              // Title
                              Text(
                                getTranslated('invite_friends_earn_rewards', context)!,
                                style: rubikSemiBold.copyWith(
                                  fontSize: 20,
                                  color: const Color(0xFF8B2801),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              
                              // Gift Image
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Image.asset(
                                  'assets/image/earnicon.png',
                                  height: 120,
                                  width: 120,
                                ),
                              ),
                              const SizedBox(height: 30),
                              
                              // Referral Code Container
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF5E5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      getTranslated('your_referral_code', context)!,
                                      style: rubikRegular.copyWith(color: const Color(0xFF8B2801)),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${profileProvider.userInfoModel?.referCode ?? ''}',
                                      style: rubikBold.copyWith(
                                        fontSize: 24,
                                        color: const Color(0xFF8B2801),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    InkWell(
                                      onTap: () {
                                        if(profileProvider.userInfoModel!.referCode != null && profileProvider.userInfoModel!.referCode != '') {
                                          Clipboard.setData(ClipboardData(text: '${profileProvider.userInfoModel?.referCode ?? ''}'));
                                          showCustomSnackBarHelper(getTranslated('referral_code_copied', context), isError: false);
                                        }
                                      },
                                      child: Text(
                                        getTranslated('tap_to_copy', context)!,
                                        style: rubikRegular.copyWith(color: const Color(0xFF8B2801)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              
                              // Steps
                              _buildStepItem(1, getTranslated('send_an_invite_to_a_friend', context)!),
                              const SizedBox(height: 16),
                              _buildStepItem(2, getTranslated('your_friend_signs_up', context)!),
                              const SizedBox(height: 16),
                              _buildStepItem(3, getTranslated('you_made_your_earning_exclamation', context)!),
                              const SizedBox(height: 30),
                              
                              // Share Button
                              InkWell(
                                onTap: () => Share.share(profileProvider.userInfoModel!.referCode!, subject: profileProvider.userInfoModel!.referCode!),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF8800),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    getTranslated('share_link', context)!,
                                    style: rubikMedium.copyWith(color: Colors.white, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                if(ResponsiveHelper.isDesktop(context)) const FooterWidget(),
              ],
            ),
          ) : const NoDataWidget()
        : const NotLoggedInWidget(),
    );
  }
  
  Widget _buildStepItem(int number, String text) {
    return Row(
      textDirection: Directionality.of(context),
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFFF8800),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: rubikMedium.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: rubikRegular.copyWith(color: const Color(0xFF8B2801)),
            textAlign: Directionality.of(context) == TextDirection.rtl ? TextAlign.right : TextAlign.left,
          ),
        ),
      ],
    );
  }
}

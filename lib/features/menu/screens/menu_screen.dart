import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/menu/widgets/menu_web_widget.dart';
import 'package:flutter_restaurant/features/menu/widgets/styled_options_widget.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  final Function? onTap;
  const MenuScreen({super.key,  this.onTap});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  @override
  Widget build(BuildContext context) {

    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget()) : null,
      body: ResponsiveHelper.isDesktop(context) ? const MenuWebWidget() : Consumer<AuthProvider>(
        builder: (context, authProvider, _) {

          final bool isLoggedIn = authProvider.isLoggedIn();

          return Column(children: [

            Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) => Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.all(32),
                child: Column(children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).cardColor, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: isLoggedIn ? CustomImageWidget(
                        placeholder: Images.placeholderUser, height: 80, width: 80, fit: BoxFit.cover,
                        image: '${splashProvider.baseUrls!.customerImageUrl}/'
                            '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.image : ''}',
                      ) : const Icon(Icons.person_outline, size: 56),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isLoggedIn ? '${profileProvider.userInfoModel?.fName} ${profileProvider.userInfoModel?.lName}' : getTranslated('guest', context)!,
                    style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.white)
                  ),
                  
                  if(!isLoggedIn) TextButton(
                    onPressed: () => RouterHelper.getLoginRoute(),
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero, 
                      foregroundColor: Colors.white
                    ),
                    child: Text(
                      getTranslated('sign_up_or_login', context)!, 
                      style: rubikRegular.copyWith(color: Colors.white)
                    )
                  ),
                  
                  if(isLoggedIn) Text(
                    profileProvider.userInfoModel?.email ?? '',
                    style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white70),
                  ),
                ]),
              ),
            ),

            Expanded(child: StyledOptionsWidget(onTap: widget.onTap)),

          ]);
        }
      ),
    );
  }
}

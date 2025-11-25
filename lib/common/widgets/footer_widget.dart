import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterWidget extends StatefulWidget {
  const FooterWidget({super.key});

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  TextEditingController newsLetterController = TextEditingController();

  List<LinkModel> homeLinks = [
    LinkModel(
        title: 'home',
        route: () => RouterHelper.getHomeRoute(fromAppBar: 'true')),
    LinkModel(
        title: 'Favourites',
        route: () => RouterHelper.getDashboardRoute('favourite')),
    LinkModel(
        title: 'my_order',
        route: () => RouterHelper.getDashboardRoute('order')),
    LinkModel(title: 'profile', route: () => RouterHelper.getProfileRoute()),
    LinkModel(
        title: 'Language', route: () => RouterHelper.getLanguageRoute(true)),
  ];

  List<LinkModel> quickLinks = [
    LinkModel(title: 'contact_us', route: () => RouterHelper.getSupportRoute()),
    LinkModel(
        title: 'privacy_policy', route: () => RouterHelper.getPolicyRoute()),
    LinkModel(
        title: 'terms_and_condition',
        route: () => RouterHelper.getTermsRoute()),
    LinkModel(title: 'about_us', route: () => RouterHelper.getAboutUsRoute()),
  ];

  @override
  void dispose() {
    super.dispose();
    newsLetterController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ConfigModel configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    final paddingSizeWidth =
        (MediaQuery.of(context).size.width - Dimensions.webScreenWidth) / 2;

    return Container(
      width: double.maxFinite,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: paddingSizeWidth > 0 ? paddingSizeWidth : 40,
        vertical: 60,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              // Main footer content
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left section - Logo and Location
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo
                        Provider.of<SplashProvider>(context).baseUrls != null
                            ? Consumer<SplashProvider>(
                                builder: (context, splash, child) =>
                                    CustomImageWidget(
                                  image:
                                      '${splash.baseUrls?.restaurantImageUrl}/${splash.configModel!.restaurantLogo}',
                                  placeholder: Images.webAppBarLogo,
                                  fit: BoxFit.contain,
                                  width: 140,
                                  height: 60,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 24),
                        // Location
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location ....',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (configModel.footerDescription?.isNotEmpty ?? false)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              configModel.footerDescription ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 80),

                  // Center-left section - Home links
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Home',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...homeLinks.map(
                          (link) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () => link.route(),
                              child: Text(
                                getTranslated(link.title, context) ??
                                    link.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 60),

                  // Center-right section - Quick Links
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Links',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...quickLinks.map(
                          (link) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () => link.route(),
                              child: Text(
                                getTranslated(link.title, context) ??
                                    link.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Bottom section - Social media and copyright
              Column(
                children: [
                  // Social media icons
                  if (configModel.socialMediaLink!.isNotEmpty)
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          configModel.socialMediaLink!.length,
                          (index) {
                            String? icon = Images.getShareIcon(
                                configModel.socialMediaLink![index].name ?? '');
                            return configModel.socialMediaLink!.isNotEmpty &&
                                    icon.isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      _launchURL(configModel
                                          .socialMediaLink![index].link!);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Image.asset(
                                        icon,
                                        height: 32,
                                        width: 32,
                                        fit: BoxFit.contain,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : const SizedBox();
                          },
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Copyright
                  Text(
                    configModel.footerCopyright ??
                        '© ${DateTime.now().year} ${configModel.restaurantName}. All rights reserved.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

class LinkModel {
  final String title;
  final Function route;

  LinkModel({required this.title, required this.route});
}

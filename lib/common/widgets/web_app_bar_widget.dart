import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/language_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/category/domain/category_model.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/home/widgets/cetegory_hover_widget.dart';
import 'package:flutter_restaurant/features/home/widgets/language_hover_widget.dart';
import 'package:flutter_restaurant/features/language/providers/language_provider.dart';
import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WebAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const WebAppBarWidget({super.key});

  @override
  State<WebAppBarWidget> createState() => _WebAppBarWidgetState();

  @override
  Size get preferredSize => const Size(double.maxFinite, 70);
}

class _WebAppBarWidgetState extends State<WebAppBarWidget> {
  @override
  void initState() {
    super.initState();
  }

  _showPopupMenu(Offset offset, BuildContext context, bool isCategory) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        overlay.size.width - offset.dx,
        overlay.size.height - offset.dy,
      ),
      items: isCategory ? popUpMenuList(context) : popUpLanguageList(context),
      elevation: 8.0,
      color: Theme.of(context).cardColor,
    );
  }

  List<PopupMenuEntry> popUpMenuList(BuildContext context) {
    List<PopupMenuEntry> categoryPopupMenuEntryList = [];
    List<CategoryModel>? categoryList =
        Provider.of<CategoryProvider>(context, listen: false).categoryList;

    categoryPopupMenuEntryList.add(PopupMenuItem(
      child: MouseRegion(
        onExit: (_) => context.pop(),
        child: CategoryHoverWidget(categoryList: categoryList),
      ),
    ));
    return categoryPopupMenuEntryList;
  }

  List<PopupMenuEntry> popUpLanguageList(BuildContext context) {
    List<PopupMenuEntry> languagePopupMenuEntryList = [];
    List<LanguageModel> languageList = AppConstants.languages;

    languagePopupMenuEntryList.add(PopupMenuItem(
      child: MouseRegion(
        onExit: (_) => context.pop(),
        child: LanguageHoverWidget(languageList: languageList),
      ),
    ));
    return languagePopupMenuEntryList;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LanguageProvider>(context, listen: false)
        .initializeAllLanguages(context);
    final LanguageModel currentLanguage = AppConstants.languages.firstWhere(
        (language) =>
            language.languageCode ==
            Provider.of<LocalizationProvider>(context, listen: false)
                .locale
                .languageCode);

    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            children: [
              // Logo
              InkWell(
                onTap: () => RouterHelper.getMainRoute(
                    action: RouteAction.pushReplacement),
                child: Provider.of<SplashProvider>(context).baseUrls != null
                    ? Consumer<SplashProvider>(
                        builder: (context, splash, child) => CustomImageWidget(
                          image:
                              '${splash.baseUrls?.restaurantImageUrl}/${splash.configModel!.restaurantLogo}',
                          placeholder: Images.webAppBarLogo,
                          fit: BoxFit.contain,
                          width: 120,
                          height: 45,
                        ),
                      )
                    : Image.asset(
                        Images.webAppBarLogo,
                        width: 120,
                        height: 45,
                        fit: BoxFit.contain,
                      ),
              ),

              const SizedBox(width: 80),

              // Navigation items - centered
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _NavItem(
                      title: getTranslated('home', context) ?? 'Home',
                      onTap: () =>
                          RouterHelper.getHomeRoute(fromAppBar: 'true'),
                    ),
                    const SizedBox(width: 32),
                    _NavItem(
                      title:
                          getTranslated('favourite', context) ?? 'Favourites',
                      onTap: () => RouterHelper.getDashboardRoute('favourite'),
                    ),
                    const SizedBox(width: 32),
                    _NavItem(
                      title: getTranslated('my_order', context) ?? 'My Orders',
                      onTap: () => RouterHelper.getDashboardRoute('order'),
                    ),
                    const SizedBox(width: 32),
                    _NavItem(
                      title: getTranslated('profile', context) ?? 'Profile',
                      onTap: () => RouterHelper.getProfileOverviewRoute(),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 40),

              // Right section - Branch, Language, Sign in
              Row(
                children: [
                  // Branch selector
                  Consumer<BranchProvider>(
                    builder: (context, branchProvider, _) => InkWell(
                      onTap: () {
                        RouterHelper.getBranchListScreen();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              getTranslated('branch', context) ?? 'Branch',
                              style: rubikRegular.copyWith(
                                color: const Color(0xFF333333),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.keyboard_arrow_down,
                                color: Color(0xFF666666), size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Language selector
                  if (AppConstants.languages.length > 1)
                    MouseRegion(
                      onHover: (details) {
                        _showPopupMenu(
                            Offset(details.position.dx, details.position.dy),
                            context,
                            false);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              getTranslated('navbar_language', context) ??
                                  currentLanguage.languageName ??
                                  currentLanguage.languageCode?.toUpperCase() ??
                                  'EN',
                              style: rubikRegular.copyWith(
                                color: const Color(0xFF333333),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.keyboard_arrow_down,
                                color: Color(0xFF666666), size: 16),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(width: 16),

                  // Sign in button (yellow)
                  InkWell(
                    onTap: () => RouterHelper.getProfileRoute(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        getTranslated('sign_in', context) ?? 'Sign in',
                        style: rubikMedium.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
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

// Navigation item widget
class _NavItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _NavItem({
    required this.title,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            widget.title,
            style: rubikRegular.copyWith(
              color: _isHovered
                  ? const Color(0xFFFF8C42)
                  : const Color(0xFF333333),
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

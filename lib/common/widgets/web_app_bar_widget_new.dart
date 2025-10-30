import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/language_model.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/common/widgets/theme_switch_button_widget.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/category/domain/category_model.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/checkout/widgets/selected_address_list_widget.dart';
import 'package:flutter_restaurant/features/home/widgets/cetegory_hover_widget.dart';
import 'package:flutter_restaurant/features/home/widgets/language_hover_widget.dart';
import 'package:flutter_restaurant/features/language/providers/language_provider.dart';
import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
import 'package:flutter_restaurant/features/search/providers/search_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/features/wishlist/providers/wishlist_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
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
  Size get preferredSize => const Size(double.maxFinite, 100);
}

class _WebAppBarWidgetState extends State<WebAppBarWidget> {
  final GlobalKey _searchBarKey = GlobalKey();
  final FocusNode _appbarSearchFocusNode = FocusNode();

  Future<void> _showSearchDialog() async {
    // Empty implementation for now
  }

  _showPopupMenu(Offset offset, BuildContext context, bool isCategory) async {
    // Empty implementation for now
  }

  List<PopupMenuEntry> popUpMenuList(BuildContext context) {
    List<PopupMenuEntry> categoryPopupMenuEntryList = [];
    List<CategoryModel>? categoryList =
        Provider.of<CategoryProvider>(context, listen: false).categoryList;

    categoryPopupMenuEntryList.add(PopupMenuItem(
      child: MouseRegion(
        onExit: (_) => context.pop(),
        child: CetegoryHoverWidget(categoryList: categoryList),
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
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final BranchProvider branchProvider =
        Provider.of<BranchProvider>(context, listen: false);

    Provider.of<LanguageProvider>(context, listen: false)
        .initializeAllLanguages(context);
    final LanguageModel currentLanguage = AppConstants.languages.firstWhere(
        (language) =>
            language.languageCode ==
            Provider.of<LocalizationProvider>(context, listen: false)
                .locale
                .languageCode);

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFa1143f),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          // Top bar with restaurant status and language
          Container(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side - Restaurant status
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      getTranslated('restaurant_is_close_now', context) ??
                          'Restaurant is close now',
                      style: rubikRegular.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                // Right side - Language and theme
                Row(
                  children: [
                    Text(
                      'Dark',
                      style: rubikRegular.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const ThemeSwitchButtonWidget(),
                    const SizedBox(width: 20),
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
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                currentLanguage.languageCode?.toUpperCase() ??
                                    'EN',
                                style: rubikRegular.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.white, size: 16),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Main navigation bar
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Logo
                  InkWell(
                    onTap: () => RouterHelper.getMainRoute(
                        action: RouteAction.pushReplacement),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.play_arrow,
                                color: Colors.black, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'پلونشکو',
                            style: rubikBold.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 40),

                  // Navigation items
                  InkWell(
                    onTap: () => RouterHelper.getHomeRoute(fromAppBar: 'true'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Text(
                        getTranslated('home', context) ?? 'Home',
                        style: rubikMedium.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  MouseRegion(
                    onHover: (details) {
                      if (categoryProvider.categoryList != null) {
                        _showPopupMenu(
                            Offset(details.position.dx, details.position.dy),
                            context,
                            true);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Text(
                            getTranslated('categories', context) ??
                                'Categories',
                            style: rubikMedium.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down,
                              color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Search bar
                  Container(
                    key: _searchBarKey,
                    width: 400,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Consumer<SearchProvider>(
                      builder: (context, search, _) => CustomTextFieldWidget(
                        onTap: _showSearchDialog,
                        isEnabled:
                            Provider.of<BranchProvider>(context, listen: false)
                                    .getBranchId() !=
                                -1,
                        focusNode: _appbarSearchFocusNode,
                        radius: 20,
                        hintText: getTranslated('are_you_hungry', context) ??
                            'Are you hungry?',
                        isShowBorder: false,
                        fillColor: Colors.white,
                        isShowPrefixIcon: search.searchLength == 0,
                        prefixIconUrl: Images.search,
                        prefixIconColor: Colors.grey,
                        suffixIconColor: Colors.grey,
                        onChanged: (str) => search.getSearchText(str),
                        controller: search.searchController,
                        inputAction: TextInputAction.search,
                        isIcon: true,
                        isShowSuffixIcon: search.searchLength > 0,
                        suffixIconUrl: Images.cancelSvg,
                        onSuffixTap: () {
                          search.searchController.clear();
                          search.getSearchText('');
                        },
                        onSubmit: (text) {
                          if (search.searchController.text.isNotEmpty) {
                            RouterHelper.getSearchResultRoute(
                                search.searchController.text);
                            search.searchDone();
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Branch selector
                  Consumer<BranchProvider>(
                    builder: (context, branchProvider, _) => InkWell(
                      onTap: () {
                        ResponsiveHelper.showDialogOrBottomSheet(
                          context,
                          SelectedAddressListWidget(
                            currentBranch: branchProvider.getBranch(),
                            isFromAppbar: true,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Branch',
                              style: rubikMedium.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down,
                                color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Right icons
                  Row(
                    children: [
                      // Wishlist
                      InkWell(
                        onTap: () =>
                            RouterHelper.getDashboardRoute('favourite'),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Stack(
                            children: [
                              const Icon(Icons.favorite_outline,
                                  color: Colors.white, size: 24),
                              Consumer<WishListProvider>(
                                builder: (context, wishlistProvider, _) {
                                  final count =
                                      wishlistProvider.wishList?.length ?? 0;
                                  if (count > 0) {
                                    return Positioned(
                                      right: -2,
                                      top: -2,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.orange,
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(
                                            minWidth: 16, minHeight: 16),
                                        child: Text(
                                          '$count',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Cart
                      InkWell(
                        onTap: () => RouterHelper.getDashboardRoute('cart'),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Stack(
                            children: [
                              const Icon(Icons.shopping_cart_outlined,
                                  color: Colors.white, size: 24),
                              Consumer<CartProvider>(
                                builder: (context, cartProvider, _) {
                                  final count = cartProvider.cartList.length;
                                  if (count > 0) {
                                    return Positioned(
                                      right: -2,
                                      top: -2,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.orange,
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(
                                            minWidth: 16, minHeight: 16),
                                        child: Text(
                                          '$count',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Profile
                      InkWell(
                        onTap: () => RouterHelper.getProfileRoute(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.person_outline,
                              color: Colors.white, size: 24),
                        ),
                      ),

                      // Menu
                      InkWell(
                        onTap: () => RouterHelper.getDashboardRoute('menu'),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child:
                              const Icon(Icons.menu, color: Colors.white, size: 24),
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Language selector
                      if (AppConstants.languages.length > 1)
                        MouseRegion(
                          onHover: (details) {
                            _showPopupMenu(
                                Offset(
                                    details.position.dx, details.position.dy),
                                context,
                                false);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currentLanguage.languageCode?.toUpperCase() ??
                                      'EN',
                                  style: rubikMedium.copyWith(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.keyboard_arrow_down,
                                    color: Colors.white, size: 16),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

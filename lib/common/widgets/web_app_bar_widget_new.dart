import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/language_model.dart';
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

class WebAppBarWidgetNew extends StatefulWidget implements PreferredSizeWidget {
  const WebAppBarWidgetNew({super.key});

  @override
  State<WebAppBarWidgetNew> createState() => _WebAppBarWidgetNewState();

  @override
  Size get preferredSize => const Size(double.maxFinite, 100);
}

class _WebAppBarWidgetNewState extends State<WebAppBarWidgetNew> {
  final GlobalKey _searchBarKey = GlobalKey();
  final FocusNode _appbarSearchFocusNode = FocusNode();

  Future<void> _showSearchDialog() async {
    // TODO: Implement search dialog later
  }

  Future<void> _showPopupMenu(
      Offset offset, BuildContext context, bool isCategory) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        overlay.size.width - offset.dx,
        0,
      ),
      items:
          isCategory ? popUpMenuList(context) : popUpLanguageList(context),
    );
  }

  List<PopupMenuEntry> popUpMenuList(BuildContext context) {
    List<CategoryModel>? categoryList =
        Provider.of<CategoryProvider>(context, listen: false).categoryList;

    return [
      PopupMenuItem(
        padding: EdgeInsets.zero,
        child: MouseRegion(
          onExit: (_) => context.pop(),
          child: CategoryHoverWidget(categoryList: categoryList),
        ),
      ),
    ];
  }

  List<PopupMenuEntry> popUpLanguageList(BuildContext context) {
    List<LanguageModel> languageList = AppConstants.languages;

    return [
      PopupMenuItem(
        padding: EdgeInsets.zero,
        child: MouseRegion(
          onExit: (_) => context.pop(),
          child: LanguageHoverWidget(languageList: languageList),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    print("WebAppBarWidgetNew is ACTIVE");

    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    Provider.of<LanguageProvider>(context, listen: false)
        .initializeAllLanguages(context);

    final LanguageModel currentLanguage = AppConstants.languages.firstWhere(
      (language) =>
          language.languageCode ==
          Provider.of<LocalizationProvider>(context, listen: false)
              .locale
              .languageCode,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Debug banner
        Container(
          width: double.infinity,
          color: Colors.red,
          padding: const EdgeInsets.all(8),
          child: const Text(
            'DEBUG: WebAppBarWidgetNew is ACTIVE',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),

        Container(
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFa1143f),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Top red bar
              Container(
                height: 35,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            color: Colors.white, size: 16),
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

                    Row(
                      children: [
                        Text("Dark",
                            style: rubikRegular.copyWith(
                                color: Colors.white, fontSize: 14)),
                        const SizedBox(width: 6),
                        const ThemeSwitchButtonWidget(),
                        const SizedBox(width: 20),

                        // LANGUAGE DROPDOWN
                        if (AppConstants.languages.length > 1)
                          MouseRegion(
                            onHover: (details) {
                              _showPopupMenu(
                                  details.position, context, false);
                            },
                            child: Row(
                              children: [
                                Text(
                                  currentLanguage.languageName ??
                                      currentLanguage.languageCode ??
                                      "EN",
                                  style: rubikRegular.copyWith(
                                      color: Colors.white, fontSize: 14),
                                ),
                                const Icon(Icons.keyboard_arrow_down,
                                    color: Colors.white, size: 16),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // LOGO
                      InkWell(
                        onTap: () =>
                            RouterHelper.getMainRoute(action: RouteAction.pushReplacement),
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
                                  color: Colors.black),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'پلونشكو',
                              style: rubikBold.copyWith(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 40),

                      // NAV ITEMS
                      InkWell(
                        onTap: () =>
                            RouterHelper.getHomeRoute(fromAppBar: 'true'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Text(
                            getTranslated('home', context) ?? "Home",
                            style: rubikMedium.copyWith(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),

                      // Category hover
                      MouseRegion(
                        onHover: (details) {
                          if (categoryProvider.categoryList != null) {
                            _showPopupMenu(
                                details.position, context, true);
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              getTranslated('categories', context) ??
                                  'Categories',
                              style: rubikMedium.copyWith(
                                  color: Colors.white, fontSize: 16),
                            ),
                            const Icon(Icons.keyboard_arrow_down,
                                color: Colors.white),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // SEARCH BAR
                      Container(
                        key: _searchBarKey,
                        width: 400,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Consumer<SearchProvider>(
                          builder: (context, search, _) {
                            return CustomTextFieldWidget(
                              onTap: _showSearchDialog,
                              isEnabled:
                                  Provider.of<BranchProvider>(context,
                                              listen: false)
                                          .getBranchId() !=
                                      -1,
                              focusNode: _appbarSearchFocusNode,
                              radius: 20,
                              hintText: getTranslated(
                                      'are_you_hungry', context) ??
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
                                if (text.isNotEmpty) {
                                  RouterHelper.getSearchResultRoute(text);
                                  search.searchDone();
                                }
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 20),

                      // BRANCH SELECT
                      Consumer<BranchProvider>(
                        builder: (context, branchProvider, _) {
                          return InkWell(
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
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.white, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    getTranslated('branch', context) ??
                                        'Branch',
                                    style: rubikMedium.copyWith(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: 20),

                      // RIGHT ICONS (wishlist, cart, profile, menu)
                      Row(
                        children: [
                          // WISHLIST
                          InkWell(
                            onTap: () =>
                                RouterHelper.getDashboardRoute('favourite'),
                            child: Stack(
                              children: [
                                const Icon(Icons.favorite_outline,
                                    color: Colors.white),
                                Consumer<WishListProvider>(
                                  builder: (context, wishlist, _) {
                                    final count =
                                        wishlist.wishList?.length ?? 0;
                                    if (count == 0) return SizedBox();
                                    return Positioned(
                                      right: -2,
                                      top: -2,
                                      child: _badge(count),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          // CART
                          InkWell(
                            onTap: () =>
                                RouterHelper.getDashboardRoute('cart'),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    const Icon(Icons.shopping_cart_outlined,
                                        color: Colors.white),
                                    Consumer<CartProvider>(
                                      builder: (context, cart, _) {
                                        final count = cart.cartList.length;
                                        if (count == 0) return SizedBox();
                                        return Positioned(
                                          right: -2,
                                          top: -2,
                                          child: _badge(count),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "(${getTranslated('cart', context) ?? 'Cart'}) سلة التسويق",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                )
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          // PROFILE
                          InkWell(
                            onTap: () => RouterHelper.getProfileRoute(),
                            child: const Icon(Icons.person_outline,
                                color: Colors.white),
                          ),

                          const SizedBox(width: 20),

                          // MENU
                          InkWell(
                            onTap: () =>
                                RouterHelper.getDashboardRoute('menu'),
                            child: const Icon(Icons.menu, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // BADGE WIDGET
  Widget _badge(int count) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Color(0xFFFFD700),
        shape: BoxShape.circle,
      ),
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      child: Text(
        '$count',
        style: const TextStyle(color: Colors.white, fontSize: 10),
        textAlign: TextAlign.center,
      ),
    );
  }
}

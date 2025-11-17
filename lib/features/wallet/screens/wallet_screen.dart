import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/features/wallet/providers/wallet_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/not_logged_in_widget.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_restaurant/features/wallet/widgets/add_fund_dialogue_widget.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:go_router/go_router.dart';
import '../widgets/history_item_widget.dart';

class WalletScreen extends StatefulWidget {
  final String? token;
  final String? status;
  const WalletScreen({super.key, this.token, this.status});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ScrollController scrollController = ScrollController();
  final tooltipController = JustTheController();

  final bool isLoggedIn =
      Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn();
  List<PopupMenuEntry> entryList = [];
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    final walletProvide = Provider.of<WalletProvider>(context, listen: false);

    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      walletProvide.getWalletBonusList(false);
    }
    walletProvide.setCurrentTabButton(0, isUpdate: false);
    walletProvide.insertFilterList();
    walletProvide.setWalletFilerType('all', isUpdate: false);

    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if (widget.status!.contains('success')) {
        if ((!kIsWeb ||
                (kIsWeb &&
                    widget.token != null &&
                    walletProvide.checkToken(widget.token!))) &&
            mounted) {
          showCustomSnackBarHelper(
              getTranslated('add_fund_successful', context),
              isError: false);
        }
        Provider.of<ProfileProvider>(Get.context!, listen: false)
            .getUserInfo(true, isUpdate: true);
      } else if (widget.status!.contains('fail') && mounted) {
        showCustomSnackBarHelper(getTranslated('add_fund_failed', context));
      }
    });

    if (isLoggedIn) {
      walletProvide.getLoyaltyTransactionList('1', false, true,
          isEarning: walletProvide.selectedTabButtonIndex == 1);

      scrollController.addListener(() {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            walletProvide.transactionList != null &&
            !walletProvide.isLoading) {
          int pageSize = (walletProvide.popularPageSize! / 10).ceil();
          if (walletProvide.offset < pageSize) {
            walletProvide.setOffset = walletProvide.offset + 1;
            walletProvide.updatePagination(true);

            walletProvide.getLoyaltyTransactionList(
              walletProvide.offset.toString(),
              false,
              true,
              isEarning: walletProvide.selectedTabButtonIndex == 1,
            );
          }
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ConfigModel configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF9FAFB),
      body: configModel.walletStatus!
          ? isLoggedIn
              ? RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    final WalletProvider walletProvider =
                        Provider.of<WalletProvider>(context, listen: false);
                    walletProvider.getLoyaltyTransactionList('1', false, true);
                  },
                  child:
                      CustomScrollView(controller: scrollController, slivers: [
                    if (!ResponsiveHelper.isDesktop(context))
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        expandedHeight: 60,
                        collapsedHeight: 60,
                        pinned: true,
                        floating: false,
                        leading: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => context.pop(),
                        ),
                        title: Text(
                          getTranslated('wallet', context) ?? 'Wallet',
                          style: rubikSemiBold.copyWith(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        centerTitle: false,
                      ),
                    // Tab Navigation
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() => selectedTab = 0);
                              },
                              child: Column(
                                children: [
                                  Text(
                                    getTranslated('wallet', context) ??
                                        'Wallet',
                                    style: rubikSemiBold.copyWith(
                                      fontSize: 16,
                                      color: selectedTab == 0
                                          ? const Color(0xFFFF9500)
                                          : const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (selectedTab == 0)
                                    Container(
                                      height: 2,
                                      width: 40,
                                      color: const Color(0xFFFF9500),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),
                            GestureDetector(
                              onTap: () {
                                setState(() => selectedTab = 1);
                              },
                              child: Column(
                                children: [
                                  Text(
                                    getTranslated('payment_method', context) ??
                                        'Payment Method',
                                    style: rubikSemiBold.copyWith(
                                      fontSize: 16,
                                      color: selectedTab == 1
                                          ? const Color(0xFFFF9500)
                                          : const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (selectedTab == 1)
                                    Container(
                                      height: 2,
                                      width: 120,
                                      color: const Color(0xFFFF9500),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 24),
                    ),
                    // Balance Card
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Consumer<ProfileProvider>(
                          builder: (context, profileProvider, _) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFEF3C7),
                                    Color(0xFFFED7AA),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        getTranslated(
                                                'current_balance', context) ??
                                            'Current Balance',
                                        style: rubikSemiBold.copyWith(
                                          fontSize: 14,
                                          color: const Color(0xFF92400E),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '£',
                                            style: rubikBold.copyWith(
                                              fontSize: 24,
                                              color: const Color(0xFF92400E),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          CustomDirectionalityWidget(
                                            child: Text(
                                              profileProvider.isLoading
                                                  ? '0'
                                                  : (profileProvider
                                                              .userInfoModel
                                                              ?.walletBalance ??
                                                          0)
                                                      .toStringAsFixed(2),
                                              style: rubikBold.copyWith(
                                                fontSize: 24,
                                                color: const Color(0xFF92400E),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const AddFundDialogueWidget());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFFF9500),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                      ),
                                      child: Text(
                                        getTranslated('top_up', context) ??
                                            'Top up',
                                        style: rubikSemiBold.copyWith(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 24),
                    ),
                    // All Transactions Title with Filter
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getTranslated('all_transactions', context) ??
                                  'All transactions',
                              style: rubikSemiBold.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Consumer<WalletProvider>(
                              builder: (context, walletProvider, _) {
                                return PopupMenuButton<String>(
                                  onSelected: (value) {
                                    walletProvider.setWalletFilerType(value,
                                        isUpdate: true);
                                    walletProvider.getLoyaltyTransactionList(
                                      '1',
                                      false,
                                      true,
                                      isEarning: walletProvider
                                              .selectedTabButtonIndex ==
                                          1,
                                    );
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return walletProvider.walletFilterList
                                        .map((filter) => PopupMenuItem<String>(
                                              value: filter.value ?? '',
                                              child: Text(
                                                getTranslated(
                                                        filter.value ?? '',
                                                        context) ??
                                                    filter.title ??
                                                    filter.value ??
                                                    '',
                                                style: robotoRegular.copyWith(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ))
                                        .toList();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFE5E7EB),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          getTranslated(walletProvider.type,
                                                  context) ??
                                              walletProvider.type,
                                          style: robotoRegular.copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.arrow_drop_down,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 16),
                    ),
                    if (selectedTab == 0)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Consumer<WalletProvider>(
                            builder: (context, walletProvider, _) {
                              return walletProvider.transactionList != null
                                  ? walletProvider.transactionList!.isNotEmpty
                                      ? Column(
                                          children: [
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: walletProvider
                                                  .transactionList!.length,
                                              separatorBuilder:
                                                  (context, index) {
                                                return const Divider(
                                                  color: Color(0xFFF3F4F6),
                                                  height: 16,
                                                );
                                              },
                                              itemBuilder: (context, index) {
                                                return WalletHistory(
                                                  transaction: walletProvider
                                                      .transactionList![index],
                                                );
                                              },
                                            ),
                                            if (walletProvider.paginationLoader)
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                    Dimensions
                                                        .paddingSizeSmall),
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                          ],
                                        )
                                      : const NoDataWidget(isFooter: false)
                                  : WalletShimmer(
                                      walletProvider: walletProvider);
                            },
                          ),
                        ),
                      ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 24),
                    ),
                    if (selectedTab == 1)
                      SliverToBoxAdapter(
                        child: Center(
                          child: SizedBox(
                            width: Dimensions.webScreenWidth,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeLarge,
                                  horizontal: Dimensions.paddingSizeDefault),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getTranslated('payment_method', context) ??
                                        'Payment Method',
                                    style: rubikSemiBold.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeLarge),
                                  Container(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeLarge),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: Text(
                                      'Payment method integration coming soon',
                                      style: rubikRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (ResponsiveHelper.isDesktop(context))
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(height: Dimensions.paddingSizeLarge),
                              FooterWidget(),
                            ]),
                      ),
                  ]),
                )
              : const NotLoggedInWidget()
          : const NoDataWidget(),
    );
  }
}

class TabButtonModel {
  final String? buttonText;
  final String buttonIcon;
  final Function onTap;

  TabButtonModel(this.buttonText, this.buttonIcon, this.onTap);
}

class WalletShimmer extends StatelessWidget {
  final WalletProvider walletProvider;
  const WalletShimmer({super.key, required this.walletProvider});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: UniqueKey(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 90,
        crossAxisSpacing: 50,
        mainAxisSpacing: ResponsiveHelper.isDesktop(context)
            ? Dimensions.paddingSizeLarge
            : 0.01,
        // childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4 : 3,
        crossAxisCount: ResponsiveHelper.isMobile() ? 1 : 2,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      padding:
          EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 28 : 25),
      itemBuilder: (context, index) {
        return Container(
          margin:
              const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withValues(alpha: 0.08))),
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeSmall,
              horizontal: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: walletProvider.transactionList == null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                      height: 10,
                      width: 20,
                      decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 10),
                  Container(
                      height: 10,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 10),
                  Container(
                      height: 10,
                      width: 70,
                      decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(2))),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/features/wallet/providers/wallet_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_restaurant/common/widgets/no_data_widget.dart';
import 'package:flutter_restaurant/common/widgets/not_logged_in_widget.dart';
import 'package:flutter_restaurant/common/widgets/title_widget.dart';
import 'package:flutter_restaurant/features/loyalty_screen/widgets/custom_no_data_widget.dart';
import 'package:flutter_restaurant/features/wallet/screens/wallet_screen.dart';
import 'package:flutter_restaurant/features/wallet/widgets/convert_money_widget.dart';
import 'package:flutter_restaurant/features/wallet/widgets/history_item_widget.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class LoyaltyScreen extends StatefulWidget {
  const LoyaltyScreen({super.key});

  @override
  State<LoyaltyScreen> createState() => _LoyaltyScreenState();
}

class _LoyaltyScreenState extends State<LoyaltyScreen> {
  final ScrollController scrollController = ScrollController();
  late final bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn =
        Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn();
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    walletProvider.setCurrentTabButton(0, isUpdate: false);

    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(Get.context!, listen: false)
          .getUserInfo(false, isUpdate: false);

      walletProvider.getLoyaltyTransactionList('1', false, false,
          isEarning: walletProvider.selectedTabButtonIndex == 1);

      scrollController.addListener(() {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            walletProvider.transactionList != null &&
            !walletProvider.isLoading) {
          int pageSize = (walletProvider.popularPageSize! / 10).ceil();
          if (walletProvider.offset < pageSize) {
            walletProvider.setOffset = walletProvider.offset + 1;
            walletProvider.updatePagination(true);

            walletProvider.getLoyaltyTransactionList(
              walletProvider.offset.toString(),
              false,
              false,
              isEarning: walletProvider.selectedTabButtonIndex == 1,
            );
          }
        }
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ConfigModel configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: !configModel.loyaltyPointStatus!
          ? const NoDataWidget()

          // Profile provider
          : Consumer<ProfileProvider>(
              builder: (context, profileProvider, _) {
                if (!_isLoggedIn) {
                  return const NotLoggedInWidget();
                }

                if (profileProvider.isLoading ||
                    profileProvider.userInfoModel == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Consumer<WalletProvider>(
                  builder: (context, walletProvider, _) {
                    return CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        if (!ResponsiveHelper.isDesktop(context))
                          SliverAppBar(
                            backgroundColor: Colors.white,
                            expandedHeight: 60,
                            collapsedHeight: 60,
                            pinned: true,
                            floating: false,
                            leading: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.black),
                              onPressed: () => context.pop(),
                            ),
                            title: Text(
                              getTranslated('loyalty_points', context) ??
                                  'Loyalty Points',
                              style: rubikSemiBold.copyWith(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            centerTitle: true,
                          ),
                        SliverToBoxAdapter(
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Center(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: Dimensions.webScreenWidth,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.orange[400]!,
                                                Colors.orange[300]!
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                          padding: const EdgeInsets.all(24),
                                          margin: const EdgeInsets.all(24),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomDirectionalityWidget(
                                                          child: Text(
                                                            '${profileProvider.userInfoModel?.point ?? 0} ${getTranslated('points', context)}',
                                                            style: rubikBold
                                                                .copyWith(
                                                              fontSize: 28,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                          getTranslated(
                                                              'earn_more_points',
                                                              context)!,
                                                          style: rubikRegular
                                                              .copyWith(
                                                            fontSize: 14,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.9),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Image.asset(
                                                    Images.loyaltyTopIcon,
                                                    height: 80,
                                                    width: 80,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 24),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    walletProvider
                                                        .setCurrentTabButton(0);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 16),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                    ),
                                                    elevation: 0,
                                                  ),
                                                  child: Text(
                                                    getTranslated(
                                                        'convert_point',
                                                        context)!,
                                                    style:
                                                        rubikSemiBold.copyWith(
                                                      fontSize: 16,
                                                      color: Colors.orange,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeDefault),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            _tabButton(
                                                title: 'earning',
                                                index: 1,
                                                walletProvider: walletProvider),
                                            _tabButton(
                                                title: 'converted',
                                                index: 2,
                                                walletProvider: walletProvider),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SliverFillRemaining(
                          hasScrollBody: true,
                          child: RefreshIndicator(
                            onRefresh: () async {
                              walletProvider.getLoyaltyTransactionList(
                                  '1', true, false,
                                  isEarning:
                                      walletProvider.selectedTabButtonIndex ==
                                          1);
                              profileProvider.getUserInfo(true);
                            },
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: Dimensions.webScreenWidth,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (walletProvider
                                                .selectedTabButtonIndex ==
                                            0)
                                          const ConvertMoneyWidget(),
                                        if (walletProvider
                                                .selectedTabButtonIndex !=
                                            0)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeDefault),
                                            child: Center(
                                              child: SizedBox(
                                                width:
                                                    Dimensions.webScreenWidth,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          top: Dimensions
                                                              .paddingSizeExtraLarge),
                                                      child: TitleWidget(
                                                        title: getTranslated(
                                                            walletProvider
                                                                        .selectedTabButtonIndex ==
                                                                    1
                                                                ? 'point_earning_history'
                                                                : 'point_converted_history',
                                                            context),
                                                      ),
                                                    ),

                                                    // List
                                                    walletProvider
                                                                .transactionList !=
                                                            null
                                                        ? walletProvider
                                                                .transactionList!
                                                                .isNotEmpty
                                                            ? GridView.builder(
                                                                key:
                                                                    UniqueKey(),
                                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisSpacing:
                                                                        20,
                                                                    mainAxisExtent:
                                                                        100,
                                                                    crossAxisCount:
                                                                        ResponsiveHelper.isMobile()
                                                                            ? 1
                                                                            : 2),
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    walletProvider
                                                                        .transactionList!
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return Stack(
                                                                    children: [
                                                                      HistoryItemWidget(
                                                                        index:
                                                                            index,
                                                                        formEarning:
                                                                            walletProvider.selectedTabButtonIndex ==
                                                                                1,
                                                                        data: walletProvider
                                                                            .transactionList,
                                                                      ),
                                                                      if (walletProvider
                                                                              .paginationLoader &&
                                                                          walletProvider.transactionList!.length ==
                                                                              index +
                                                                                  1)
                                                                        const Center(
                                                                            child:
                                                                                CircularProgressIndicator()),
                                                                    ],
                                                                  );
                                                                })
                                                            : CustomNoDataWidget(
                                                                isEarning:
                                                                    walletProvider
                                                                            .selectedTabButtonIndex ==
                                                                        1)
                                                        : WalletShimmer(
                                                            walletProvider:
                                                                walletProvider),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (ResponsiveHelper.isDesktop(context))
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15),
                                      child: const FooterWidget(),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _tabButton(
      {required String title,
      required int index,
      required WalletProvider walletProvider}) {
    final isActive = walletProvider.selectedTabButtonIndex == index;
    return InkWell(
      onTap: () => walletProvider.setCurrentTabButton(index),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeLarge),
            child: Text(
              getTranslated(title, context)!,
              style: rubikMedium.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: isActive ? Colors.orange : Colors.black),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Container(
            height: 2,
            width: 60,
            color: isActive ? Colors.orange : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

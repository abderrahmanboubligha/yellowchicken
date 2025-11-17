import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_restaurant/features/wallet/widgets/add_fund_dialogue_widget.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';

class WalletHeaderWidget extends StatelessWidget {
  final bool webHeader;
  final JustTheController? tooltipController;

  const WalletHeaderWidget(
      {super.key, this.webHeader = false, this.tooltipController});

  @override
  Widget build(BuildContext context) {
    bool isAddFund = Provider.of<SplashProvider>(context, listen: false)
            .configModel
            ?.isAddFundToWallet ??
        false;

    return Container(
      decoration: BoxDecoration(
        borderRadius: webHeader
            ? BorderRadius.circular(Dimensions.radiusDefault)
            : const BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
        color: Theme.of(context).primaryColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeDefault,
        horizontal: Dimensions.paddingSizeLarge,
      ),
      child: SafeArea(
        child:
            Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                // Current Balance Section with Yellow Background
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTranslated('current_balance', context) ??
                              'Current Balance',
                          style: rubikRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: const Color(0xFF6B4423),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              profileProvider.isLoading
                                  ? const SizedBox()
                                  : CustomDirectionalityWidget(
                                      child: Text(
                                        PriceConverterHelper.convertPrice(
                                            profileProvider.userInfoModel
                                                    ?.walletBalance ??
                                                0),
                                        style: rubikBold.copyWith(
                                          fontSize: 28,
                                          color: const Color(0xFF6B4423),
                                        ),
                                      ),
                                    ),
                            ]),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        // Top Up Button
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: isAddFund
                                ? () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const AddFundDialogueWidget());
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9800),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              disabledBackgroundColor: Colors.grey,
                            ),
                            child: Text(
                              getTranslated('top_up', context) ?? 'Top up',
                              style: rubikSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ]);
        }),
      ),
    );
  }
}

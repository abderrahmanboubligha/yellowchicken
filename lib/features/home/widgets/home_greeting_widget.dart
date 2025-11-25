import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class HomeGreetingWidget extends StatelessWidget {
  const HomeGreetingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeLarge,
        vertical: Dimensions.paddingSizeDefault,
      ),
      child: Center(
        child: SizedBox(
          width: Dimensions.webScreenWidth,
          child: Consumer<ProfileProvider>(
            builder: (context, profileProvider, _) {
              final userName = profileProvider.userInfoModel?.fName ?? 'Guest';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting text
                  Text(
                    '${getTranslated("hello", context)} $userName',
                    style: rubikMedium.copyWith(
                      fontSize: 28,
                      color: const Color(0xFF4B1E00),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Removed location prompt
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

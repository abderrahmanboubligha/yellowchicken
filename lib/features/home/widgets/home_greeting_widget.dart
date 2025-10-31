import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
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
                    'Hello $userName',
                    style: rubikMedium.copyWith(
                      fontSize: 28,
                      color: const Color(0xFF4B1E00),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Location prompt
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: const Color(0xFF4B1E00).withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Please allow location access in Settings',
                        style: rubikRegular.copyWith(
                          fontSize: 14,
                          color: const Color(0xFF4B1E00).withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

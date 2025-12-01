import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class ProfileOverviewScreen extends StatefulWidget {
  const ProfileOverviewScreen({super.key});

  @override
  State<ProfileOverviewScreen> createState() => _ProfileOverviewScreenState();
}

class _ProfileOverviewScreenState extends State<ProfileOverviewScreen> {
  String currentView = 'profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  if (currentView == 'more')
                    GestureDetector(
                      onTap: () => setState(() => currentView = 'profile'),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.chevron_left,
                          color: Theme.of(context).hintColor,
                          size: 22,
                        ),
                      ),
                    ),
                  Text(
                    currentView == 'profile' ? 'Profile' : 'More',
                    style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),
                ],
              ),
            ),
            Expanded(
              child: currentView == 'profile'
                  ? _buildProfileView(context)
                  : _buildMoreView(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.08),
            ),
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
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
                  child: const Icon(Icons.person_outline, size: 56),
                ),
                const SizedBox(height: 16),
                Text('Account', style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('General', style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                const SizedBox(height: 16),

                // This opens the OLD Profile screen
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline,
                  label: 'Profile',
                  onTap: () => RouterHelper.getProfileRoute(),
                ),

                _buildMenuItem(context, icon: Icons.card_giftcard, label: 'Royalty Point'),
                _buildMenuItem(context, icon: Icons.account_balance_wallet_outlined, label: 'Wallet'),
                _buildMenuItem(context, icon: Icons.notifications_none, label: 'Notification'),
                _buildMenuItem(context, icon: Icons.location_on_outlined, label: 'Address'),
                _buildMenuItem(context, icon: Icons.local_offer_outlined, label: 'Coupon'),
                _buildMenuItem(context, icon: Icons.group_outlined, label: 'Refer & Earn'),
                _buildMenuItem(context, icon: Icons.language, label: 'Language'),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => setState(() => currentView = 'more'),
                    child: Text('More', style: rubikMedium.copyWith(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreView(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('More', style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
            const SizedBox(height: 16),
            _buildMenuItem(context, icon: Icons.info_outline, label: 'About us'),
            _buildMenuItem(context, icon: Icons.support_agent_outlined, label: 'Help & Support'),
            _buildMenuItem(context, icon: Icons.description_outlined, label: 'Terms & Conditions'),
            _buildMenuItem(context, icon: Icons.privacy_tip_outlined, label: 'Privacy & Policy'),
            _buildMenuItem(context, icon: Icons.logout, label: 'Log Out'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String label, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: rubikMedium.copyWith(
                    color: Colors.black,
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Theme.of(context).hintColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
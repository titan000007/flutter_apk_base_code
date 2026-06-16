import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/features/profile_section/view/PrivacyPolicyScreen.dart';
import 'package:uber_boats_customer/app/features/profile_section/view/TermsConditionsScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../main.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/shared_preferences.dart';
import '../controllers/profile_controller.dart';
import '../controllers/profile_controllers.dart';
import '../widgets/profile_listing_card.dart';
import 'account_setting_screen.dart';
import 'change_password.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileControllers profileC = Get.put(ProfileControllers());
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 25),

              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        '${sp?.getString(SpUtil.userImage) ?? profileController.profileImageUrl.value}',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            AppImages.dummyUser,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${sp?.getString(SpUtil.userName) ?? profileController.userDetails.value?.fullName!}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColor.gradientSecondColor,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${sp?.getString(SpUtil.userEmail) ?? profileController.userDetails.value?.email!}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColor.gradientSecondColor,
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              ProfileListingCard(
                icon: AppImages.editProfileIcon,
                title: AppString.accountSetting,
                onTap: () {
                  Get.to(() => const AccountSettingScreen());
                },
              ),

              ProfileListingCard(
                icon: AppImages.privacyPolicyIcon,
                title: AppString.privacyPolicy,
                onTap: () async {
                  Get.to(() => const PrivacyPolicyScreen());
                },
              ),

              ProfileListingCard(
                icon: AppImages.termsConditionIcon,
                title: AppString.termsAndCondition,
                onTap: () async {
                  Get.to(() => const TermsConditionsScreen());
                  // final Uri url = Uri.parse('https://google.com');
                  //
                  // await launchUrl(url, mode: LaunchMode.platformDefault);
                },
              ),
              ProfileListingCard(
                icon: AppImages.forgotIcon,
                title: AppString.changePassword,
                onTap: () {
                  Get.to(() => const ChangePasswordScreen());
                },
              ),
              ProfileListingCard(
                icon: AppImages.logoutIcon,
                title: AppString.signOut,
                onTap: () {
                  profileC.onLogOut();
                },
              ),

              InkWell(
                onTap: () {
                  profileC.onDeleteAccount();
                },
                child: Text(
                  AppString.deleteAccount,
                  style: TextStyle(
                    color: AppColor.hintTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

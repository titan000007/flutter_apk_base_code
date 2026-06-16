import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/features/dashboard/controller/dashboard_controller.dart';
import '../../../../../common_widgets/common_button_widget.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_images.dart';
import '../../../../../utils/app_string.dart';
import '../../../dashboard/view/dashboard_screen.dart';

class EnableGPSLocationScreen extends StatefulWidget {
  const EnableGPSLocationScreen({super.key});

  @override
  State<EnableGPSLocationScreen> createState() =>
      _EnableGPSLocationScreenState();
}

class _EnableGPSLocationScreenState extends State<EnableGPSLocationScreen> {
  final dashboardC = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 110),

              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.gradientFirstColor.withValues(alpha: .10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Image.asset(AppImages.boxIconsLocation),
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                AppString.enableGpsLocation,
                style: TextStyle(
                  color: AppColor.appBlackColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  AppString.enableGpsLocationHintText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColor.hintTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 30),

              // Info Box
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColor.gradientFirstColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    width: .5,
                    color: AppColor.gradientSecondColor.withValues(alpha: .10),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(AppImages.shieldTick, height: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppString.yourLocationIsOnlySharedText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColor.hintTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Allow Location Button
              // Obx(() {
              //   return CommonButton(
              //     text: dashboardC.isLocationEnabled.value ? AppString.backToHome :AppString.allowLocationAccess,
              //     onPressed: () async {
              //       if (dashboardC.isLocationEnabled.value == false) {
              //         dashboardC.setPermissionAndGetLocation();
              //       } else if (dashboardC.isLocationEnabled.value == true) {
              //         WidgetsBinding.instance.addPostFrameCallback((_) {
              //           Get.offAll(() => const DashboardScreen());
              //         });
              //       }
              //     },
              //     loading: dashboardC.isFetchLocationLoading.value,
              //   );
              // }),

              CommonButton(
                text: AppString.allowLocationAccess,
                onPressed: () async {
                  bool hasAccess = await dashboardC.getGPSandLocationStaus();
                  if (hasAccess) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Get.offAll(() =>  DashboardScreen());
                    });
                  } else {
                    dashboardC.setPermissionAndGetLocation();
                  }
                },

                loading: false,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

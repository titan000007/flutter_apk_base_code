import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/features/auth/login/view/login_screen.dart';
import 'package:uber_boats_customer/common_widgets/common_button_widget.dart';
import 'package:uber_boats_customer/utils/app_color.dart';
import 'package:uber_boats_customer/utils/app_images.dart';

import '../../register/view/register_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image + Dark Overlay
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.getStarted),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: AppColor.appBlackColor.withValues(
                alpha: 0.55,
              ), // Better approach
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const Spacer(),

                // Logo Text
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                    children: const [
                      TextSpan(
                        text: 'Uber',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'For',
                        style: TextStyle(color: AppColor.cDAB565),
                      ),
                      TextSpan(
                        text: 'Boats',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Subtitle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Food, Fuel, & Essentials Delivered to Your Boat on Water from Businesses up to 50 Miles Inland",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.whiteColor.withValues(alpha: .8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 30),


                // Button
                CommonButton(
                  elevation: 0,
                  text: "Get Started",
                  loading: false,
                  showBorder: false,
                  onPressed: () {
                    Get.to(RegisterScreen());
                  },
                  height: 56,
                  radius: 30,
                ),

                const SizedBox(height: 20),

                // Login Row
                InkWell(
                  onTap: () {
                    Get.to(LoginScreen());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Have an account ? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.whiteColor.withValues(alpha: .8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.whiteColor,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          decorationThickness: 1.0,
                          decorationStyle: TextDecorationStyle.solid,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Platform.isAndroid ? 60 : 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

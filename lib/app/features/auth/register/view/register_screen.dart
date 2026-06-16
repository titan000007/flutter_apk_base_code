import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/utils/app_images.dart';
import '../../../../../common_widgets/common_button_widget.dart';
import '../../../../../common_widgets/common_text_field.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_string.dart';
import '../../login/view/login_screen.dart';
import '../controllers/register_controller.dart';
import '../../../../app_widget/gradient_text.dart';
import 'create_profile_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,
      body: SafeArea(
        top: false,
        child: Form(
          key: controller.registerFormKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 60),

                Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    AppImages.appSecondLogo,
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(height: 10),
                // Title
                Text(
                  AppString.createYourAccount,
                  style: TextStyle(
                    color: AppColor.appBlackColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppString.joinTheFleet,
                  style: TextStyle(
                    color: AppColor.c4F6778,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 30),

                // Email Label
                Text(
                  AppString.email,
                  style: TextStyle(
                    color: AppColor.appBlackColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),

                CommonTextField(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      AppImages.icBaselineEmail,
                      height: 20,
                      width: 20,
                    ),
                  ),
                  controller: controller.emailController,
                  hintText: "Your@gmail.com",
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return AppString.pleaseEnterEmail;
                    }
                    if (!GetUtils.isEmail(v)) {
                      return AppString.pleaseEnterValidEmail;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),
                // Password
                Text(
                  AppString.password,
                  style: TextStyle(
                    color: AppColor.appBlackColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),

                // Password Field
                CommonPasswordField(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      AppImages.materialSymbolsLock,
                      height: 20,
                      width: 20,
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  controller: controller.passwordController,
                  hintText: AppString.createStrongPassword,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return AppString.pleaseEnterPassword;
                    }
                    if (v.length < 6) {
                      return AppString.pleaseEnterValidPassword;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 150),

                // Send OTP Button
                Obx(
                  () => CommonButton(
                    text: AppString.continueText,
                    onPressed: () {
                      controller.registerFormValidation.value =
                          AutovalidateMode.onUserInteraction;
                      if (controller.registerFormKey.currentState?.validate() ??
                          false) {
                        controller.register();
                      }
                    },
                    loading: controller.isRegisterLoading.value,
                  ),
                ),

                SizedBox(height: 120),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppString.haveAnAccount,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.c4F6778,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Get.to(LoginScreen());
                      },
                      child: GradientText(
                        text: AppString.logIn,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

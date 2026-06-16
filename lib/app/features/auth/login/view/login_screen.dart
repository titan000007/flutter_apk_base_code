import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/utils/app_images.dart';
import '../../../../../common_widgets/common_button_widget.dart';
import '../../../../../common_widgets/common_text_field.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_string.dart';
import '../../../dashboard/view/dashboard_screen.dart';
import '../../forgot_password/view/forgot_screen.dart';
import '../../register/view/register_screen.dart';
import '../controllers/login_controller.dart';
import '../widgets/gradient_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,
      body: SafeArea(
        top: false,
        child: Form(
          key: controller.loginFormKey,
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
                  AppString.welcomeBack,
                  style: TextStyle(
                    color: AppColor.appBlackColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppString.signInToContinue,
                  style: TextStyle(
                    color: AppColor.hintTextColor,
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

                // Email Field
                CommonTextField(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      AppImages.icBaselineEmail,
                      height: 20,
                      width: 20,
                    ),
                  ),
                  controller: controller.loginEmailController,
                  hintText: "Your@gmail.com",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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

                const SizedBox(height: 16),
                //Password
                Text(
                  AppString.password,
                  style: TextStyle(
                    color: AppColor.appBlackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),

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
                  controller: controller.loginPasswordController,
                  hintText: AppString.enterPassword,
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
                SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    Get.to(() => ForgotScreen());
                  },
                  child: Text(
                    AppString.forgotPassword,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: AppColor.errorColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 150),

                // ── Send OTP Button ──────────────────────────────────
                Obx(
                  () => CommonButton(
                    text: AppString.signIn,
                    onPressed: () {
                      controller.loginFormValidation.value =
                          AutovalidateMode.onUserInteraction;
                      if (controller.loginFormKey.currentState?.validate() ??
                          false) {
                        controller.login();
                      }
                    },
                    loading: controller.isLoginLoading.value,
                  ),
                ),

                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppString.dontHaveAnAccount,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColor.c4F6778,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Get.to(RegisterScreen());
                      },
                      child: GradientText(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        text: AppString.signUp,
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

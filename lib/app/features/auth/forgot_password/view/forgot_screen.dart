import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../common_widgets/common_button_widget.dart';
import '../../../../../../common_widgets/common_text_field.dart';
import '../../../../../../utils/app_color.dart';
import '../../../../../../utils/app_images.dart';
import '../../../../../../utils/app_string.dart';
import '../controllers/forgot_controller.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final ForgotController controller = Get.put(ForgotController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
          child: CommonButton(
            text: AppString.sendLinkToEmail,
            onPressed: () {
              controller.forgotFormValidation.value =
                  AutovalidateMode.onUserInteraction;
              if (controller.forgotFormKey.currentState?.validate() ?? false) {
                controller.forgotPassword();
              }
            },
            loading: controller.isForgotPasswordLoading.value,
          ),
        ),
      ),

      backgroundColor: AppColor.pageBackground,
      body: SafeArea(
        top: false,
        child: Obx(
          () => Form(
            key: controller.forgotFormKey,
            autovalidateMode: controller.forgotFormValidation.value,
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
                    AppString.forgotPassword,
                    style: TextStyle(
                      color: AppColor.appBlackColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppString.weWillSendLink,
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
                    controller: controller.forgotPasswordController,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/app_widget/common_app_bar.dart';
import '../../../../../common_widgets/common_button_widget.dart';
import '../../../../../common_widgets/common_text_field.dart';
import '../../../../../utils/app_color.dart';
import '../../../../utils/app_string.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChangePasswordController changePasswordC = Get.put(
    ChangePasswordController(),
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            SizedBox(height: 46),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: CommonAppBar(title: AppString.changePassword),
            ),

            Expanded(
              child: Obx(() {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior().copyWith(
                            overscroll: false,
                          ),
                          child: ListView(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            children: [
                              Text(
                                AppString.currentPassword,
                                style: TextStyle(
                                  color: AppColor.appBlackColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10),
                              CommonPasswordField(
                                controller:
                                    changePasswordC.currentPasswordController,
                                hintText: "* * * * * * * * *",
                                validator:
                                    changePasswordC.validateCurrentPassword,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),

                              SizedBox(height: 15),

                              Text(
                                AppString.newPassword,
                                style: TextStyle(
                                  color: AppColor.appBlackColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10),
                              CommonPasswordField(
                                controller:
                                    changePasswordC.newPasswordController,
                                hintText: "* * * * * * * * *",
                                validator: changePasswordC.validateNewPassword,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),

                              SizedBox(height: 15),

                              Text(
                                AppString.confirmPassword,
                                style: TextStyle(
                                  color: AppColor.appBlackColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10),
                              CommonPasswordField(
                                controller:
                                    changePasswordC.confirmPasswordController,
                                hintText: "* * * * * * * * *",
                                validator:
                                    changePasswordC.validateConfirmPassword,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                              SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
                        child: CommonButton(
                          text: AppString.updatePassword,
                          loading: changePasswordC.isChangePasswordLoading.value,
                          onPressed: changePasswordC.isChangePasswordLoading.value
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    changePasswordC.updatePassword();
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

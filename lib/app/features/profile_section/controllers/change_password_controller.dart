import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app_service/network/network_service.dart';
import '../../../../app_service/network/network_urls.dart';
import '../../../../utils/app_prompt.dart';
import '../../../../utils/app_string.dart';

class ChangePasswordController extends GetxController {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxBool isCurrentPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool isChangePasswordLoading = false.obs;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  String? validateCurrentPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppString.pleaseEnterValidPassword;
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter a new password";
    }
    if (value.length < 6) {
      return "New password must be at least 6 characters";
    }
    if (value == currentPasswordController.text.trim()) {
      return "New password must differ from current password";
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please confirm your new password";
    }
    if (value != newPasswordController.text.trim()) {
      return "Passwords do not match";
    }
    return null;
  }

  Future<void> updatePassword() async {
    try {
      isChangePasswordLoading.value = true;
      final body = {
        "currentPass": currentPasswordController.text.trim(),
        "newPass": newPasswordController.text.trim(),
      };

      final response = await NetworkService().postApiCall(
        url: NetworkUrl.changePassword,
        body: body,
      );

      if (response != null) {
        if (response != null && response['statusCode'] == 200) {
          showAppToast(isForError: false, msg: response['msg'] ?? "");
          Get.back();
        } else {
          showAppToast(isForError: true, msg: response['msg'] ?? "");
        }
      }
    } catch (e) {
      showAppToast(msg: e.toString(), isForError: true);
    } finally {
      isChangePasswordLoading.value = false;
    }
  }
}

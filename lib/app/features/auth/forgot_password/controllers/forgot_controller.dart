import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../app_service/network/network_service.dart';
import '../../../../../app_service/network/network_urls.dart';
import '../../../../../utils/app_prompt.dart';

class ForgotController extends GetxController {
  Rx<AutovalidateMode> forgotFormValidation = AutovalidateMode.disabled.obs;
  GlobalKey<FormState> forgotFormKey = GlobalKey<FormState>();

  final TextEditingController forgotPasswordController =
      TextEditingController();

  RxBool isForgotPasswordLoading = false.obs;

  @override
  void onClose() {
    forgotPasswordController.dispose();
    super.onClose();
  }

  Future<void> forgotPassword() async {
    isForgotPasswordLoading.value = true;
    try {
      final response = await NetworkService().postApiCall(
        url: NetworkUrl.forgotPassword,
        body: {
          "email": forgotPasswordController.text.trim(),
          "type": "user", // admin/user/driver
        },
      );

      if (response != null && response['statusCode'] == 200) {
        showAppToast(
          isForError: false,
          msg: response['message'] ?? "Reset link send successfully",
        );
        Get.back();
      } else {
        showAppToast(
          isForError: true,
          msg: response?['message'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      showAppToast(isForError: true, msg: 'Error: $e');
    } finally {
      isForgotPasswordLoading.value = false;
    }
  }
}

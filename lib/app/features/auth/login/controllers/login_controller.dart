import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../app_service/network/network_service.dart';
import '../../../../../app_service/network/network_urls.dart';
import '../../../../../main.dart';
import '../../../../../utils/app_log.dart';
import '../../../../../utils/app_prompt.dart';
import '../../../../../utils/app_string.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../utils/shared_preferences.dart';
import '../../../dashboard/view/dashboard_screen.dart';
import '../../register/view/create_profile_screen.dart';
import '../model/login_model.dart';

class LoginController extends GetxController {
  Rx<AutovalidateMode> loginFormValidation = AutovalidateMode.disabled.obs;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  RxBool isLoginLoading = false.obs;

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    isLoginLoading.value = true;
    try {
      final response = await NetworkService().postApiCall(
        url: NetworkUrl.login,
        body: {
          "email": loginEmailController.text.trim(),
          "password": loginPasswordController.text.trim(),
        },
      );

      if (response != null && response['statusCode'] == 200) {
        LoginModel apiResponse = LoginModel.fromJson(response);

        sp!.putString(
          SpUtil.userEmail,
          apiResponse.data?.userData?.email ?? loginEmailController.text.trim(),
        );
        await sp?.putString(SpUtil.accessToken, apiResponse.data?.token ?? "");
        await sp?.putString(
          SpUtil.userID,
          apiResponse.data?.userData?.id ?? "",
        );

        if (apiResponse.data?.userData?.fullName != null &&
            (apiResponse.data?.userData?.fullName?.isNotEmpty ?? false)) {
          await sp?.putBool(SpUtil.isLoggedIn, true);
          await sp?.putString(
            SpUtil.userName,
            apiResponse.data?.userData?.fullName ?? '',
          );
          await sp?.putString(
            SpUtil.userImage,
            apiResponse.data?.userData?.profileimage ?? '',
          );
          await sp?.putString(
            SpUtil.userPhone,
            apiResponse.data?.userData?.mobile ?? '',
          );
          await AppUtils.saveFcmToken();
          await AppUtils.updateFcmTokenApi();
          showAppToast(isForError: false, msg: apiResponse.msg);
          Get.offAll(() => const DashboardScreen());
        } else {
          Get.offAll(() => const CreateProfileScreen());
        }
      }
    } catch (e) {
      isLoginLoading.value = false;
      showAppToast(isForError: true, msg: 'Error: $e');
    } finally {
      isLoginLoading.value = false;
    }
  }
}

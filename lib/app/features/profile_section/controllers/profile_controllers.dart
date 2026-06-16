import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app_service/network/network_service.dart';
import '../../../../app_service/network/network_urls.dart';
import '../../../../common_widgets/my_dialog.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_prompt.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/app_utils.dart';
import '../../auth/login/view/login_screen.dart';

class ProfileControllers extends GetxController {

  Future<void> logOutUserApiCall() async {
    try {
      final response = await NetworkService().getApiCall(
        url: NetworkUrl.logoutUrl,
      );

      if (response != null && response['statusCode'] == 200) {
        await AppUtils.logOut();
        showAppToast(msg: response['msg'] ?? "Logged out successfully");
        Get.offAll(const LoginScreen());
      } else {
        showAppToast(
          msg: response?['msg'] ?? "Failed to logout",
          isForError: true,
        );
      }
    } catch (e) {
      showAppToast(msg: e.toString(), isForError: true);
    }
  }

  Future<void> deleteAccountApi() async {
    try {
      final response = await NetworkService().getApiCall(
        url: NetworkUrl.deleteAccountUrl,
      );

      if (response != null &&
          (response['status'] == "success" || response['statusCode'] == 200)) {
        await AppUtils.logOut();

        showAppToast(msg: response['msg'] ?? "Account deleted successfully");

        Get.offAll(() => const LoginScreen());
      } else {
        showAppToast(
          msg: response?['msg'] ?? "Failed to delete account",
          isForError: true,
        );
      }
    } catch (e) {
      showAppToast(msg: e.toString(), isForError: true);
    }
  }

  void onLogOut() {
    Get.dialog(
      MyDialog(
        isLoading: false,
        title: AppString.signOut,
        description: AppString.areYouSureYouWantToLogout,
        icon: const Icon(Icons.login_outlined, color: AppColor.whiteColor),
        onPress: () {
          logOutUserApiCall();
        },
      ),
    );
  }

  void onDeleteAccount() {
    Get.dialog(
      MyDialog(
        isLoading: false,
        title: AppString.deleteAccount,
        description: AppString.areYouSureYouWantToDeleteAccount,
        icon: const Icon(Icons.delete_outline, color: AppColor.whiteColor),
        onPress: () {
          deleteAccountApi();
        },
      ),
    );
  }
}

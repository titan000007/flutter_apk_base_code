import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:uber_boats_customer/app_service/network/network_service.dart';
import 'package:uber_boats_customer/app_service/network/network_urls.dart';
import 'package:uber_boats_customer/utils/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import 'app_log.dart';

class AppUtils {
static Future<void> logOut() async {
    AppLog.printLog("LogOut");
    try {
      final userId = sp?.getString(SpUtil.userID);
      if (userId != null && userId.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('chat_rooms')
            .doc(userId)
            .set({'fcmToken': FieldValue.delete()}, SetOptions(merge: true));
        AppLog.printLog(" FCM token deleted from Firestore for logout");
      }
    } catch (e) {
      AppLog.printLog("Error deleting FCM token on logout: $e");
    }
    await sp!.clear();
    sp = await SpUtil.getInstance();
    /// DELETE ALL CONTROLLERS
    await Get.deleteAll(force: true);
    AppLog.printLog("Access Token ===> ${sp!.getString(SpUtil.accessToken)}");
  }

  static bool checkUserLogin() {
    bool isLoggedIn = sp!.getBool(SpUtil.isLoggedIn) ?? false;
    return isLoggedIn;
  }

  // General

  static String toTitleCase(String value) {
    return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  }

  static int randomNumber() {
    var rng = Random();
    return rng.nextInt(90000000);
  }

  // Date Formatters

  static String convertDateYYYYMMDD(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  /// Convert API date string into dd MMM yyyy format
  static String formatDateDMY(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyy').format(date);
    } catch (e) {
      return "";
    }
  }

  /// Convert API UTC date string into "dd MMM yyyy at hh:mm a" (local time)
  static String formatDateTimeLocal(String dateString) {
    try {
      final utcDate = DateTime.parse(dateString);
      final localDate = utcDate.toLocal();
      return DateFormat('dd MMM yyyy \'at\' hh:mm a').format(localDate);
    } catch (e) {
      return "";
    }
  }

  /// Convert API date string into dd/MM/yyyy format
  static String formatDateDMYSecond(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return "";
    }
  }


  static Future<void> saveFcmToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await sp!.putString(SpUtil.deviceFcmToken, token);
        AppLog.printLog("FCM Token saved locally: $token");
      }
    } catch (e) {
      AppLog.printLog("Error getting FCM token: $e");
    }
  }

  static Future<void> updateFcmTokenApi() async {
    String? token = sp!.getString(SpUtil.deviceFcmToken);
    if (token != null && token.isNotEmpty) {
      try {
        // Update Backend API
        final response = await NetworkService().postApiCall(
          url: NetworkUrl.updateUserDetails,
          body: {"fcmToken": token},
        );
        AppLog.printLog('fcm token update ::: ${token.toString()}');
        if (response != null &&
            (response['statusCode'] == 200 || response['success'] == true)) {
          AppLog.printLog("FCM Token updated on server successfully");
        }

        // Update Firestore for Chat
        final userId = sp?.getString(SpUtil.userID);
        if (userId != null && userId.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('chat_rooms')
              .doc(userId)
              .set({'fcmToken': token}, SetOptions(merge: true));
          AppLog.printLog(" FCM token synced to Firestore for: $userId");
        }
      } catch (e) {
        AppLog.printLog("Error updating FCM token: $e");
      }
    }
  }
}

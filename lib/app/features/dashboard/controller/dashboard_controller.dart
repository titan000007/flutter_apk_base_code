import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart'
    hide PermissionStatus;
import '../../../../app_service/network/network_service.dart';
import '../../../../app_service/network/network_urls.dart';
import '../../../../main.dart';
import '../../../../utils/app_log.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/shared_preferences.dart';
import '../../profile_section/controllers/profile_controller.dart';

class DashboardController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final location = Location();
  var userLatitude = 0.0.obs;
  var userLongitude = 0.0.obs;
  //This for button on Manage location screen
  RxBool isFetchLocationLoading = false.obs;
  //This Flag will only turn True when both GPS and Location permission is allowed by user
  var isLocationEnabled = false.obs;
//This Flag is for device GPS sensor
  bool GPSServiceEnabled = false;
  //This Flag is for App user location permission
  PermissionStatus hasLocationPermissions = PermissionStatus.denied;

  @override
  void onInit() {
    super.onInit();
    AppLog.printLog("FCM TOKEN ${sp!.getString(SpUtil.deviceFcmToken) ?? ""}");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AppUtils.updateFcmTokenApi();
    });
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  Future<void> setPermissionAndGetLocation() async {
    try {
      GPSServiceEnabled = await location.serviceEnabled();

      if (!GPSServiceEnabled) {
        GPSServiceEnabled = await location.requestService();
        return;
      }

      hasLocationPermissions = await location.hasPermission();

      if (hasLocationPermissions == loc.PermissionStatus.denied) {
        hasLocationPermissions = await location.requestPermission();
      }

      if (hasLocationPermissions == loc.PermissionStatus.deniedForever) {
        AppLog.printLog(
          'Permission permanently denied. Redirecting to settings.',
        );
        await openAppSettings();
        isLocationEnabled.value = false;
      }

      if (GPSServiceEnabled &&
          hasLocationPermissions == loc.PermissionStatus.granted) {
        try {
          isFetchLocationLoading.value = true;
          loc.LocationData locationData = await location.getLocation();
          userLatitude.value = locationData.latitude ?? 0.0;
          userLongitude.value = locationData.longitude ?? 0.0;
          isLocationEnabled.value = true;
          isFetchLocationLoading.value = false;
          AppLog.printLog(
            'User location: (${userLatitude.value}, ${userLongitude.value})',
          );
        } catch (e) {
          AppLog.printLog('Error getting location: $e');
          isLocationEnabled.value = false;
          isFetchLocationLoading.value = false;
        }
      } else {
        isLocationEnabled.value = false;
        isFetchLocationLoading.value = false;
        AppLog.printLog('Location permission not granted or service disabled');
      }
    } catch (e) {
      AppLog.printLog('Error in setPermissionAndGetLocation: $e');
      isLocationEnabled.value = false;
      isFetchLocationLoading.value = false;
    }
  }

  Future<bool> getGPSandLocationStaus() async {
    try {
      GPSServiceEnabled = await location.serviceEnabled();
      hasLocationPermissions = await location.hasPermission();

      if (GPSServiceEnabled && hasLocationPermissions == loc.PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

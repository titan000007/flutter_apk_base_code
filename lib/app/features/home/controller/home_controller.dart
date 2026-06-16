import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../auth/register/view/enable_location_screen.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import 'package:location/location.dart' as loc;

class HomeController extends GetxController {
  DashboardController dashboardC = Get.find();

  @override
  void onInit() {
    super.onInit();
    // if (!dashboardC.isLocationEnabled.value) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Get.to(() => const EnableGPSLocationScreen());
    //   });
    //
    // }
  }
}

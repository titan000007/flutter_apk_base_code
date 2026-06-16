import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/features/home/controller/home_controller.dart';
import 'package:uber_boats_customer/app/features/home/view/widgets/how_it_work_card.dart';
import 'package:uber_boats_customer/common_widgets/common_button_widget.dart';
import 'package:uber_boats_customer/utils/shared_preferences.dart';
import '../../../../main.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_log.dart';
import '../../../../utils/app_string.dart';
import '../../auth/register/view/enable_location_screen.dart';
import '../../create_order/view/create_order_screen.dart';
import '../../dashboard/controller/dashboard_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeC = Get.put(HomeController());
  DashboardController dashboardC = Get.find();

  String userName = sp?.getString(SpUtil.userName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 50,
                    bottom: 90,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF0D3B5E), Color(0xFF1A7A8A)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 52,
                                width: 42,
                                decoration: BoxDecoration(),
                                child: Image(
                                  image: const AssetImage(AppImages.appLogo),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppString.uberForBoats,
                                    style: TextStyle(
                                      color: AppColor.whiteColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    AppString.deliveriesAtSeaDescription,
                                    style: TextStyle(
                                      color: AppColor.whiteColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                sp?.getString(SpUtil.userImage),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Greeting
                      Text(
                        "${AppString.hello}, ${userName.capitalizeFirst}! 👋",
                        style: TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        AppString.whatDoYouNeedDeliveredBoatText,
                        style: TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: -60,
                  left: 20,
                  right: 20,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppString.createNewOrder,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.appColor,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  AppString.foodGroceryFuelMoreText,
                                  style: TextStyle(
                                    color: AppColor.hintTextColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const Image(
                              image: AssetImage(AppImages.icBag),
                              height: 20,
                              width: 20,
                              color: AppColor.hintTextColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        CommonButton(
                          text: AppString.createOrder,
                          icon: AppImages.icPlus,
                          iconColor: AppColor.whiteColor,
                          isIconShow: true,
                          onPressed: () {
                            // AppLog.printLog("Create Order button pressed");
                            //  Get.to(() => const CreateOrderScreen());
                          },
                          loading: false,
                          radius: 12,
                          height: 42,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () async {
                bool hasAccess = await dashboardC.getGPSandLocationStaus();
                if (hasAccess) {
                  // This function fetches current Lat long of user and store in variable
                  dashboardC.setPermissionAndGetLocation();
                  Get.to(() => const CreateOrderScreen());
                } else {
                  Get.to(() => const EnableGPSLocationScreen());
                }
              },
              child: Row(children: [SizedBox(height: 40)]),
            ),

            const SizedBox(height: 20),

            // ─── HOW IT WORKS SECTION ──────────────────────────────────
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 28, bottom: 12),
              child: Text(
                "How it works",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),

            // ─── CARD 1: Add what you need ─────────────────────────────
            HowItWorkCard(
              image: AppImages.icBag,
              title: AppString.addWhatYouWant,
              description: AppString.screenShotsPhotosTextUrlNAdItemsMixText,
              backgroundColor: AppColor.b08BFF,
            ),
            HowItWorkCard(
              image: AppImages.icDrone,
              title: AppString.droneOrJetski,
              description: AppString.droneOrJetskiDescription,
              backgroundColor: AppColor.eDD02F,
            ),
            HowItWorkCard(
              image: AppImages.icTrackDeck,
              title: AppString.trackedToYourDeck,
              description: AppString.liveUpdatesFromShoreToSea,
              backgroundColor: AppColor.a81C62C,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

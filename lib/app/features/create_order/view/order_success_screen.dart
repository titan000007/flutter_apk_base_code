import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/features/dashboard/view/dashboard_screen.dart';
import '../../../../../../common_widgets/common_button_widget.dart';
import '../../../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_string.dart';
import '../controllers/create_order_controller.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {

  final controller = Get.find<CreateOrderController>();


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Get.offAll(() => const DashboardScreen());
      },
      child: Scaffold(
        backgroundColor: AppColor.pageBackground,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: SafeArea(
            top: false,
            child: CommonButton(
              text: AppString.backToHome,
              onPressed: () {
                Get.offAll(() => const DashboardScreen());
              },
              loading: false,
            ),
          ),
        ),

        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColor.a2A857E.withValues(alpha: .10),
                  ),
                  child: Image(
                    image: AssetImage(AppImages.searchIcon),
                    height: 60,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  textAlign: TextAlign.center,
                  AppString.orderRequestSubmitted,
                  style: TextStyle(
                    color: AppColor.hintTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  textAlign: TextAlign.center,
                  AppString.searchingForNearbyDeliveryPartner,
                  style: TextStyle(
                    color: AppColor.hintTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 30),

                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppString.total,
                            style: TextStyle(
                              color: AppColor.hintTextColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "\$${(controller.createOrderResponse.value!.order!.totalAmount! + controller.selectedTip.value).toStringAsFixed(2)}",
                            style: TextStyle(
                              color: AppColor.yellowColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(
                        thickness: 1,
                        height: 1,
                        color: AppColor.hintTextColor.withValues(alpha: .20),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppString.method,
                            style: TextStyle(
                              color: AppColor.hintTextColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            controller.createOrderResponse.value?.order?.deliveryType?.capitalizeFirst ?? "Drone",
                            style: TextStyle(
                              color: AppColor.appBlackColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

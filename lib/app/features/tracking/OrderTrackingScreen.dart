import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_images.dart';
import '../active_orders/controller/active_order_controller.dart';
import '../active_orders/model/activeOrderModel.dart';
import 'driver_card_widgets.dart';
import 'OrderTrackingController.dart';

class CustomerTrackingScreen extends StatefulWidget {
  const CustomerTrackingScreen({super.key});

  @override
  State<CustomerTrackingScreen> createState() => _CustomerTrackingScreenState();
}

class _CustomerTrackingScreenState extends State<CustomerTrackingScreen> {
  final ActiveOrderController orderController =
      Get.find<ActiveOrderController>();
  late CustomerTrackingController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      CustomerTrackingController(
        activeOrderData: orderController.selectedOrder.value!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        /// WAIT FOR GPS
        if (controller.customerPosition.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            // ── Full-screen Google Map ─────────────────────────────────
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: controller.customerPosition.value!,
                zoom: 15,
              ),

              markers: controller.markers.value,

              // polylines:
              // controller.polylines.value,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              onMapCreated: (mapController) {
                controller.googleMapController = mapController;
              },
            ),

            // ── Safe-area overlay ──────────────────────────────────────
            SafeArea(
              child: Column(
                children: [
                  // Top bar: back + title + LIVE badge
                  _TopBar(order: orderController.selectedOrder.value),

                  // Driver info card at bottom
                  if (orderController.selectedOrder.value?.driver != null)
                    DriverCard(
                      order: orderController.selectedOrder.value!,
                      onCall: controller.callDriver,
                      onMessage: controller.messageDriver,
                    ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _TopBar extends StatelessWidget {
  final ActiveOrders? order;

  const _TopBar({this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          GestureDetector(
            onTap: () {
              // Get.find<TrackOrderController>().deselectOrder();
              Get.back();
            },
            child: Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Image.asset(
                AppImages.arrowBack,
                height: 18,
                width: 18,
                color: AppColor.a374151,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 45,
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Live Tracking',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: AppColor.hintTextColor,
                          ),
                        ),
                        if (order != null)
                          Text(
                            "#${order?.orderNumber}",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColor.appBlackColor,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // LIVE badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.a10B981.withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 7,
                          width: 7,
                          decoration: const BoxDecoration(
                            color: AppColor.a10B981,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColor.a10B981,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

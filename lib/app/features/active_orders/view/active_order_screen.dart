import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_string.dart';
import '../../order_details/view/order_details_screen.dart';
import '../../tracking/OrderTrackingScreen.dart';
import '../controller/active_order_controller.dart';
import 'widgets/order_card_widget.dart';

class ActiveOrderScreen extends StatefulWidget {
  const ActiveOrderScreen({super.key});

  @override
  State<ActiveOrderScreen> createState() => _ActiveOrderScreenState();
}

class _ActiveOrderScreenState extends State<ActiveOrderScreen> {
  final controller = Get.put(ActiveOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.activeOrders.isEmpty) {
              return RefreshIndicator(
                color: AppColor.appColor,
                onRefresh: controller.refreshData,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: const Center(
                        child: Text(
                          'No active orders',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.appBlackColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // ── List with pagination ───────────────────────
            return RefreshIndicator(
              color: AppColor.appColor,
              onRefresh: controller.refreshData,
              child: ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                physics: const AlwaysScrollableScrollPhysics(),
                // +1 for header, +1 for load-more indicator
                itemCount: controller.activeOrders.length + 2,
                itemBuilder: (context, index) {
                  // ── Header ──────────────────────────────
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.activeOrders,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.appBlackColor,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "${controller.totalOrders.value} deliveries in progress",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: AppColor.c4F6778,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  }

                  final listIndex = index - 1; // o
                  /// LOAD MORE
                  if (listIndex == controller.activeOrders.length) {
                    return Obx(() {
                      if (controller.isMoreLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),

                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,

                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColor.appColor,
                              ),
                            ),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    });
                  }

                  final job = controller.activeOrders[listIndex];

                  return OrderCard(
                    onTap: () {
                      Get.to(OrderDetailsScreen(orderId: job.id ?? ""));
                    },
                    order: job,
                    onTrackTap: () async {
                      await controller.selectedOrder(job);
                      Get.to(() => CustomerTrackingScreen());
                      // Get.to(() => LiveTrackingScreen());
                    },
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}

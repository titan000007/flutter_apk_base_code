import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_color.dart';
import '../../../../utils/app_string.dart';
import '../../order_details/view/order_details_screen.dart';
import '../controller/order_history_controller.dart';
import 'widgets/order_history_card_widget.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final OrderHistoryController controller = Get.put(OrderHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColor.appColor),
              );
            }

            if (controller.completedOrders.isEmpty) {
              return RefreshIndicator(
                color: AppColor.appColor,
                onRefresh: controller.refreshData,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(
                        child: Text(
                          AppString.noOrderHistory,
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
                itemCount: controller.completedOrders.length + 2,
                itemBuilder: (context, index) {
                  // ── Header ──────────────────────────────
                  if (index == 0) {
                    return  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.orderHistory,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.appBlackColor,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          controller.historySubtitle,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: AppColor.hintTextColor,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  }

                  final listIndex = index - 1; // o
                  /// LOAD MORE
                  if (listIndex ==  controller.completedOrders.length) {
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

                  final job = controller.completedOrders[listIndex];
                  return OrderHistoryCard(
                    order: job,
                    onTap: () {
                      Get.to(OrderDetailsScreen(orderId: job.id ?? ""));
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

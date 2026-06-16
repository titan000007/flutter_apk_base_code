import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../common_widgets/back_button.dart';
import '../../../../common_widgets/common_button_widget.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/app_utils.dart';
import '../../../app_widget/common_app_bar.dart';
import '../../order_history/view/report_issue_screen.dart';
import '../controllers/Order_controller.dart';
import '../model/OrderDetailsModel.dart';

class OrderDetailsScreen extends StatefulWidget {
  /// ACCEPT ORDER ID FROM ANOTHER SCREEN
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late final OrderController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(OrderController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchDetail(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColor.pageBackground,
        elevation: 0,
        centerTitle: true,
        leading: BackButtonWidget(onTap: () => Get.back()),
        title: Text(
          AppString.orderDetails,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColor.blackColor,
          ),
        ),
      ),
      body: Obx(() {
        // ── Loading ────────────────────────────────────
        if (_controller.isDetailLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.appColor),
          );
        }

        final OrderData? detail = _controller.selectedDetail.value;

        // ── No data ────────────────────────────────────
        if (detail == null) {
          return Center(
            child: Text(
              AppString.orderNotFound.tr,
              style: const TextStyle(color: AppColor.greyColor),
            ),
          );
        }
        final user = detail.user;
        final items = detail.items ?? [];
        final reports = detail.reports ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ITEMS CARD
              if (items.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.items,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.appBlackColor,
                        ),
                      ),

                      SizedBox(height: 15),

                      ...items.map(
                        (item) => Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.itemName ?? "",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.c4F6778,
                                  ),
                                ),
                              ),

                              Text(
                                "\$${(item.price ?? 0.0).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.appBlackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),
              // PRICE CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            AppString.subTotal,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColor.c4F6778,
                            ),
                          ),
                        ),
                        Text(
                          "\$${(detail.subTotal ?? 0.0).toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColor.appBlackColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            AppString.serviceFees,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColor.c4F6778,
                            ),
                          ),
                        ),
                        Text(
                          "\$${(detail.serviceFee ?? 0.0).toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColor.appBlackColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            detail.deliveryType == 'drone'
                                ? AppString.deliveryFeeDrone
                                : AppString.deliveryFeeJetski,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColor.c4F6778,
                            ),
                          ),
                        ),
                        Text(
                          "\$${(detail.deliveryCharge ?? 0.0).toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColor.appBlackColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppString.deliveryPersonTip,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColor.c4F6778,
                            ),
                          ),
                        ),
                        Text(
                          "\$${(detail.tipAmount ?? 0.0).toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColor.appBlackColor,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColor.c4F6778.withValues(alpha: .20),
                    ),

                    SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppString.total,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColor.c4F6778,
                            ),
                          ),
                        ),
                        Text(
                          "\$${(detail.totalAmount ?? 0.0).toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.yellowColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (user != null)
                // DELIVERY INFO CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppString.deliveryInformation,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.appBlackColor,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              AppString.orderId,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: AppColor.c4F6778,
                              ),
                            ),
                          ),
                          Text(
                            detail.orderNumber ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColor.appBlackColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              AppString.deliveryPersonName,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: AppColor.c4F6778,
                              ),
                            ),
                          ),
                          Text(
                            detail.user?.fullName?.capitalizeFirst ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColor.appBlackColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              AppString.deliveryTime,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: AppColor.c4F6778,
                              ),
                            ),
                          ),
                          Text(
                            detail.deliveredAt != null
                                ? AppUtils.formatDateTimeLocal(
                                    detail.deliveredAt.toString(),
                                  )
                                : "--",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColor.appBlackColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 18),

              // REPORT ISSUE
              GestureDetector(
                onTap: () {
                  Get.to(() => ReportIssueScreen(orderId: widget.orderId));
                },
                child: Center(
                  child: Text(
                    AppString.reportIssueWithOrder,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColor.gradientFirstColor,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColor.gradientFirstColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

import 'dart:ffi';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/app_widget/common_app_bar.dart';
import 'package:uber_boats_customer/app/features/create_order/controllers/create_order_controller.dart';
import 'package:uber_boats_customer/app/features/create_order/model/create_order_models.dart';
import 'package:uber_boats_customer/common_widgets/common_text_field.dart';
import '../../../../common_widgets/back_button.dart';
import '../../../../common_widgets/common_button_widget.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_string.dart';
import '../../../app_widget/common_card_widget.dart';
import 'order_success_screen.dart';

class ReviewOrderScreen extends StatefulWidget {
  const ReviewOrderScreen({super.key});

  @override
  State<ReviewOrderScreen> createState() => _ReviewOrderScreenState();
}

class _ReviewOrderScreenState extends State<ReviewOrderScreen> {
  final CreateOrderController controller = Get.put(CreateOrderController());

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
          AppString.reviewOrderText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColor.blackColor,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: Obx(
          () => CommonButton(
            // text: "${AppString.submitOrderRequest} \$${controller.createOrderResponse.value?.order?.totalAmount}",
            text: AppString.submitOrderRequest,
            onPressed: () async {
              await controller.createPaymentLink();
            },
            loading: controller.isCreatePaymentLinkLoading.value,
          ),
        ),
      ),
      body: Obx(() {
        final CreateOrderData? detail = controller.createOrderResponse.value;

        // ── No data ────────────────────────────────────
        if (detail == null) {
          return Center(
            child: Text(
              AppString.orderNotFound.tr,
              style: const TextStyle(color: AppColor.greyColor),
            ),
          );
        }

        final items = detail.items ?? [];

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

                      ...detail.items!.map(
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
                                "\$${item.price!.toStringAsFixed(2)}",
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
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    // Get.back();
                    // Get.back();
                    Get.close(2);
                  },
                  child: SizedBox(
                    height: 42,
                    width: 120,
                    child: DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        radius: Radius.circular(12),
                        dashPattern: [3, 3],
                        padding: EdgeInsets.zero,
                        color: AppColor.hintTextColor.withValues(alpha: .20),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 16,
                              color: Color(0xff4B6475),
                            ),
                            SizedBox(width: 8),
                            Text(
                              AppString.editOrder,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.hintTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              //Tip Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        AppString.tipDeliveryPerson,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.appBlackColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 8,
                              children: [
                                GestureDetector(
                                  onTap: () => controller.selectTip(0),
                                  child: CommonCardWidget(
                                    text: AppString.none,
                                    isSelected:
                                        controller.selectedTipIndex.value == 0,
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () => controller.selectTip(1),
                                  child: CommonCardWidget(
                                    text: "\$10",
                                    isSelected:
                                        controller.selectedTipIndex.value == 1,
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () => controller.selectTip(2),
                                  child: CommonCardWidget(
                                    text: "\$20",
                                    isSelected:
                                        controller.selectedTipIndex.value == 2,
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () => controller.selectTip(3),
                                  child: CommonCardWidget(
                                    text: "\$30",
                                    isSelected:
                                        controller.selectedTipIndex.value == 3,
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () => controller.selectTip(4),
                                  child: CommonCardWidget(
                                    text: AppString.enterCustomTip,
                                    isSelected:
                                        controller.selectedTipIndex.value == 4,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (controller.selectedTipIndex.value == 4) ...[
                            const SizedBox(height: 16),

                            CommonTextField(
                              hintText: AppString.enterCustomTip,
                              controller: controller.tipPriceTextController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                controller.selectTip(4);
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

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
                          "\$${detail.order?.subTotal?.toStringAsFixed(2)}",
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
                          "\$${detail.order?.serviceFee?.toStringAsFixed(2)}",
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
                            detail.order?.deliveryType == 'drone'
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
                          "\$${detail.order?.deliveryCharge?.toStringAsFixed(2)}",
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
                          "\$${controller.selectedTip.value.toStringAsFixed(2)}",
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
                          "\$${(detail.order!.totalAmount! + controller.selectedTip.value).toStringAsFixed(2)}",
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
            ],
          ),
        );
      }),
    );
  }
}

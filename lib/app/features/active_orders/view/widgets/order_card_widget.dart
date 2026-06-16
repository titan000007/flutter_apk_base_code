import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import '../../../../../common_widgets/common_button_widget.dart';
import '../../../../../common_widgets/delivery_type_icon.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_images.dart';
import '../../model/activeOrderModel.dart';
import 'status_progress_widget.dart';

class OrderCard extends StatelessWidget {
  final ActiveOrders order;
  final VoidCallback onTrackTap;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTrackTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Delivery type icon circle
                DeliveryTypeIcon(deliveryType: order.deliveryType ?? ""),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "#${order.orderNumber}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.appBlackColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${order.itemsCount} items • \$${order.totalAmount?.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: AppColor.c4F6778,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status badge
                _StatusBadge(orderStatus: order.orderStatus ?? ""),
              ],
            ),

            const SizedBox(height: 16),

            OrderStatusProgress(orderStatus: order.orderStatus ?? ""),

            const SizedBox(height: 16),

            //PIN
            if (order.orderStatus?.toLowerCase() != "pending")
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.pageBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Complete your order\nwith PIN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppColor.appBlackColor,
                      ),
                    ),

                    Row(
                      children: order.confirmationPin!
                          .split('')
                          .map((digit) {
                            return Container(
                              width: 32,
                              height: 32,
                              margin: const EdgeInsets.only(left: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColor.gradientFirstColor,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                digit,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.appBlackColor,
                                ),
                              ),
                            );
                          })
                          .toList()
                          .cast<Widget>(),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            CommonButton(
              text: 'Track on Live Map',
              icon: AppImages.icMapPin,
              iconColor: AppColor.whiteColor,
              isIconShow: true,
              onPressed: onTrackTap,
              isDisable: order.orderStatus?.toLowerCase() == "pending",
              loading: false,
              radius: 12,
              height: 42,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status badge
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String orderStatus;

  const _StatusBadge({required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColor.a10B981.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        getStatus(orderStatus),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColor.a10B981,
        ),
      ),
    );
  }
}

String getStatus(String status) {
  // pending
  // confirmed
  // picked,
  //     ontheway,
  //     delivered,
  //     cancelled

  if (status == "pending") return 'Pending';
  if (status == "confirmed") return 'Confirmed';
  if (status == "picked") return 'Picked up';
  if (status == "ontheway") return 'On the way';
  if (status == "delivered") return 'Delivered';
  if (status == "cancelled")
    return 'Cancelled';
  else
    return status;
}

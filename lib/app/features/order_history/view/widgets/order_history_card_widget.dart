import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../common_widgets/delivery_type_icon.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_images.dart';
import '../../../../../utils/app_string.dart';
import '../../model/order_history_model.dart';

class OrderHistoryCard extends StatelessWidget {
  final Orders order;
  final VoidCallback onTap;

  const OrderHistoryCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColor.gradientFirstColor.withValues(alpha: .15),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Delivery type icon
              DeliveryTypeIcon(deliveryType: order.deliveryType.toString()),
              const SizedBox(width: 10),

              // Order ID + date
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "#${order.orderNumber}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColor.appBlackColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      formatDate(order.confirmedAt ?? ""),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppColor.c4F6778,
                      ),
                    ),
                  ],
                ),
              ),

              // Amount + delivered badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${order.totalAmount}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColor.appBlackColor,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Image(
                        color: AppColor.e2CC696,
                        image: AssetImage(AppImages.orderHistoryTickIcon),
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        AppString.delivered,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColor.e2CC696,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  String formatDate(String date) {
    final dt = DateTime.parse(date).toLocal();

    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';

    return DateFormat('dd MMM yyyy').format(dt);
  }
}


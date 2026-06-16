import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/features/active_orders/model/activeOrderModel.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_images.dart';

class DriverCard extends StatelessWidget {
  final ActiveOrders order;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  const DriverCard({
    super.key,
    required this.order,
    required this.onCall,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    final driver = order.driver!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColor.gradientFirstColor, AppColor.gradientSecondColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // ── Driver info row ─────────────────────────────────────────
              Row(
                children: [
                  // Avatar
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(driver.profileimage ?? ""),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Name + phone
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.fullName?.capitalizeFirst ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.whiteColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          driver.mobile ?? "",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: AppColor.pageBackground,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action buttons
                  GestureDetector(
                    onTap: onMessage,
                    child: Container(
                      height: 34,
                      width: 34,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        AppImages.chatMessage,
                        color: AppColor.whiteColor,
                        width: 20,
                      ),
                    ),
                  ),
                  if (driver.mobile != null && driver.mobile!.isNotEmpty) ...[
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: onCall,
                      child: Container(
                        height: 34,
                        width: 34,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.20),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          AppImages.icOutlineCall,
                          color: AppColor.whiteColor,
                          width: 20,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

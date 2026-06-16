import 'package:flutter/material.dart';
import '../../../../../utils/app_color.dart';

class OrderStatusProgress extends StatelessWidget {
  final String orderStatus;

  const OrderStatusProgress({super.key, required this.orderStatus});

  static const _steps = [
    'Pending',
    'Confirmed',
    'Picking up',
    'On way',
    'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    final activeIndex = orderStatus.toLowerCase() == "pending"
        ? 0
        : orderStatus == "confirmed"
        ? 1
        : orderStatus == "picked"
        ? 2
        : orderStatus == "ontheway"
        ? 3
        : 4;

    return Column(
      children: [
        Row(
          children: List.generate(_steps.length, (i) {
            final isCompleted = i <= activeIndex;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < _steps.length - 1 ? 4 : 0),
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isCompleted
                      ? AppColor.gradientFirstColor
                      : AppColor.gradientFirstColor.withValues(alpha: .10),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 6),

        // ── Labels ────────────────────────────────────────────────────────
        Row(
          children: List.generate(_steps.length, (i) {
            return Expanded(
              child: Text(
                _steps[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: AppColor.c4F6778,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

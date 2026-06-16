import 'package:flutter/material.dart';

import '../../utils/app_color.dart';

class CommonCardWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  const CommonCardWidget({
    super.key,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            spreadRadius: 0,
            color: AppColor.blackColor.withValues(alpha: .05),
            offset: Offset(0, 10),
          ),
        ],
        color: isSelected ? AppColor.gradientFirstColor : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 1,
          color: isSelected
              ? Colors.transparent
              : AppColor.gradientFirstColor.withValues(alpha: .15),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          fontSize: 10,
          color: isSelected ? AppColor.f9FAB : AppColor.hintTextColor,
        ),
      ),
    );
  }
}

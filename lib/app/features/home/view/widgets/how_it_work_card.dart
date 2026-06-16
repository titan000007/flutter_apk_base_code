import 'package:flutter/material.dart';

import '../../../../../utils/app_color.dart';

class HowItWorkCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final Color backgroundColor;
  const HowItWorkCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: AppColor.gradientFirstColor.withValues(alpha: .15),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image(image: AssetImage(image)),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColor.appBlackColor,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColor.hintTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

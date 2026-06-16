import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';

class CommonSelectableCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String image;
  final bool isSelected;
  final bool isDisable;
  final VoidCallback onTap;
  final Color accentColor;

  const CommonSelectableCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.image,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
    this.isDisable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColor.gradientFirstColor : Colors.transparent,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: isDisable ? null : onTap,
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Center(child: Image.asset(image)),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColor.appBlackColor,
                    ),
                  ),

                  SizedBox(height: 2),

                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColor.hintTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.appBlackColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

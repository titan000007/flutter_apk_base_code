import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';

class ProfileListingCard extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;
  final double? height;
  final double? width;
  final Padding? padding;
  const ProfileListingCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
    this.height,
    this.width, this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor.withValues(alpha: .05),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 40,
                width: 40,
                color:
                    color ?? AppColor.gradientFirstColor.withValues(alpha: .10),
                child: Image(
                  image: AssetImage(icon),
                  height: height ?? 40,
                  width: width ?? 40,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColor.appBlackColor,
              ),
            ),

            Spacer(),

            Image(
              image: AssetImage(AppImages.rightIcon),
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
    );
  }
}

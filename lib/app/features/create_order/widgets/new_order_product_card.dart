import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';

class NewOrderProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final VoidCallback onTap;
  const NewOrderProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor.withValues(alpha: 0.05),
              spreadRadius: 2,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(image: AssetImage(imageUrl), height: 40, width: 40),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: AppColor.appBlackColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3),
            Text(
              description,
              style: TextStyle(color: AppColor.c4F6778, fontSize: 10,fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}

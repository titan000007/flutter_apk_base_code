import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uber_boats_customer/utils/app_images.dart';
import 'package:uber_boats_customer/utils/app_string.dart';
import '../../../../utils/app_color.dart';

class NewOrderListCard extends StatelessWidget {
  final String? image;
  final String title;
  final String describe;
  final String amount;
  final String itemType;

  final VoidCallback onTap;
  final VoidCallback removeItemFromListTab;
  const NewOrderListCard({
    super.key,
    required this.image,
    required this.title,
    required this.describe,
    required this.amount,
    required this.itemType,
    required this.onTap,
    required this.removeItemFromListTab,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColor.whiteColor,
          border: Border.all(
            width: 1,
            color: AppColor.gradientFirstColor.withValues(alpha: .15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image(
                      image: AssetImage(
                        itemType == AppString.textListText
                            ? AppImages.textListIcon
                            : itemType == AppString.screenshotText
                            ? AppImages.photoIcon
                            : itemType == AppString.boatFuelText
                            ? AppImages.boatFuelIcon
                            : itemType == AppString.directLink
                            ? AppImages.directLinkIcon
                            : AppImages.appLogo,
                      ),
                      height: 34,
                      width: 34,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: AppColor.appBlackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        if(describe.isNotEmpty)
                        Text(
                          describe,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
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
            ),
            Row(
              children: [
                Text(
                  '\$',
                  style: TextStyle(
                    color: AppColor.appBlackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 0.5),
                Text(
                  amount,
                  style: TextStyle(
                    color: AppColor.appBlackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: removeItemFromListTab,
                  icon: (Icon(
                    Icons.close,
                    size: 18,
                    color: AppColor.hintTextColor,
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

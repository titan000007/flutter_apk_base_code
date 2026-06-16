import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/app_images.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  const CommonAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Image(
              image: AssetImage(AppImages.arrowBack),
              height: 18,
              width: 18,
            ),
          ),
          const Spacer(),

          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColor.blackColor,
            ),
          ),

          const Spacer(),
          SizedBox(width: 25),
        ],
      ),
    );
  }
}

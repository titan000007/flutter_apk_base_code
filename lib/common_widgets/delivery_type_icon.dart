import 'package:flutter/cupertino.dart';

import '../utils/app_color.dart';
import '../utils/app_images.dart';

class DeliveryTypeIcon extends StatelessWidget {
  final String deliveryType;

  const DeliveryTypeIcon({required this.deliveryType});

  @override
  Widget build(BuildContext context) {
    final isDrone = deliveryType.toLowerCase() == "drone";

    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDrone ? AppColor.eDD02F : AppColor.gradientFirstColor,
      ),
      child: Center(
        child: Image.asset(
          isDrone ? AppImages.icDrone : AppImages.icJetski,
          height: 24,
          width: 24,
          color: AppColor.whiteColor,
        ),
      ),
    );
  }
}

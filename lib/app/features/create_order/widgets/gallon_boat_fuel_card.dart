import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/features/create_order/controllers/create_order_controller.dart';

import '../../../../common_widgets/common_text_field.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_string.dart';

class GallonsWidget extends StatelessWidget {
  const GallonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateOrderController createOrderC =
        Get.find<CreateOrderController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: const Offset(0, 10),
                color: AppColor.blackColor.withValues(alpha: .05),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(AppImages.boatFuelIcon),
                height: 40,
                width: 40,
              ),
              const SizedBox(height: 5),
              Text(
                AppString.gallons,
                style: const TextStyle(
                  color: AppColor.hintTextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 10),

              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (createOrderC.count.value > 1) {
                          createOrderC.count.value--;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColor.gradientFirstColor.withValues(
                            alpha: .15,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image(
                          image: AssetImage(AppImages.minusSolidIcon),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    /// COUNT TEXT
                    SizedBox(
                      width: 50,
                      child: Text(
                        '${createOrderC.count.value}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: AppColor.appColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    /// PLUS BUTTON
                    GestureDetector(
                      onTap: () {
                        if (createOrderC.count.value < 20) {
                          createOrderC.count.value++;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColor.gradientFirstColor.withValues(
                            alpha: .15,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image(
                          image: AssetImage(AppImages.icPlus),
                          color: AppColor.gradientFirstColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Text(
                'Max 20 gal',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: AppColor.hintTextColor,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

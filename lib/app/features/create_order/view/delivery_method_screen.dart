import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/app_widget/common_app_bar.dart';
import 'package:uber_boats_customer/app/features/create_order/model/order_item_model.dart';
import 'package:uber_boats_customer/app/features/create_order/view/rules_and_recommendations_screen.dart';
import '../../../../common_widgets/common_button_widget.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_string.dart';
import '../controllers/create_order_controller.dart';
import '../widgets/delivery_method_card.dart';

class DeliveryMethodScreen extends StatefulWidget {
  final List<OrderItem> orderItems;
  final double subtotal;
  const DeliveryMethodScreen({
    super.key,
    required this.orderItems,
    required this.subtotal,
  });

  @override
  State<DeliveryMethodScreen> createState() => _DeliveryMethodScreenState();
}

class _DeliveryMethodScreenState extends State<DeliveryMethodScreen> {
  final CreateOrderController createOrderC = Get.put(CreateOrderController());

  bool get hasFuel =>
      widget.orderItems.any((item) => item.itemType == AppString.boatFuelText);

  @override
  void initState() {
    super.initState();
    if (hasFuel) {
      createOrderC.selectedMethod.value = "jetski";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,
      bottomNavigationBar: BottomAppBar(
        color: AppColor.pageBackground,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.only(bottom: 20, left: 16, right: 16),
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonButton(
                text: AppString.continueText,
                onPressed: () {
                  Get.to(() => const RulesAndRecommendationsScreen());
                },
                loading: false,
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 46),
              CommonAppBar(title: AppString.deliveryMethod),
              SizedBox(height: 20),
              CommonSelectableCard(
                title: AppString.droneDelivery,
                subtitle: AppString.droneDeliveryDesc,
                price: "\$30",
                image: AppImages.droneDeliveryIcon,
                isSelected: createOrderC.selectedMethod.value == "drone",
                isDisable: hasFuel,
                accentColor: const Color(0xffE7B800),
                onTap: () {
                  createOrderC.selectedMethod.value = "drone";
                },
              ),

              CommonSelectableCard(
                title: AppString.jetskiDelivery,
                subtitle: AppString.jetskiDeliveryDesc,
                price: "\$70",
                image: AppImages.jetskiDeliveryIcon,
                isSelected: createOrderC.selectedMethod.value == "jetski",
                accentColor: const Color(0xff00AFCF),
                onTap: () {
                  createOrderC.selectedMethod.value = "jetski";
                },
              ),
              // SizedBox(height: 15),
              if (hasFuel)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColor.gradientFirstColor.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    AppString.droneOptionDisabledWhenOrderIncludesFuel,
                    style: TextStyle(
                      color: AppColor.hintTextColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

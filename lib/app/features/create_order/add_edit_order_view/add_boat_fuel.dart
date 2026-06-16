import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:uber_boats_customer/app/app_widget/common_app_bar.dart';
import 'package:uber_boats_customer/app/features/create_order/view/create_order_screen.dart';
import 'package:uber_boats_customer/common_widgets/common_text_field.dart';
import 'package:uber_boats_customer/utils/app_log.dart';
import '../../../../common_widgets/common_button_widget.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_string.dart';
import '../controllers/create_order_controller.dart';
import '../widgets/gallon_boat_fuel_card.dart';

class AddBoatFuelScreen extends StatefulWidget {
  const AddBoatFuelScreen({super.key});

  @override
  State<AddBoatFuelScreen> createState() => _AddBoatFuelScreenState();
}

class _AddBoatFuelScreenState extends State<AddBoatFuelScreen> {
  final CreateOrderController createOrderC = Get.put(CreateOrderController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 50, left: 16, right: 16),
        child: CommonButton(
          text: AppString.addToOrder,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              createOrderC.addBoatFuelItem();
              Get.back();
              AppLog.printLog(
                'Add boat Fuel ::: ${createOrderC.addBoatFuelItem.toString()}',
              );
            }
          },
          loading: false,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 46),

              ///CommonAppBar
              CommonAppBar(title: AppString.addBoatFuel),

              SizedBox(height: 20),

              GallonsWidget(),
              SizedBox(height: 15),

              Text(
                AppString.priceUsd,
                style: const TextStyle(
                  color: AppColor.appBlackColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              CommonTextField(
                controller: createOrderC.fuelPriceTextController,
                hintText: "Enter total price for fuel here",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return AppString.pleaseEnterPrice;
                  }
                  final price = double.tryParse(v);
                  if (price == null) {
                    return AppString.pleaseEnterValidPrice;
                  }
                  if (price <= 0) {
                    return "Price must be greater than 0";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),

              /// hint container
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColor.gradientFirstColor.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    width: 0.5,
                    color: AppColor.appColor.withValues(alpha: .10),
                  ),
                ),
                child: Row(
                  children: [
                    Image(
                      image: AssetImage(AppImages.shieldTick),
                      height: 24,
                      width: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppString.boatFuelScreenMessage,
                        maxLines: 3,
                        style: TextStyle(
                          color: AppColor.hintTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

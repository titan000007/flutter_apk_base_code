import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/app_widget/common_app_bar.dart';
import 'package:uber_boats_customer/app/features/create_order/controllers/create_order_controller.dart';
import 'package:uber_boats_customer/common_widgets/common_text_field.dart';
import '../../../../common_widgets/common_button_widget.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_string.dart';
import '../view/create_order_screen.dart';

class AddByScreenshotScreen extends StatefulWidget {
  const AddByScreenshotScreen({super.key});

  @override
  State<AddByScreenshotScreen> createState() => _AddByScreenshotScreenState();
}

class _AddByScreenshotScreenState extends State<AddByScreenshotScreen> {
  final CreateOrderController createOrderC = Get.find<CreateOrderController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 50, left: 16, right: 16),
        child: CommonButton(
          text: AppString.addToOrder,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              createOrderC.addScreenshotItem();
              Get.back();
            }
          },
          loading: false,
        ),
      ),
      body: Obx(() {
        return Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 46),
                CommonAppBar(title: AppString.addByScreenshot),
                const SizedBox(height: 20),
                Text(
                  AppString.screenshot,
                  style: const TextStyle(
                    color: AppColor.appBlackColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    dashPattern: [8, 8],
                    strokeWidth: 2,
                    color: AppColor.gradientFirstColor.withValues(alpha: 0.15),
                    radius: const Radius.circular(12),
                  ),
                  child: InkWell(
                    onTap: createOrderC.pickAndUploadImage,
                    child: Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: createOrderC.selectedImage.value != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                createOrderC.selectedImage.value!,
                                width: double.infinity,
                                height: 160,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage(
                                    AppImages.solarCameraLinear,
                                  ),
                                  height: 24,
                                  width: 24,
                                  color: AppColor.hintTextColor,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  AppString.addProfilePhoto,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.hintTextColor,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  AppString.itemName,
                  style: const TextStyle(
                    color: AppColor.appBlackColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                CommonTextField(
                  controller: createOrderC.itemNameScreenShotController,
                  hintText: "Fresh chicken breast",
                  keyboardType: TextInputType.text,
                  textCapital: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return AppString.pleaseEnterItemName;
                    }
                    if (v.trim().length < 2) {
                      return "Item name is too short";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
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
                  controller: createOrderC.priceScreenShotController,
                  hintText: "11.95",
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                const SizedBox(height: 15),
                Text(
                  AppString.descriptionOptional,
                  style: const TextStyle(
                    color: AppColor.appBlackColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                CommonTextField(
                  controller: createOrderC.descriptionScreenShotController,
                  hintText: 'Brand, size, notes...',
                  keyboardType: TextInputType.text,
                  maxLength: 180,
                  maxLines: 5,
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      }),
    );
  }
}

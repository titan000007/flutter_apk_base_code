import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/app_widget/common_app_bar.dart';
import 'package:uber_boats_customer/app/features/create_order/controllers/create_order_controller.dart';
import 'package:uber_boats_customer/common_widgets/common_text_field.dart';
import '../../../../common_widgets/common_button_widget.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_string.dart';
import '../view/create_order_screen.dart';

class AddByLinkScreen extends StatefulWidget {
  const AddByLinkScreen({super.key});

  @override
  State<AddByLinkScreen> createState() => _AddByLinkScreenState();
}

class _AddByLinkScreenState extends State<AddByLinkScreen> {
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
          loading: false,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              createOrderC.addLinkItem();
              Get.back();
            }
          },
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 46),
              CommonAppBar(title: AppString.addByLink),
              const SizedBox(height: 20),
              Text(
                AppString.directProductLink,
                style: const TextStyle(
                  color: AppColor.appBlackColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              CommonTextField(
                controller: createOrderC.linkController,
                hintText: "https://walmart.com...",
                autovalidateMode: AutovalidateMode.onUserInteraction,

                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return AppString.pleaseEnterProductLink;
                  }
                  if (!GetUtils.isURL(v.trim())) {
                    return AppString.pleaseEnterValidProductLink;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                AppString.urlHintText,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: AppColor.hintTextColor,
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
                controller: createOrderC.itemNameController,
                hintText: "Fresh chicken breast",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,
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
                controller: createOrderC.priceController,
                hintText: "11.95",
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
                controller: createOrderC.descriptionController,
                hintText: 'Brand, size, notes...',
                keyboardType: TextInputType.text,
                maxLength: 180,
                maxLines: 5,
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

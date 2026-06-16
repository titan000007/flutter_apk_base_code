import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/app_widget/common_app_bar.dart';
import 'package:uber_boats_customer/app/features/create_order/view/delivery_method_screen.dart';
import 'package:uber_boats_customer/app/features/create_order/widgets/new_order_list_card.dart';
import 'package:uber_boats_customer/app/features/home/controller/home_controller.dart';
import '../../../../common_widgets/common_button_widget.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_log.dart';
import '../../../../utils/app_prompt.dart';
import '../../../../utils/app_string.dart';
import '../add_edit_order_view/add_boat_fuel.dart';
import '../add_edit_order_view/add_by_link.dart';
import '../add_edit_order_view/add_by_screenshot.dart';
import '../add_edit_order_view/add_by_text.dart';
import '../controllers/create_order_controller.dart';
import '../widgets/new_order_product_card.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final CreateOrderController controller = Get.put(CreateOrderController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,
      bottomNavigationBar: BottomAppBar(
        color: AppColor.pageBackground,
        elevation: 0,
        child: Obx(() {
          return Container(
            padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                      style: const TextStyle(
                        color: AppColor.hintTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '\$ ${controller.subtotal.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColor.appBlackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (controller.subtotal.value < 100)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: AppColor.yellowColor.withValues(alpha: .10),
                        ),
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage(AppImages.alertIcon),
                              height: 16,
                              width: 16,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                AppString.minimumOrderIsHundred,
                                style: TextStyle(
                                  color: AppColor.yellowColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                CommonButton(
                  isDisable: controller.subtotal.value < 100,
                  text: AppString.continueText,
                  onPressed: () {
                    AppLog.printLog('delivery screen redirect');
                    Get.to(
                      () => DeliveryMethodScreen(
                        orderItems: controller.orderItems,
                        subtotal: controller.subtotal.value,
                      ),
                    );
                    AppLog.printLog(
                      'orderItems ::: ${controller.orderItems.toString()}',
                    );
                    AppLog.printLog(
                      'subtotalItems ::: ${controller.subtotal.value.toString()}',
                    );
                  },
                  loading: false,
                ),
              ],
            ),
          );
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 46),
            CommonAppBar(title: AppString.newOrder),
            const SizedBox(height: 15),
            Text(
              AppString.allItems,
              style: const TextStyle(
                color: AppColor.appBlackColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            GridView(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 122,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                NewOrderProductCard(
                  imageUrl: AppImages.photoIcon,
                  title: AppString.screenshot,
                  description: AppString.photoPrice,
                  onTap: () => Get.to(() => const AddByScreenshotScreen()),
                ),
                NewOrderProductCard(
                  imageUrl: AppImages.textListIcon,
                  title: AppString.textList,
                  description: AppString.copyAndPasteListOfItems,
                  onTap: () => Get.to(() => const AddByTextScreen()),
                ),
                NewOrderProductCard(
                  imageUrl: AppImages.directLinkIcon,
                  title: AppString.copyAndPasteLink,
                  description: AppString.walmartEtc,
                  onTap: () => Get.to(() => const AddByLinkScreen()),
                ),
                NewOrderProductCard(
                  imageUrl: AppImages.boatFuelIcon,
                  title: AppString.boatFuel,
                  description: AppString.upToTwentyGal,
                  onTap: () {
                    bool hasFuelItem = controller.orderItems.any(
                          (item) => item.itemType.toLowerCase() == "boatfuel",
                    );
                    if (hasFuelItem) {
                      showAppToast(isForError: true, msg: "Boat fuel already added");
                    } else{
                      Get.to(() => const AddBoatFuelScreen());
                    }


                  }
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              AppString.inYourOrder,
              style: const TextStyle(
                color: AppColor.appBlackColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (controller.orderItems.isEmpty) {
                  return Center(
                    child: Text(
                      'No items added yet',
                      style: const TextStyle(
                        color: AppColor.hintTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }

                return ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: RefreshIndicator(
                    color: AppColor.appColor,
                    onRefresh: () async {},
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.orderItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.orderItems[index];
                        return NewOrderListCard(
                          image: item.imageUrl,
                          title: item.title,
                          describe: item.description,
                          amount: item.amount,
                          onTap: () => AppLog.printLog("${item.title} tapped"),
                          removeItemFromListTab: () =>
                              controller.removeOrderItem(index),
                          itemType: item.itemType,
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

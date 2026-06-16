import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/app_widget/common_app_bar.dart';
import 'package:uber_boats_customer/app/features/create_order/controllers/create_order_controller.dart';
import 'package:uber_boats_customer/app/features/create_order/view/review_order_screen.dart';
import '../../../../common_widgets/common_button_widget.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_string.dart';

class RulesAndRecommendationsScreen extends StatefulWidget {
  const RulesAndRecommendationsScreen({super.key});

  @override
  State<RulesAndRecommendationsScreen> createState() =>
      _RulesAndRecommendationsScreenState();
}

class _RulesAndRecommendationsScreenState
    extends State<RulesAndRecommendationsScreen> {
  final CreateOrderController createOrderC = Get.put(CreateOrderController());
  bool isChecked = false;
  final List<String> rulesList = [
    "Have Smartphone/Tablet/GPS tracking enabled Device Turned On, Active, and with them at all times until they recieve their Delivery Order.",

    "Boat MUST be within a Quarter (1/4) Mile or .4 kilometers from the Shoreline/Beach/Coastline for Drone Delivery Orders. Boat MUST be Within 1/2 Mile or .8 Kilometers for Jetski orders.",

    "Practice Highest Standards of Safety First at All times during Delivery Process.",

    "Give Very Clear and Direct Instructions in App/to Delivery Person for Each Delivery Request.",

    "Be Polite, Respectful, Courteous to Delivery Person at all times.",

    "MUST Be 21 years old to Order Alcohol. Must Not give Alcohol ordered thru the App to any person below legal Age.",

    "Actively Help and Participate in Delivery Process to Successfully Complete each Delivery.",

    "Report any problems with their Delivery Order within 24 hours after Delivery is Completed.",

    "Screenshots Must Have Clear Images and Prices Clearly Displayed.",

    "Product/Item Links (URL's) Must Have clear Images and Prices clearly displayed.",

    "No Illegal items/Criminal items or Illegal Actions/Behavior will be tolerated.",

    "\"FlutterBaseApp\" is not Liable for Negligence or Incompetence on the Boat Owner/Client/Customer's Part.",

    "Each Delivery Order Request Must be Minimum \$100 per Order.",

    "Each Store/Shop/Restaurant Must be within a 50 Mile radius of the Shoreline/Coastline.",

    "Confirmation Pin Code is Required to Receive each Order.",

    "Delivery Person is Not Required to board Boat at any time for any reason.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageBackground,

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        decoration: BoxDecoration(
          color: AppColor.pageBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColor.whiteColor,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColor.gradientFirstColor.withValues(
                              alpha: .20,
                            ),
                            width: 1,
                          ),
                        ),
                        child: isChecked
                            ? Icon(
                                Icons.check,
                                color: AppColor.gradientFirstColor,
                                size: 18,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(width: 18),

                    Expanded(
                      child: Text(
                        AppString.iHaveReadAndAgreeRulesAboveText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          color: AppColor.hintTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              Obx(
                () => CommonButton(
                  isDisable: !isChecked,
                  text: AppString.agreeAndContinueText,
                  onPressed: () async {
                    await createOrderC.addUpdateOrders();
                  },
                  loading: createOrderC.isCreateOrderLoading.value,
                ),
              ),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 46),

            CommonAppBar(title: AppString.rulesAndRecommendationsText),

            SizedBox(height: 10),

            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 15),
                    shrinkWrap: true,
                    addRepaintBoundaries: false,
                    itemCount: rulesList.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// NUMBER CIRCLE
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            height: 20,
                            width: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColor.gradientFirstColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(
                                color: AppColor.whiteColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// RULE TEXT
                          Expanded(
                            child: Text(
                              rulesList[index],
                              style: const TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                color: AppColor.hintTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

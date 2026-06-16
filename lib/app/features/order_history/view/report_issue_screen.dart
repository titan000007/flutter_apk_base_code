import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/common_button_widget.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_string.dart';
import '../../../app_widget/common_app_bar.dart';
import '../controller/order_history_controller.dart';

class ReportIssueScreen extends StatelessWidget {
  final String orderId;

  const ReportIssueScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {

    final controller = Get.isRegistered<OrderHistoryController>()
        ? Get.find<OrderHistoryController>()
        : Get.put(OrderHistoryController());



    return Scaffold(
      bottomNavigationBar:  SafeArea(
        top: false,

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Obx(
                () => CommonButton(
              text: 'Submit',
              onPressed: () => controller.submitReportIssue(orderId: orderId),
              loading: controller.isReportSubmitting.value,
              radius: 30,
              height: 52,
            ),
          ),
        ),
      ),
      backgroundColor: AppColor.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CommonAppBar(title: AppString.reportIssue),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        width: 1,
                        color: AppColor.gradientFirstColor.withValues(alpha:.15)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: controller.reportIssueController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColor.appBlackColor,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Describe your issue...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColor.hintTextColor,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

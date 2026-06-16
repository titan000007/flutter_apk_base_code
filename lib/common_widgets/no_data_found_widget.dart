import 'package:flutter/material.dart';
import '../utils/app_color.dart';
import 'common_button_widget.dart';

class NoDataFoundWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String? subTitle;
  final bool? showButton;
  final bool? showSub;
  final String? buttenText;
  final double? Iconsize;
  final VoidCallback? onTap;

  const NoDataFoundWidget({
    super.key,
    required this.imagePath,
    required this.title,
    this.subTitle,
    this.buttenText,
    this.onTap, this.showButton = false, this.showSub = false,
    this.Iconsize ,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(color: AppColor.appColor,
              shape: BoxShape.circle
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                height: Iconsize ?? 20 ,
                width:Iconsize ??  20,
                fit: BoxFit.contain,
                color: AppColor.whiteColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColor.appBlackColor,
            ),
            textAlign: TextAlign.center,
          ),

          if (subTitle != null || (subTitle?.isNotEmpty ?? false)) ...[
            const SizedBox(height: 12),
            Text(
              subTitle ?? "",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColor.hintTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          if (buttenText != null || (buttenText?.isNotEmpty ?? false)) ...[
            const SizedBox(height: 14),
            CommonButton(
              width: MediaQuery.sizeOf(context).width / 2,
              color: Colors.transparent,
              showBorder: true,
              textColor: AppColor.appColor,
              borderColor: AppColor.appColor,
              text: buttenText,
              loading: false,
              onPressed: onTap ?? () {},
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_color.dart';

class MyDialog extends StatelessWidget {
  final VoidCallback? onPress;
  final bool? isFailed;
  final bool isLoading;
  final double? rotateAngle;
  final String? title;
  final String? yesText;
  final String? noText;
  final String? description;
  final String? image;
  final Widget? child;
  final Widget? icon;
  final double borderRadius;
  const MyDialog({
    super.key,
    this.isFailed = false,
    this.isLoading = false,
    this.rotateAngle = 0,
    this.child,
    this.borderRadius = 12,
    required this.title,
    required this.description,
    required this.onPress,
    this.yesText,
    this.noText,
    this.icon,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        width: 180,
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: child,
              )
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: -45,
                    child: Container(
                      height: 55,
                      width: 55,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.appColor,
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: const [
                            AppColor.gradientFirstColor,
                            AppColor.gradientSecondColor,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Transform.rotate(
                        angle: rotateAngle!,
                        child:
                            icon ??
                            Image.asset(
                              image!,
                              height: 25,
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          title!.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColor.blackColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description!.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColor.hintTextColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: AppColor.whiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColor.blackColor,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: MaterialButton(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pop();
                                    },
                                    child: Text(
                                      (noText ?? "No").tr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.blackColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: AppColor.appColor,
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                    colors: const [
                                      AppColor.gradientFirstColor,
                                      AppColor.gradientSecondColor,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: MaterialButton(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    onPressed: isLoading ? null : onPress,
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: AppColor.whiteColor,
                                            ),
                                          )
                                        : Text(
                                            (yesText ?? "Yes").tr,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.whiteColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 14, vertical: 10),
      ),
    );
  }
}

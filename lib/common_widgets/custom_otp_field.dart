import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../utils/app_color.dart';

class CustomOtpField extends StatelessWidget {
  final TextEditingController controller;
  final int length;
  final Function(String)? onCompleted;
  final Function(String)? onChange;
  final FormFieldValidator<String>? validator;

  const CustomOtpField({
    super.key,
    required this.controller,
    required this.length,
    required this.onCompleted,
    this.onChange,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 82,
      height: 48,
      textStyle: TextStyle(
        fontSize: 21,
        color: AppColor.appColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color:AppColor.whiteColor,

        borderRadius: BorderRadius.circular(16),
      ),
    );
    var focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColor.appColor, width: 2),

      borderRadius: BorderRadius.circular(12),
    );
    var submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(),
    );

    return Pinput(
      onTapOutside: (e) => FocusScope.of(context).unfocus(),
      forceErrorState: true,
      length: length,
      errorTextStyle: TextStyle(fontSize: 14, color: AppColor.errorColor),
      controller: controller,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      showCursor: true,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      onCompleted: onCompleted,
      followingPinTheme: focusedPinTheme,
      preFilledWidget: Text(
        "0",
        style: TextStyle(
          fontSize: 14,
          color: AppColor.disabledTextColor.withOpacity(.4),
          fontWeight: FontWeight.w600,
        ),
      ),

      validator: validator,
      onChanged: onChange,
    );
  }
}

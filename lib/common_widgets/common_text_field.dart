import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_color.dart';


class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final int? width;
  final String? hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? maxLines;
  final AutovalidateMode? autovalidateMode;
  final Widget? prefixIcon;
  final Function()? onFocusChanged;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool? textCapital;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;
  final Function()? onTap;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextCapitalization? textCapitalization;
  final FocusNode? focusNode;
  final double? radius;
  final String errorText;

  const CommonTextField({
    super.key,
    this.controller,
    this.hintText,
    this.width,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onFocusChanged,
    this.readOnly = false,
    this.validator,
    this.onChanged,
    this.onTap,
    this.hintStyle,
    this.textStyle,
    this.labelStyle,
    this.focusNode,
    this.radius,
    this.errorText = '',
     this.textCapital  = false,
    this.textCapitalization = TextCapitalization.words,
    this. autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (val) {
        if (!val && onFocusChanged != null) {
          onFocusChanged!();
        }
      },
      child: TextFormField(
        autovalidateMode: autovalidateMode,
        onTapOutside: (e) => FocusScope.of(context).unfocus(),
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        maxLines: maxLines,
        validator: validator,
        onChanged: onChanged,
        onTap: onTap,
        textCapitalization: textCapital == true ? TextCapitalization.words : TextCapitalization.none,
        style:
            textStyle ?? TextStyle(fontSize: 14, color: AppColor.appBlackColor),

        decoration: InputDecoration(

          errorMaxLines: 2,
          filled: true,
          fillColor: AppColor.whiteColor,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          counterText: "",
          labelStyle: labelStyle,
          hintStyle:
              hintStyle ??
              TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColor.hintTextColor,
              ),
          contentPadding: EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 12.0),
            borderSide:  BorderSide(color: AppColor.gradientFirstColor.withValues(alpha: .15)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 12.0),
            borderSide:  BorderSide(color: AppColor.gradientFirstColor.withValues(alpha: .15)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 12.0),
            borderSide:  BorderSide(color: AppColor.gradientFirstColor.withValues(alpha: .15)),
          ),
        ),
        focusNode: focusNode,
      ),
    );
  }
}

class CommonPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final AutovalidateMode? autovalidateMode;

  const CommonPasswordField({
    super.key,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.validator,
    this.autovalidateMode,
  });

  @override
  State<CommonPasswordField> createState() => _CommonPasswordFieldState();
}

class _CommonPasswordFieldState extends State<CommonPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: widget.autovalidateMode,
      onTapOutside: (e) => FocusScope.of(context).unfocus(),
      controller: widget.controller,
      obscureText: _obscure,
      validator: widget.validator,
      style: TextStyle(fontSize: 15, color: AppColor.appBlackColor),
      decoration: InputDecoration(
        errorMaxLines: 2,
        filled: true,
        fillColor: AppColor.whiteColor,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: IconButton(
          icon: _obscure
              ? Icon(Icons.visibility_off, color: AppColor.hintTextColor,size: 20)
              : Icon(Icons.visibility, color: AppColor.hintTextColor, size: 20),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),

        hintStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColor.hintTextColor,
        ),
        contentPadding: EdgeInsets.fromLTRB(18, 5, 18, 5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:  BorderSide(color: AppColor.gradientFirstColor.withValues(alpha: .15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:  BorderSide(color: AppColor.gradientFirstColor.withValues(alpha: .15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:  BorderSide(color: AppColor.gradientFirstColor.withValues(alpha: .15)),
        ),
      ),
    );
  }
}

///Multi-line Description TextField
class CommonDescriptionField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;

  const CommonDescriptionField({
    super.key,
    this.controller,
    this.hintText,
    this.validator,
    this.maxLines = 6,
    this.hintStyle,
    this.textStyle,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (e) => FocusScope.of(context).unfocus(),
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      style:
          textStyle ?? TextStyle(fontSize: 15, color: AppColor.appBlackColor),
      decoration: InputDecoration(
        errorMaxLines: 2,
        filled: true,
        fillColor: AppColor.whiteColor,
        hintText: hintText,
        labelStyle: labelStyle,
        hintStyle:
            hintStyle ?? TextStyle(fontSize: 12, color: AppColor.hintTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColor.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColor.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColor.appColor),
        ),
      ),
    );
  }
}

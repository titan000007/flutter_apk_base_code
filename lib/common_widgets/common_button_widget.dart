import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_color.dart';

class CommonButton extends StatelessWidget {
  final String? text;
  final String? semanticsLabel;
  final Function()? onPressed;
  final TextStyle? style;
  final Widget? child;
  final bool loading;
  final bool isDisable;
  final bool isGradientShow;
  final bool showBorder;
  final Color? color;
  final Gradient? gradient;
  final Color? borderColor;
  final double borderWidth;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final double elevation;
  final double radius;
  final double iconSize;
  final String icon;
  final Color? iconColor;
  final bool isIconShow;
  final double? padding;

  const CommonButton({
    super.key,
    this.text,
    this.child,
    required this.loading,
    this.isDisable = false,
    this.isGradientShow = true,
    required this.onPressed,
    this.elevation = 0,
    this.radius = 40.0,
    this.semanticsLabel,
    this.color,
    this.gradient,
    this.textColor,
    this.borderColor,
    this.borderWidth = 1,
    this.width,
    this.showBorder = true,
    this.height,
    this.iconColor,
    this.iconSize = 24,
    this.icon = "",
    this.isIconShow = false,
    this.fontSize,
    this.style,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: showBorder
            ? BorderSide(
                color: borderColor ?? AppColor.borderColor,
                width: borderWidth,
              )
            : BorderSide.none,
      ),
      child: SizedBox(
        height: height ?? 52,
        width: width ?? double.infinity,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisable || loading ? null : onPressed,
            borderRadius: BorderRadius.circular(radius),
            child: Ink(
              decoration: BoxDecoration(
                gradient: isGradientShow ? isDisable
                    ? null
                    :  gradient ??
                          LinearGradient(
                            colors: const [
                              AppColor.gradientFirstColor,
                              AppColor.gradientSecondColor,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ) : null,
                color: isDisable
                    ? AppColor.disabledButtonColor
                    : (color ?? null),
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Center(
                child: loading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            textColor ?? Colors.white,
                          ),
                        ),
                      )
                    : child ??
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isIconShow && icon.isNotEmpty)
                                Image.asset(
                                  icon,
                                  height: iconSize,
                                  color: iconColor,
                                ).marginOnly(right: 10),
                              if (text != null)
                                Text(
                                  text!,
                                  semanticsLabel: semanticsLabel,
                                  style:
                                      style ??
                                      TextStyle(
                                        fontSize: fontSize ?? 16.0,
                                        color: isDisable
                                            ? AppColor.disabledTextColor
                                            : textColor ?? Colors.white,
                                        fontWeight: FontWeight.w600, // SemiBold
                                      ),
                                ),
                            ],
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

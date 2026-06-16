import 'package:flutter/material.dart';
import 'package:uber_boats_customer/utils/app_color.dart';

class GradientText extends StatelessWidget {
  final String text;
  final bool showUnderline;
  final double fontSize;
  final FontWeight fontWeight;

  const GradientText({
    super.key,
    required this.text,
    this.showUnderline = true,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [AppColor.gradientFirstColor, AppColor.gradientSecondColor],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Gradient Text
        ShaderMask(
          shaderCallback: (bounds) {
            return gradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            );
          },
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.white,
              height: 1,
              decorationThickness: 1,

              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

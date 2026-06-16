import 'package:flutter/material.dart';
import '../utils/app_images.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppImages.appLogo,height: 27,width: 113);
  }
}

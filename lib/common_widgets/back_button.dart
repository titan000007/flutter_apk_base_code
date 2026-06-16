import 'package:flutter/material.dart';
import '../utils/app_images.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const BackButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
          minHeight: 18,
          minWidth: 18
      ),
      icon: Image.asset(
        AppImages.arrowBack,
        height: 16,
        width: 16,
      ),
    );
  }
}

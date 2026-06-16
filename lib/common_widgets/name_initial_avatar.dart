import 'package:flutter/material.dart';

class NameInitialAvatar extends StatelessWidget {
  final String name;
  final double size;
  final Color backgroundColor;
  final Color textColor;

  const NameInitialAvatar({
    super.key,
    required this.name,
    this.size = 50,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    String initial = '';
    if (name.isNotEmpty) {
      initial = name.trim().substring(0, 1).toUpperCase();
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: backgroundColor,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size * 0.5,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';


class CustomDatePicker {

  static Future<DateTime?> datePicker({required BuildContext context}) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        initialDate: selectedDate,
        lastDate: DateTime(2500));
    if (picked != null) {
      return picked;
    }
    return null;
  }
}
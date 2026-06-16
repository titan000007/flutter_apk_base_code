import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 10) {
      digits = digits.substring(0, 10);
    }

    String formatted = _format(digits);

    int selectionIndex = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  static String _format(String digits) {
    if (digits.isEmpty) return '';

    final buffer = StringBuffer();

    if (digits.length <= 3) {
      buffer.write('(${digits}');
    } else if (digits.length <= 6) {
      buffer.write('(${digits.substring(0, 3)}) ');
      buffer.write(digits.substring(3));
    } else {
      buffer.write('(${digits.substring(0, 3)}) ');
      buffer.write(digits.substring(3, 6));
      buffer.write('-');
      buffer.write(digits.substring(6));
    }

    return buffer.toString();
  }

  static String getCleanNumber(String text) {
    return text.replaceAll(RegExp(r'\D'), '');
  }
}

String formatPhone(String number) {
  final digits = number.replaceAll(RegExp(r'\D'), '');
  if (digits.length != 10) return number;

  return '(${digits.substring(0, 3)}) '
      '${digits.substring(3, 6)}-'
      '${digits.substring(6)}';

}
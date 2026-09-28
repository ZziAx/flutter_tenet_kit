import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove any commas
    String digits = newValue.text.replaceAll(',', '');

    // Prevent errors on empty input
    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Format with commas (split 3‑by‑3 from right)
    // digits = int.parse(digits).toString();
    String formatted = formatThousands(digits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String formatThousands(String value) {
    final buffer = StringBuffer();
    int count = 0;

    for (int i = value.length - 1; i >= 0; i--) {
      buffer.write(value[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write(',');
        count = 0;
      }
    }

    return buffer.toString().split('').reversed.join();
  }
}

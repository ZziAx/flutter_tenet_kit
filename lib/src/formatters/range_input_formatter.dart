import 'package:flutter/services.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class RangeTextInputFormatter extends TextInputFormatter {
  RangeTextInputFormatter({
    required this.min,
    required this.max,
  });

  final int min;
  final int max;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final value = int.tryParse(newValue.text.toEnglishDigit());
    if (value == null) {
      return oldValue;
    }

    if (value < min || value > max) {
      return oldValue;
    }

    return newValue;
  }
}
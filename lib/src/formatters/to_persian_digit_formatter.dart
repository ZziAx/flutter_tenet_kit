import 'package:flutter/services.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

TextInputFormatter ToPersianDigitFormatter() {
  return TextInputFormatter.withFunction((
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.toPersianDigit();

    return newValue.copyWith(
      text: text,
      selection: newValue.selection,
      // selection: TextSelection.collapsed(offset: text.length),
    );
  });
}

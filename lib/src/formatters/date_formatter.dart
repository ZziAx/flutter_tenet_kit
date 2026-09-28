// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart' as intl;

// class DateFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     // Remove any commas
//     String digits = newValue.text.replaceAll(',', '');

//     // Prevent errors on empty input
//     if (digits.isEmpty) {
//       return newValue.copyWith(text: '');
//     }

//     // Format with commas (split 3‑by‑3 from right)
//     // digits = int.parse(digits).toString();
//     intl.NumberFormat _formatter = intl.NumberFormat('##/##/##');
//     String formatted = _formatter.format(int.parse(newValue.text));

//     return TextEditingValue(
//       text: formatted,
//       selection: TextSelection.collapsed(offset: formatted.length),
//     );
//   }
// }


import 'package:flutter/services.dart';

class DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');

    if (text.length > 8) {
      text = text.substring(0, 8);
    }

    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);

      if ((i == 1 || i == 3) && i != text.length - 1) {
        buffer.write('/');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: buffer.length,
      ),
    );
  }
}
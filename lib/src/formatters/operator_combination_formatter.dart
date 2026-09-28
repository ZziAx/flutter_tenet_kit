import 'package:flutter/services.dart';

TextInputFormatter OperatorCombinationFormatter() {
  List operators = ['*', '+','×', '-', '/','÷'];
  List ends = [')'];
  List begins = ['('];

  // ')', '('
  final List<String> blocked = [
    ...() {
      List<String> combinations = [];
      for (int i1 = 0; i1 < operators.length; i1++) {
        for (int i2 = 0; i2 < operators.length; i2++) {
          combinations.add(operators[i1] + operators[i2]);
        }
      }

      for (int i1 = 0; i1 < operators.length; i1++) {
        for (int i2 = 0; i2 < ends.length; i2++) {
          combinations.add(operators[i1] + ends[i2]);
        }
      }

      for (int i1 = 0; i1 < operators.length; i1++) {
        for (int i2 = 0; i2 < begins.length; i2++) {
          combinations.add(begins[i2]+operators[i1]);
        }
      }

      return combinations;
    }(),
  ];

  return TextInputFormatter.withFunction((
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String n = newValue.text.replaceAll(" ", '');
    for (final combo in blocked) {
      if (n.contains(combo)) {
        return oldValue; // reject change
      }
    }

    return newValue;
  });
}

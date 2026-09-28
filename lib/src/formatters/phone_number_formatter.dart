import 'package:flutter/services.dart';


TextInputFormatter PhoneNumberFormatter() {
  return FilteringTextInputFormatter.allow(
    RegExp(r'[0-9۰-۹]'),
  );
}
import 'package:flutter/services.dart';

TextInputFormatter NumberFormatter()=> FilteringTextInputFormatter.allow(
      RegExp(r'^[0-9۰-۹]*[.]?[0-9۰-۹]*'),
    );
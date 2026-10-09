import 'package:flutter/material.dart';

class TenetEssentialThemeData extends ChangeNotifier {
  String get fontFamily => _fontFamily;
  Color get primaryColor => _primaryColor ?? Colors.blue;
  double get headerSize => _headerSize ?? 15;

  String _fontFamily;
  Color? _primaryColor;
  double? _headerSize;
  TenetEssentialThemeData({
    required String fontFamily,
    Color? primaryColor,
    double? headerSize,
  }) : _fontFamily = fontFamily,
       _primaryColor = primaryColor,
       _headerSize = headerSize;
}

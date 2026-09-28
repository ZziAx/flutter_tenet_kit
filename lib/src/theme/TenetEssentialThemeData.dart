import 'package:flutter/material.dart';

class TenetEssentialThemeData extends ChangeNotifier {
  String get fontFamily => _fontFamily;
  Color get primaryColor =>_primaryColor??Colors.blue;

  String _fontFamily;
  Color? _primaryColor;
  TenetEssentialThemeData({required String fontFamily,Color?primaryColor})
    : _fontFamily = fontFamily,_primaryColor = primaryColor;
}

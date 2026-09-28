import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/TenetEssentialThemeData.dart';

class TenetEssentialTheme extends StatelessWidget {
  TenetEssentialThemeData theme;
  Widget child;
  TenetEssentialTheme({super.key, required this.child, required this.theme});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(value: theme, child: child);
  }
}

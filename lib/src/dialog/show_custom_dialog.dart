import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/TenetEssentialTheme.dart';
import '../theme/TenetEssentialThemeData.dart';

Future showCustomDialog(BuildContext context, {required Widget child}) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    barrierColor: Colors.black.withOpacity(0.05),
    builder: (_) {
      return TenetEssentialTheme(
        theme: context.read<TenetEssentialThemeData>(),
        child: child,
      );
    },
  );
}

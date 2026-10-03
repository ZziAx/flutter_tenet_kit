import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../Header/HeaderWithCloseButton.dart';
import '../shadow_store/shadow_store.dart';

/// A reusable dialog surface with optional title and close action.
class DialogContainer extends StatelessWidget {
  const DialogContainer({
    super.key,
    required this.child,
    this.width = 500,
    this.height = 300,
    this.title,
    this.hasSeperator = false,
    this.onClosed,
  });

  /// Content displayed inside the dialog.
  final Widget child;

  /// Dialog width.
  final double width;

  /// Dialog height.
  final double height;

  /// Optional dialog title.
  final String? title;

  final bool hasSeperator;

  /// Called when the dialog close button is pressed.
  ///
  /// If omitted, the current route is popped automatically.
  final VoidCallback? onClosed;

  static const double _padding = 15;
  static const double _borderRadius = 15;
  static const double _contentSpacing = 15;

  void _handleClose(BuildContext context) {
    if (onClosed != null) {
      onClosed!();
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(_padding),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: ShadowStore.shadowV2,
            border: GradientBoxBorder(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black26, Colors.black12],
              ),
            ),
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          child: Column(
            spacing: _contentSpacing,
            children: [
              if (title != null)
                Column(
                  spacing: _contentSpacing,
                  children: [
                    HeaderV3(title: title!, onClosed: () => _handleClose(context)),
                    if(hasSeperator)  Container(width: double.infinity,height: 1,decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.transparent,Colors.black12,Colors.transparent
              ])
            ),),
                  ],
                ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

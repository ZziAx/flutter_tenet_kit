import 'package:flutter/material.dart';

import '../shadow_store/shadow_store.dart';

/// Defines how [FocusedBoxBorder] renders its border.
enum FocusedBorderStyle {
  /// Renders a single border around the content.
  solid,

  /// Renders two nested borders to create a double-border effect.
  doubled,
}

/// A container that visually indicates a focused state.
///
/// The widget supports two border styles:
///
/// - [FocusedBorderStyle.solid]: A single outer border with an optional
///   inner border and focus shadow.
/// - [FocusedBorderStyle.doubled]: Two nested borders for a stronger
///   focused appearance.
///
/// The widget does not manage focus itself. The [hasFocus] value must be
/// provided by the parent.
///
/// Example:
/// `dart
/// FocusedBoxBorder(
///   hasFocus: isFocused,
///   child: const TextField(),
/// )
/// `
class FocusedBoxBorder extends StatelessWidget {
  /// Creates a focused-border container.
  const FocusedBoxBorder({
    super.key,
    required this.child,
    this.hasFocus = false,
    this.hasShadow = true,
    this.radius = 8,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.style = FocusedBorderStyle.solid,
    this.borderColor = Colors.black12,
    this.focusedBorderColor = Colors.blue,
    this.backgroundColor = Colors.white,
  });

  /// The content displayed inside the container.
  final Widget child;

  /// Whether the widget should render its focused appearance.
  final bool hasFocus;

  /// Whether the focus shadow should be displayed.
  ///
  /// The shadow is only applied when [hasFocus] is `true`.
  final bool hasShadow;

  /// The corner radius of the outer container.
  final double radius;

  /// Space outside the widget.
  final EdgeInsetsGeometry margin;

  /// Space between the border and [child].
  final EdgeInsetsGeometry padding;

  /// The border rendering style.
  final FocusedBorderStyle style;

  /// Border color used when the widget is not focused.
  final Color borderColor;

  /// Border color used when the widget is focused.
  final Color focusedBorderColor;

  /// Background color of the container.
  final Color backgroundColor;

  double get _safeRadius => radius.clamp(0, double.infinity);

  double get _innerRadius => (_safeRadius - 1).clamp(0, double.infinity);

  double get _clipRadius => (_safeRadius - 2).clamp(0, double.infinity);

  /// Builds the double-border variant.
  Widget _buildDoubledBorder() {
    final outerRadius = BorderRadius.circular(_safeRadius);
    final innerRadius = BorderRadius.circular(_innerRadius);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: outerRadius,
        border: Border.all(color: borderColor),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: innerRadius,
          border: Border.all(
            width: 1.5,
            color: hasFocus ? focusedBorderColor : Colors.transparent,
          ),
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }

  /// Builds the standard single-border variant.
  Widget _buildSolidBorder() {
    final outerRadius = BorderRadius.circular(_safeRadius);
    final innerRadius = BorderRadius.circular(_innerRadius);
    final clipRadius = BorderRadius.circular(_clipRadius);

    final effectiveBorderColor = hasFocus ? focusedBorderColor : borderColor;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: outerRadius,
        boxShadow: hasShadow && hasFocus ? ShadowStore.shadowV2 : null,
        border: Border.all(color: effectiveBorderColor, width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: innerRadius,
          border: Border.all(
            color: hasFocus ? focusedBorderColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: clipRadius,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return switch (style) {
      FocusedBorderStyle.solid => _buildSolidBorder(),
      FocusedBorderStyle.doubled => _buildDoubledBorder(),
    };
  }
}

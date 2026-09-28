import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/TenetEssentialThemeData.dart';

/// A customizable outlined button with optional text or icon content.
///
/// The button supports:
/// - Hover background and foreground colors.
/// - Hover border color.
/// - Custom border width and radius.
/// - Fixed width or aspect-ratio based height.
/// - Text or icon presentation.
/// - Material tap feedback.
///
/// Use [PrimaryOutlinedButton] for text buttons and
/// [PrimaryOutlinedButton.icon] for icon-only buttons.
class PrimaryOutlinedButton extends StatefulWidget {
  /// Creates a text-based outlined button.
  const PrimaryOutlinedButton({
    super.key,
    required this.text,
    required this.onClicked,
    this.backgroundColor = Colors.white,
    this.hoveredBgColor = Colors.black,
    this.color = Colors.black,
    this.hoveredColor = Colors.white,
    this.hoveredBorderColor = Colors.black,
    this.borderColor = Colors.red,
    this.width = 140,
    this.radius = 5,
    this.aspect,
    this.iconSize,
    this.borderWidth,
    this.fontSize = 13,
  }) : icon = null;

  /// Creates an icon-only outlined button.
  const PrimaryOutlinedButton.icon({
    super.key,
    required this.icon,
    required this.onClicked,
    this.backgroundColor = Colors.white,
    this.hoveredBgColor = Colors.black,
    this.color = Colors.black,
    this.hoveredColor = Colors.white,
    this.hoveredBorderColor = Colors.black,
    this.borderColor = Colors.red,
    this.width = 140,
    this.radius = 5,
    this.aspect,
    this.iconSize,
    this.borderWidth,
    this.fontSize = 13,
  }) : text = null;

  /// Text displayed by the button.
  ///
  /// Mutually exclusive with [icon].
  final String? text;

  /// Icon displayed by the button.
  ///
  /// Mutually exclusive with [text].
  final IconData? icon;

  /// Called when the button is tapped.
  final VoidCallback onClicked;

  /// Background color when the button is not hovered.
  final Color backgroundColor;

  /// Background color while the pointer is hovering over the button.
  final Color hoveredBgColor;

  /// Foreground color when the button is not hovered.
  final Color color;

  /// Foreground color while hovering.
  final Color hoveredColor;

  /// Border color while hovering.
  final Color hoveredBorderColor;

  /// Border color when the button is not hovered.
  final Color borderColor;

  /// Button width.
  final double width;

  /// Border radius.
  final double radius;

  /// Optional width-to-height aspect ratio.
  ///
  /// When provided:
  /// `height = width / aspect`.
  ///
  /// Otherwise, the button height is `35`.
  final double? aspect;

  /// Optional icon size.
  final double? iconSize;

  /// Border thickness.
  final double? borderWidth;

  /// Text font size.
  final double fontSize;

  @override
  State<PrimaryOutlinedButton> createState() => _PrimaryOutlinedButtonState();
}

class _PrimaryOutlinedButtonState extends State<PrimaryOutlinedButton> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered == value) return;

    setState(() {
      _isHovered = value;
    });
  }

  double get _height {
    final aspect = widget.aspect;

    return aspect != null && aspect > 0 ? widget.width / aspect : 35;
  }

  BorderRadius get _borderRadius {
    return BorderRadius.circular(widget.radius);
  }

  Color get _backgroundColor {
    return _isHovered ? widget.hoveredBgColor : widget.backgroundColor;
  }

  Color get _foregroundColor {
    return _isHovered ? widget.hoveredColor : widget.color;
  }

  Color get _borderColor {
    return _isHovered ? widget.hoveredBorderColor : widget.borderColor;
  }

  Widget _buildContent(BuildContext context) {
    final theme = context.watch<TenetEssentialThemeData>();

    if (widget.icon != null) {
      return Icon(widget.icon, size: widget.iconSize, color: _foregroundColor);
    }

    return Text(
      widget.text ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: theme.fontFamily,
        color: _foregroundColor,
        fontSize: widget.fontSize,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: SizedBox(
        width: widget.width,
        height: _height,
        child: Material(
          color: _backgroundColor,
          borderRadius: _borderRadius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onClicked,
            borderRadius: _borderRadius,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _borderColor,
                  width: widget.borderWidth ?? 2.5,
                ),
                borderRadius: _borderRadius,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: _buildContent(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

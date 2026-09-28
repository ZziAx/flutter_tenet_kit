import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../builders/hover_tracker.dart';
import '../theme/TenetEssentialThemeData.dart';

/// A controlled checkbox with an optional label.
///
/// The checked state is owned by the parent through [value].
/// [onChanged] is called with the new value when the checkbox is tapped.
class PrimaryCheckbox extends StatelessWidget {
  const PrimaryCheckbox({
    super.key,
    this.value = false,
    this.label,
    required this.onChanged,
  });

  /// Whether the checkbox is currently selected.
  final bool value;

  /// Optional label displayed beside the checkbox.
  final String? label;

  /// Called when the checkbox value changes.
  final ValueChanged<bool> onChanged;

  static const double _size = 16;
  static const double _hoverSize = 15;
  static const double _spacing = 8;
  static const double _borderRadius = 4;
  static const double _innerBorderRadius = 2;
  static const double _borderWidth = 2;
  static const Duration _animationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<TenetEssentialThemeData>();

    return HoverTracker(
      builder: (isHovered) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(!value),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: _spacing,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (label != null) _buildLabel(theme),
              _buildCheckbox(
                selectedColor: theme.primaryColor,
                isHovered: isHovered,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(TenetEssentialThemeData theme) {
    return Text(
      label!,
      style: TextStyle(
        fontFamily: theme.fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildCheckbox({
    required Color selectedColor,
    required bool isHovered,
  }) {
    final size = isHovered ? _hoverSize : _size;

    return AnimatedContainer(
      duration: _animationDuration,
      width: size,
      height: size,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(
          color: value ? selectedColor : Colors.black,
          width: _borderWidth,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: value ? selectedColor : Colors.white,
          borderRadius: BorderRadius.circular(_innerBorderRadius),
        ),
      ),
    );
  }
}

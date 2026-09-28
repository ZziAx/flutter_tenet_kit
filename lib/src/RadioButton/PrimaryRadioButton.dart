import 'package:flutter/material.dart';

/// A compact, non-interactive radio button indicator.
///
/// This widget only represents the selected state visually.
/// Selection state and interaction should be managed by the parent.
///
/// Example:
/// `dart
/// RadioButtonV1(
///   selected: isSelected,
/// )
/// `
class RadioButtonV1 extends StatelessWidget {
  /// Creates a radio button indicator.
  const RadioButtonV1({super.key, this.selected = false});

  /// Whether the radio button is currently selected.
  final bool selected;

  static const double _size = 14;
  static const double _borderWidth = 0.5;
  static const double _innerPadding = 2;

  static const Color _borderColor = Colors.black;
  static const Color _backgroundColor = Colors.white;
  static const Color _selectedColor = Color.fromARGB(255, 1, 0, 71);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      padding: const EdgeInsets.all(_innerPadding),
      decoration: BoxDecoration(
        color: _backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: _borderColor, width: _borderWidth),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? _selectedColor : Colors.transparent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

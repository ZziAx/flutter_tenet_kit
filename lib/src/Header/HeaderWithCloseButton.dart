import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/TenetEssentialThemeData.dart';

/// A reusable header with a title and close action.
class HeaderV3 extends StatelessWidget {
  const HeaderV3({
    super.key,
    required this.title,
    required this.onClosed,
  });

  /// Header title.
  final String title;

  /// Called when the close button is pressed.
  final VoidCallback onClosed;

  static const double _closeButtonSize = 20;
  static const double _iconSize = 18;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<TenetEssentialThemeData>();

    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCloseButton(),
          Text(
            title,
            style: TextStyle(
              fontFamily: theme.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return SizedBox.square(
      dimension: _closeButtonSize,
      child: IconButton(
        onPressed: onClosed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        splashRadius: _closeButtonSize / 2,
        icon: const Icon(
          Icons.clear,
          size: _iconSize,
        ),
        tooltip: 'بستن',
      ),
    );
  }
}

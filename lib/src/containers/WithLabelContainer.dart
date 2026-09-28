import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/TenetEssentialThemeData.dart';

/// Displays a label above [child], optionally with a leading widget
/// and trailing actions.
class WithLabelContainer extends StatelessWidget {
  const WithLabelContainer({
    super.key,
    required this.label,
    required this.child,
    this.lead,
    this.showLabel = true,
    this.size,
    this.actions,
    this.mainAxisAlignment,
    this.crossAxisAlignment = CrossAxisAlignment.end,
  });

  /// Label displayed above the content.
  final String label;

  /// Main content displayed below the label.
  final Widget child;

  /// Optional widget displayed next to the label.
  final Widget? lead;

  /// Whether the label/header should be displayed.
  final bool showLabel;

  /// Font size of the label.
  final double? size;

  /// Optional trailing widgets displayed in the header.
  final List<Widget>? actions;

  /// Controls the horizontal alignment of the header.
  ///
  /// When omitted, the alignment defaults to [MainAxisAlignment.spaceBetween]
  /// when [actions] are provided, otherwise [MainAxisAlignment.start].
  final MainAxisAlignment? mainAxisAlignment;

  /// Cross-axis alignment of the outer column.
  final CrossAxisAlignment crossAxisAlignment;

  static const double _spacing = 5;
  static const double _labelSpacing = 7;
  static const double _leadSize = 18;
  static const double _defaultFontSize = 13;

  @override
  Widget build(BuildContext context) {
    if (!showLabel) {
      return child;
    }

    final theme = context.watch<TenetEssentialThemeData>();

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: _spacing,
      children: [
        _buildHeader(theme),
        child,
      ],
    );
  }

  Widget _buildHeader(TenetEssentialThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: _resolveMainAxisAlignment(),
      textDirection: TextDirection.rtl,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: _labelSpacing,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: theme.fontFamily,
                fontSize: size ?? _defaultFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            if (lead != null) _buildLead(),
          ],
        ),
        if (actions != null) ...actions!,
      ],
    );
  }

  Widget _buildLead() {
    return Opacity(
      opacity: 0.8,
      child: SizedBox.square(
        dimension: _leadSize,
        child: lead!,
      ),
    );
  }

  MainAxisAlignment _resolveMainAxisAlignment() {
    return mainAxisAlignment ??
        (actions != null
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start);
  }
}

import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';

import '../shadow_store/shadow_store.dart';
import '../theme/TenetEssentialThemeData.dart';

/// Configuration for the optional header displayed by [OverlayWidgetV1].
class HeaderConfig {
  const HeaderConfig({
    this.title,
    this.onClosed,
    this.onConfirmed,
    this.onAdded,
    this.actions,
    this.addBuilder,
    this.separator = false,
    this.svg,
  });

  final String? title;

  final VoidCallback? onClosed;
  final VoidCallback? onConfirmed;
  final VoidCallback? onAdded;

  final List<Widget>? actions;

  final Widget Function(Widget child)? addBuilder;

  final bool separator;

  final String? svg;
}

/// A reusable surface intended for popup/overlay content.
///
/// The optional [T] generic allows the widget to rebuild when a
/// [ChangeNotifier] provided above it changes.
class OverlayWidgetV1<T extends ChangeNotifier> extends StatelessWidget {
  const OverlayWidgetV1({
    super.key,
    required this.child,
    this.header,
    this.width = 150,
    this.shadow = false,
    this.padding = 15,
    this.decoration,
  });

  final Widget child;

  final HeaderConfig? header;

  final double width;

  final bool shadow;

  final double padding;

  /// Optional custom decoration.
  ///
  /// When omitted, the default overlay decoration is used.
  final BoxDecoration? decoration;

  static const double _borderRadius = 8;
  static const double _innerBorderRadius = 7;
  static const double _borderWidth = 1;
  static const double _headerHeight = 20;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<TenetEssentialThemeData>();

    return Consumer<T>(
      builder: (context, _, child) {
        return _buildOverlay(
          context,
          theme,
        );
      },
    );
  }

  Widget _buildOverlay(
    BuildContext context,
    TenetEssentialThemeData theme,
  ) {
    final outerDecoration = decoration ?? _buildDefaultDecoration();

    final innerDecoration = BoxDecoration(
      color: outerDecoration.color ?? Colors.white,
      borderRadius: BorderRadius.circular(_innerBorderRadius),
      border: outerDecoration.border,
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_borderRadius),
      child: Container(
        width: width,
        decoration: outerDecoration,
        padding: const EdgeInsets.all(_borderWidth),
        child: Container(
          decoration: innerDecoration,
          padding: EdgeInsets.all(padding),
          child: _buildContent(theme),
        ),
      ),
    );
  }

  BoxDecoration _buildDefaultDecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: shadow ? ShadowStore.shadowV2 : null,
      borderRadius: BorderRadius.circular(_borderRadius),
      border: const GradientBoxBorder(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black12,
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildContent(TenetEssentialThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: padding,
      children: [
        if (header != null) _buildHeader(theme),
        if (header?.separator ?? false) _buildSeparator(),
        child,
      ],
    );
  }

  Widget _buildHeader(TenetEssentialThemeData theme) {
    final config = header!;

    return SizedBox(
      height: _headerHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (config.actions != null)
            Expanded(
              child: Row(
                children: config.actions!,
              ),
            )
          else
            const Spacer(),

          Text(
            config.title ?? '',
            style: TextStyle(
              fontFamily: theme.fontFamily,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return const SizedBox(
      height: 1,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black12,
              Colors.black26,
              Colors.black12,
            ],
          ),
        ),
      ),
    );
  }
}

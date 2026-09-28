import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that tracks pointer hover events and exposes the hover state
/// to its child builder.
///
/// When [enabled] is `false`, hover tracking is disabled and the builder
/// is always called with `false`.
///
/// Example:
/// `dart
/// HoverTracker(
///   builder: (isHovered) => Container(
///     color: isHovered ? Colors.blue : Colors.grey,
///     child: const Text('Hover me'),
///   ),
/// )
/// `
class HoverTracker extends StatefulWidget {
  /// Builds the child using the current hover state.
  final Widget Function(bool isHovered) builder;

  /// Whether hover tracking is enabled.
  ///
  /// Defaults to `true`.
  final bool enabled;

  /// The mouse cursor displayed while hovering over the widget.
  ///
  /// Defaults to [SystemMouseCursors.click].
  final SystemMouseCursor cursor;

  /// Called when the pointer enters the widget.
  final VoidCallback? onEnter;

  /// Called when the pointer leaves the widget.
  final VoidCallback? onExit;

  const HoverTracker({
    super.key,
    required this.builder,
    this.enabled = true,
    this.cursor = SystemMouseCursors.click,
    this.onEnter,
    this.onExit,
  });

  @override
  State<HoverTracker> createState() => _HoverTrackerState();
}

class _HoverTrackerState extends State<HoverTracker> {
  bool _isHovered = false;

  /// Updates the hover state only when it actually changes.
  void _updateHoverState(bool isHovered) {
    if (_isHovered == isHovered) return;

    setState(() => _isHovered = isHovered);

    if (isHovered) {
      widget.onEnter?.call();
    } else {
      widget.onExit?.call();
    }
  }

  @override
  void didUpdateWidget(covariant HoverTracker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset the hover state when tracking is disabled.
    if (oldWidget.enabled && !widget.enabled) {
      _isHovered = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Avoid creating a MouseRegion when hover tracking is disabled.
    if (!widget.enabled) {
      return widget.builder(false);
    }

    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => _updateHoverState(true),
      onExit: (_) => _updateHoverState(false),
      child: widget.builder(_isHovered),
    );
  }
}

import 'package:flutter/material.dart';

/// Visually disables [child] and prevents it from receiving pointer events.
///
/// When [enabled] is false, the child is rendered with reduced opacity and
/// pointer interaction is ignored.
class DisabledWidget extends StatelessWidget {
  const DisabledWidget({
    super.key,
    required this.child,
    this.enabled = true,
  });

  /// Widget to enable or disable.
  final Widget child;

  /// Whether the child should remain interactive.
  final bool enabled;

  static const double _disabledOpacity = 0.4;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : _disabledOpacity,
        duration: const Duration(milliseconds: 150),
        child: child,
      ),
    );
  }
}

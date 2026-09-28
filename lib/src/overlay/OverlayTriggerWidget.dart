import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/TenetEssentialTheme.dart';
import '../theme/TenetEssentialThemeData.dart';

/// Determines which pointer action opens/closes the overlay.
enum OverlayTriggerAction {
  tap,
  secondaryTap,
}

/// Displays an overlay when the child is triggered.
///
/// The overlay is positioned relative to the child unless [position] is
/// provided explicitly.
///
/// Example:
/// ```dart
/// OverlayTriggerWidget(
///   child: const Icon(Icons.info),
///   overlay: (hide) => MyOverlay(onClose: hide),
/// )
/// ```
class OverlayTriggerWidget extends StatefulWidget {
  const OverlayTriggerWidget({
    super.key,
    required this.child,
    required this.overlay,
    this.onShown,
    this.onHidden,
    this.position,
    this.overlayContext,
    this.background,
    this.triggerAction = OverlayTriggerAction.tap,
    this.enabled = true,
    this.dismissible = true,
    this.backgroundColor,
    this.offset = const Offset(-30, 20),
  });

  /// Widget that triggers the overlay.
  final Widget child;

  /// Builds the overlay.
  ///
  /// The callback passed to this builder hides the overlay.
  final Widget Function(VoidCallback hide) overlay;

  /// Called after the overlay is shown.
  final VoidCallback? onShown;

  /// Called after the overlay is hidden.
  final VoidCallback? onHidden;

  /// Explicit global position for the overlay.
  ///
  /// If null, the position of [child] is used.
  final Offset? position;

  /// Optional context whose nearest [Overlay] should receive the entry.
  ///
  /// Usually this can be omitted.
  final BuildContext? overlayContext;

  /// Optional widget displayed behind the overlay.
  final Widget? background;

  /// Determines which pointer action triggers the overlay.
  final OverlayTriggerAction triggerAction;

  /// Whether the widget can display the overlay.
  final bool enabled;

  /// Whether tapping the background dismisses the overlay.
  final bool dismissible;

  /// Background color used when [background] isn't supplied.
  final Color? backgroundColor;

  /// Position offset relative to the calculated child position.
  final Offset offset;

  @override
  State<OverlayTriggerWidget> createState() =>
      _OverlayTriggerWidgetState();
}

class _OverlayTriggerWidgetState
    extends State<OverlayTriggerWidget> {
  final GlobalKey _childKey = GlobalKey();

  OverlayEntry? _overlayEntry;

  bool get _isVisible => _overlayEntry != null;

  void _toggleOverlay() {
    if (_isVisible) {
      _hideOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    if (!widget.enabled || _isVisible) {
      return;
    }

    final renderObject =
        _childKey.currentContext?.findRenderObject();

    if (renderObject is! RenderBox ||
        !renderObject.hasSize) {
      return;
    }

    final rect = renderObject.localToGlobal(
          Offset.zero,
        ) &
        renderObject.size;

    final overlayPosition = Offset(
      widget.position?.dx ?? rect.left,
      widget.position?.dy ?? rect.top,
    );

    final overlay = OverlayEntry(
      builder: (context) {
        final theme =
            context.read<TenetEssentialThemeData>();

        return TenetEssentialTheme(
          theme: theme,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: widget.dismissible
                        ? _hideOverlay
                        : null,
                    child: widget.background ??
                        ColoredBox(
                          color: widget.backgroundColor ??
                              Colors.transparent,
                        ),
                  ),
                ),
                Positioned(
                  left: overlayPosition.dx +
                      widget.offset.dx,
                  top: overlayPosition.dy +
                      widget.offset.dy,
                  child: widget.overlay(_hideOverlay),
                ),
              ],
            ),
          ),
        );
      },
    );

    _overlayEntry = overlay;

    Overlay.of(
      widget.overlayContext ?? context,
    ).insert(overlay);

    widget.onShown?.call();
  }

  void _hideOverlay() {
    final overlay = _overlayEntry;

    if (overlay == null) {
      return;
    }

    _overlayEntry = null;

    overlay.remove();
    overlay.dispose();

    widget.onHidden?.call();
  }

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      key: _childKey,
      onTap: widget.triggerAction ==
              OverlayTriggerAction.tap
          ? _toggleOverlay
          : null,
      onSecondaryTap:
          widget.triggerAction ==
                  OverlayTriggerAction.secondaryTap
              ? _toggleOverlay
              : null,
      child: widget.child,
    );

    return child;
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }
}

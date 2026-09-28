import 'package:flutter/material.dart';
import '../builders/hover_tracker.dart';

class HoverScaleAnimation extends StatefulWidget {
  Widget child;
  double hoverScale;
  double baseScale;
  bool enabled;

  HoverScaleAnimation({
    super.key,
    this.baseScale = 1.0,
    this.hoverScale = 1.05,
    this.enabled = true,
    required this.child,
  });

  @override
  State<HoverScaleAnimation> createState() => _HoverScaleAnimationState();
}

class _HoverScaleAnimationState extends State<HoverScaleAnimation> {
  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }
    return HoverTracker(
      builder: (isHovered) {
        return AnimatedScale(
          scale: isHovered ? widget.hoverScale : widget.baseScale,
          duration: Duration(milliseconds: 100),
          curve: Curves.linear,
          child: widget.child,
        );
      },
    );
  }
}

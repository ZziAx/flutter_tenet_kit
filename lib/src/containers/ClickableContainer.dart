import 'package:flutter/material.dart';
import 'package:flutter_tenet_kit/flutter_tenet_kit.dart';

// yadegari
// 09124834784

class ClickableContainer extends StatelessWidget {
  Widget child;
  VoidCallback ?onClicked;
  GestureTapDownCallback? onTapDown;

  bool enableHover;
  double radius;

  ClickableContainer({
    super.key,
    required this.child,
     this.onClicked,
     this.onTapDown,
    this.enableHover = true,
    this.radius = 10
  });

  @override
  Widget build(BuildContext context) {
    if (!enableHover) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,

        child: GestureDetector(
         
          onTap: onClicked,
          onTapDown: onTapDown,
          child: child,
        ),
      );
    }

    return HoverTracker(
      builder: (isHovered) {
        return Container(
          decoration: BoxDecoration(
          color: isHovered?const Color.fromARGB(31, 108, 108, 108):Colors.transparent,

            borderRadius: BorderRadius.circular(radius),

          ),
          child: GestureDetector(
            onTap: onClicked,
            onTapDown: onTapDown,
            child: Container(
              color: Colors.transparent,
              child: child),
          ),
        );
      }
    );
  }
}

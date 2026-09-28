import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/TenetEssentialThemeData.dart';

/// A customizable button with a gradient highlight and a glowing appearance.
///
/// Supports custom colors, height, typography, and click handling.
///
/// Example:
/// `dart
/// GlowButton(
///   label: 'تایید',
///   onClicked: () {},
/// )
/// `
class GlowButton extends StatelessWidget {
/// The text displayed inside the button.
final String label;

/// Called when the button is pressed.
final VoidCallback onClicked;

/// The button's background color.
final Color? backgroundColor;

/// The button label's color.
final Color? color;

/// The color used for the gradient highlight.
final Color? shadowColor;

/// The height of the button.
final double height;

/// The corner radius of the button.
final double borderRadius;

const GlowButton({
super.key,
this.label = 'تایید',
required this.onClicked,
this.backgroundColor,
this.color,
this.shadowColor,
this.height = 30,
this.borderRadius = 7,
});

@override
Widget build(BuildContext context) {
final theme = context.watch<TenetEssentialThemeData>();

final effectiveShadowColor = shadowColor ?? Colors.white;

return SizedBox(
  width: double.infinity,
  height: height,
  child: Material(
    color: backgroundColor ?? Colors.blueAccent,
    borderRadius: BorderRadius.circular(borderRadius),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onClicked,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Subtle vertical highlight to create the glow effect.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    effectiveShadowColor.withOpacity(0.1),
                    effectiveShadowColor.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),

          // Button label.
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: theme.fontFamily,
              color: color ?? Colors.white,
            ),
          ),
        ],
      ),
    ),
  ),
);

}
}

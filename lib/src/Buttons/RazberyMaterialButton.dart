import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

/// A customizable Material-style button with a gradient background,
/// gradient border, optional shadow, and flexible sizing.
///
/// The button can be created either with arbitrary [child] content or
/// with the convenience [RazberyMaterialbutton.text] constructor.
///
/// Example:
/// `dart
/// RazberyMaterialbutton.text(
///   text: 'Continue',
///   style: TextStyle(color: Colors.white),
///   onClicked: () {},
/// )
/// `
class RazberyMaterialbutton extends StatelessWidget {
/// Creates a button with arbitrary child content.
const RazberyMaterialbutton({
super.key,
required this.onClicked,
required this.child,
this.color = Colors.black,
this.shadow,
this.aspectRatio,
this.width,
this.height,
this.radius = const BorderRadius.all(
Radius.circular(10),
),
});

/// Creates a text-based button.
 RazberyMaterialbutton.text({
super.key,
required this.onClicked,
required String text,
required TextStyle style,
this.color = Colors.black,
this.shadow,
this.aspectRatio,
this.width,
this.height,
this.radius = const BorderRadius.all(
Radius.circular(10),
),
}) : child = Text(text, style: style);

/// Called when the button is tapped.
final VoidCallback onClicked;

/// The button's content.
final Widget child;

/// Base color used to generate the gradient background and border.
///
/// If `null`, the gradient background and gradient border are disabled.
final Color? color;

/// Optional shadow applied to the button.
final List<BoxShadow>? shadow;

/// Optional width-to-height aspect ratio.
///
/// When specified, [width] and [height] are ignored by [AspectRatio].
final double? aspectRatio;

/// Explicit button width.
final double? width;

/// Explicit button height.
final double? height;

/// The button's corner radius.
final BorderRadius radius;

static const double _borderWidth = 1.5;

Widget _buildDecoration() {
final color = this.color;

return DecoratedBox(
  decoration: BoxDecoration(
    gradient: color == null
        ? null
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.6),
              color,
            ],
          ),
    border: color == null
        ? null
        : GradientBoxBorder(
            width: _borderWidth,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.6),
                Colors.grey.shade200,
                color.withOpacity(0.2),
              ],
            ),
          ),
    borderRadius: radius,
    boxShadow: shadow,
  ),
  child: ClipRRect(
    borderRadius: radius,
    child: Center(
      child: child,
    ),
  ),
);

}

Widget _buildSizedButton() {
final content = _buildDecoration();

if (aspectRatio != null) {
  return AspectRatio(
    aspectRatio: aspectRatio!,
    child: content,
  );
}

return SizedBox(
  width: width,
  height: height,
  child: content,
);

}

@override
Widget build(BuildContext context) {
return Material(
color: Colors.transparent,
borderRadius: radius,
child: InkWell(
onTap: onClicked,
borderRadius: radius,
child: _buildSizedButton(),
),
);
}
}

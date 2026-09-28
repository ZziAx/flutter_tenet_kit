import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../animations/hover_scale_animation.dart';
import '../builders/hover_tracker.dart';
import '../theme/TenetEssentialThemeData.dart';

/// A reusable text label that follows the application's typography.
class PrimaryTextButton extends StatelessWidget {
final String text;
final Color? color;
final double fontSize;
final TextAlign textAlign;

const PrimaryTextButton({
super.key,
required this.text,
this.color = Colors.black,
this.fontSize = 13,
this.textAlign = TextAlign.center,
});

@override
Widget build(BuildContext context) {
final theme = context.watch<TenetEssentialThemeData>();

return Text(
  text,
  textAlign: textAlign,
  style: TextStyle(
    color: color,
    fontFamily: theme.fontFamily,
    fontSize: fontSize,
  ),
);

}
}

/// A customizable primary button with optional hover scaling,
/// gradient styling, and a dropdown-style layout.
///
/// Use [PrimaryButton.dropDown] to create a button with a leading
/// action icon, a separator, and optional trailing content.
class PrimaryButton extends StatelessWidget {
/// The button's main text.
final String text;

/// The colors used by the background gradient.
final List<Color> colors;

/// Optional custom content displayed instead of the default text.
final Widget? child;

/// Whether the button scales when hovered.
final bool enableHoverScale;

/// Whether the button displays an inner shadow.
///
/// Retained for API compatibility. No inner shadow is currently
/// rendered by this implementation.
final bool enableInnerShadow;

/// Whether the dropdown button has a separate leading action area.
final bool separatePortion;

/// The callback invoked when the main button is tapped.
final VoidCallback? onClicked;

/// Called when a pointer presses down on the button.
final GestureTapDownCallback? onTapDown;

/// Custom button decoration.
final BoxDecoration? decoration;

/// The button's corner radius.
final BorderRadius borderRadius;

/// Optional callback for the leading dropdown icon.
final VoidCallback? onIconClicked;

/// Optional callback for the dropdown's main content.
final VoidCallback? onContentClicked;

/// Icon displayed at the beginning of a dropdown button.
final IconData? leadIcon;

/// Icon displayed after the dropdown's content.
final IconData? textIcon;

/// Padding around the dropdown content.
final EdgeInsetsGeometry contentPadding;

/// Whether this instance uses the dropdown layout.
final bool _isDropdown;

const PrimaryButton({
super.key,
required this.text,
this.onClicked,
this.onTapDown,
this.colors = const [Colors.white, Colors.white],
this.enableHoverScale = true,
this.enableInnerShadow = true,
this.separatePortion = true,
this.borderRadius = const BorderRadius.all(Radius.circular(10)),
this.decoration,
})  : child = null,
onIconClicked = null,
onContentClicked = null,
leadIcon = null,
textIcon = null,
contentPadding = const EdgeInsets.symmetric(horizontal: 9),
_isDropdown = false;

const PrimaryButton.dropDown({
super.key,
required this.text,
this.onClicked,
this.onTapDown,
this.onIconClicked,
this.onContentClicked,
this.colors = const [Colors.white, Colors.white],
this.enableHoverScale = true,
this.enableInnerShadow = true,
this.separatePortion = true,
this.leadIcon = Icons.keyboard_arrow_down,
this.textIcon = Icons.add,
this.child,
this.contentPadding = const EdgeInsets.symmetric(horizontal: 9),
this.decoration,
this.borderRadius = const BorderRadius.all(Radius.circular(10)),
}) : _isDropdown = true;

static const double _height = 60;
static const double _minimumWidth = 100;

static const Color _defaultIconColor = Colors.black;
static final Color _accentColor = HexColor('#6929f2');
static final Color _hoverColor = HexColor('#f5f5f5');

/// Builds the button's main text or custom content.
Widget _buildContent() {
if (!_isDropdown) {
return PrimaryTextButton(text: text);
}

return child ?? PrimaryTextButton(text: text);

}

/// Builds the optional leading icon and its independent interaction.
Widget _buildLeadingIcon() {
if (leadIcon == null) {
return const SizedBox.shrink();
}

return GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: !separatePortion && onTapDown == null
      ? onIconClicked
      : null,
  onTapDown: separatePortion ? onTapDown : null,
  child: HoverScaleAnimation(
    enabled: onIconClicked != null,
    child: HoverTracker(
      builder: (isHovered) {
        return Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isHovered ? _hoverColor : Colors.transparent,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Icon(
            leadIcon,
            color: _defaultIconColor,
            size: 15,
          ),
        );
      },
    ),
  ),
);

}

/// Builds the optional trailing icon.
Widget _buildTrailingIcon() {
if (textIcon == null) {
return const SizedBox.shrink();
}

return Transform.scale(
  scale: 0.8,
  child: AspectRatio(
    aspectRatio: 1,
    child: Padding(
      padding: const EdgeInsets.all(2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          textIcon,
          size: 18,
          color: _accentColor,
        ),
      ),
    ),
  ),
);

}

/// Builds the dropdown layout, including its separator.
Widget _buildDropdownContent() {
return Row(
mainAxisSize: MainAxisSize.min,
spacing: leadIcon != null ? 5 : 0,
children: [
_buildLeadingIcon(),
if (leadIcon != null)
Container(
width: 1,
height: double.infinity,
color: Colors.black12,
),
GestureDetector(
behavior: HitTestBehavior.opaque,
onTap: onContentClicked,
child: Padding(
padding: contentPadding,
child: Row(
mainAxisSize: MainAxisSize.min,
mainAxisAlignment: MainAxisAlignment.center,
spacing: textIcon != null ? 7 : 0,
children: [
_buildContent(),
_buildTrailingIcon(),
],
),
),
),
],
);
}

/// Builds the button's background decoration.
BoxDecoration _buildDecoration() {
return decoration ??
BoxDecoration(
color: Colors.white,
borderRadius: borderRadius,
border: Border.all(
width: 1,
color: Colors.black54,
),
gradient: LinearGradient(
tileMode: TileMode.mirror,
colors: colors,
),
);
}

@override
Widget build(BuildContext context) {
return HoverScaleAnimation(
enabled: enableHoverScale,
child: GestureDetector(
behavior: HitTestBehavior.opaque,
onTap: onClicked,
onTapDown: onTapDown,
child: Container(
height: _height,
constraints: const BoxConstraints(
minWidth: _minimumWidth,
),
padding: const EdgeInsets.symmetric(
horizontal: 5,
vertical: 3,
),
decoration: _buildDecoration(),
child: _isDropdown
? _buildDropdownContent()
: Center(child: _buildContent()),
),
),
);
}
}

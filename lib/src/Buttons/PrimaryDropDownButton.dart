import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../builders/hover_tracker.dart';
import '../Buttons/PrimaryButton.dart';
import '../containers/OverlayWidgetV1.dart';
import '../theme/TenetEssentialThemeData.dart';

class DropdownItem {
  String value;
  dynamic identifier;
  IconData? icon;
  String? svg;
  Color? color;
  double? size;
  Widget Function(Widget, Function, BuildContext)? builder;
  DropdownItem({
    required this.value,
    required this.identifier,
    this.svg,
    this.icon,
    this.color,
    this.builder,
    this.size,
  });
}

class DropdownCheckboxItem extends DropdownItem {
  bool selected;
  DropdownCheckboxItem({
    required super.value,
    required super.identifier,
    this.selected = false,
  });
}

enum OverlayAlignment { left, right, bottom }

class Primarydropdown extends StatefulWidget {
  Widget? child;
  String? _label;
  OverlayAlignment alignment;

  Widget Function(VoidCallback)? _dropdownWidgetBuilder;

  List<DropdownItem>? _items;
  List<DropdownItem>? bottom;
  String triggerAction;
  Function onSelected;
  String defaultItem;
  Color color;
  bool tapToHide;
  BoxDecoration? decoration;
  double? itemHeight;
  double? width;

  Primarydropdown({
    super.key,
    String? label,
    required this.alignment,
    required List<DropdownItem> items,
    required this.onSelected,
    required this.defaultItem,
    this.width,
    this.itemHeight,
    this.tapToHide = true,
    this.triggerAction = "tap",
    this.bottom,
    this.color = Colors.grey,
    this.decoration,
    this.child,
  }) : _label = label,
       _items = items;

  Primarydropdown.custom({
    super.key,
    required String label,
    Widget Function(VoidCallback)? dropdownWidgetBuilder,
    required this.onSelected,
    required this.defaultItem,
    required this.alignment,
    this.tapToHide = true,
    this.triggerAction = "tap",

    this.bottom,
    this.color = Colors.grey,
    this.child,
  }) : _dropdownWidgetBuilder = dropdownWidgetBuilder,
       _label = label;

  @override
  State<Primarydropdown> createState() => _PrimarydropdownState();
}

class _PrimarydropdownState extends State<Primarydropdown> {
  OverlayEntry? _overlay;

  void _showOverlay(TapDownDetails details) {
    _overlay = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (!widget.tapToHide) return;
                    _hideOverlay();
                  },

                  child: Container(color: Colors.transparent),
                ),
              ),

              Positioned(
                left:
                    details.globalPosition.dx -
                    (widget.alignment == OverlayAlignment.left ? 150 : 0),
                top:
                    details.globalPosition.dy +
                    (widget.alignment == OverlayAlignment.bottom ? 10 : 0),
                child:
                    widget._dropdownWidgetBuilder?.call(_hideOverlay) ??
                    OverlayWidgetV1(
                      width: widget.width ?? 180,
                      child: Column(
                        children: [
                          // Expanded(
                          //   child: Column(
                          //     children: [
                                ...List.generate(widget._items!.length, (i) {
                                  DropdownItem value = widget._items![i];
                                  return DropdownItemWidget(item: value);
                                }),
                          //     ],
                          //   ),
                          // ),

                          if (widget.bottom?.isNotEmpty ?? false)
                            SizedBox(height: 30),
                          ...(widget.bottom ?? []).map((b) {
                            return DropdownItemWidget(item: b);
                          }),
                        ],
                      ),
                    ),
              ),
            ],
          ),
    );

    Overlay.of(context).insert(_overlay!);
  }

  void _hideOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  final link = LayerLink();

  @override
  Widget build(BuildContext context) {
    if (widget.child != null) {
      return CompositedTransformTarget(
        link: link,
        child: GestureDetector(
          onTapDown:
              widget.triggerAction == "tap" ? _handleTriggerAction : null,
          onSecondaryTapDown:
              widget.triggerAction == "secondary" ? _handleTriggerAction : null,
          child: widget.child,
        ),
      );
    }

    final theme = context.watch<TenetEssentialThemeData>();

    return CompositedTransformTarget(
      link: link,

      child: Row(
        children: [
          if (widget._label != null)
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                widget._label.toString(),
                style: TextStyle(fontFamily: theme.fontFamily, fontSize: 12),
              ),
            ),
          PrimaryButton.dropDown(
            colors: [widget.color, widget.color],
            enableHoverScale: false,
            enableInnerShadow: false,
            textIcon: null,
            decoration: widget.decoration,
            onTapDown: (d) {
              if (_overlay == null) {
                _showOverlay(d);
              } else {
                _hideOverlay();
              }
            },
            text: widget.defaultItem,
          ),
        ],
      ),
    );
  }

  Widget DropdownItemWidget({required DropdownItem item}) {
    final theme = context.watch<TenetEssentialThemeData>();

    Color color = item.color??Colors.black;

    IconData? icon = item.icon;
    String? svg = item.svg;

    // icon =
    //     icon != null
    //         ? Container(margin: EdgeInsets.only(left: 10), child: icon)
    //         : null;

    final child = HoverTracker(
      builder: (isHovered) {
        Color _color = isHovered ? (color!.withOpacity(0.5)) : (color!);
        return Container(
          height: widget.itemHeight ?? 35,
          padding: EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.centerRight,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: AutoSizeText(
                  item.value,
                  maxLines: 1,
                  textDirection: TextDirection.rtl,
                  maxFontSize: 12,
                  style: TextStyle(fontFamily: theme.fontFamily, color: _color),
                ),
              ),

              if (icon != null)
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Icon(icon, color: _color, size: item.size),
                ),
            ],
          ),
        );
      },
    );

    if (item.builder != null) {
      return item.builder!(child, _hideOverlay, context);
    }
    return GestureDetector(
      onTap: () {
        widget.onSelected(item);
        _hideOverlay();
      },
      child: child,
    );
  }

  _handleTriggerAction(TapDownDetails details) {
    if (_overlay == null) {
      _showOverlay(details);
    } else {
      _hideOverlay();
    }
  }
}

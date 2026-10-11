import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tenet_kit/src/containers/ClickableContainer.dart';
import 'package:tenet_svg_collection/tenet_svg_collection.dart';

class OptionsRow extends StatelessWidget {
  bool visible;
  Function? onEdit;
  Function? onRemoved;
  Function? onView;
  

  Widget Function(Widget)? onViewBuilder;
  Widget Function(Widget)? onEditBuilder;


  Function? onCopied;
  MainAxisAlignment mainAxisAlignment;

  Color color;
  TextDirection textDirection;

  OptionsRow({
    super.key,
    this.onRemoved,
    this.onEdit,
    this.onView,
    this.onViewBuilder,
    this.onEditBuilder,
    this.onCopied,
    this.visible = true,
    this.color = Colors.white,
    this.textDirection = TextDirection.rtl,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Opacity(
        opacity: visible ? 1.0 : 0,
        child: Container(
          padding: EdgeInsets.only(left: 5),
          child: Row(
            spacing: 8,
            mainAxisAlignment: mainAxisAlignment,
            textDirection: textDirection,
            children: [
              if (onView != null)
                ClickableContainer(
                  enableHover: false,
                  onClicked: () {
                    onView!.call();
                  },
                  child: SvgPicture.string(
                    SvgCollection.grid,
                    color: color,
                    width: 10,
                    height: 10,
                  ),
                ),
              
              if(onViewBuilder !=null) onViewBuilder!(
                SvgPicture.string(
                    SvgCollection.grid,
                    color: color,
                    width: 10,
                    height: 10,
                  )
              ),
              if (onCopied != null)
                ClickableContainer(
                  enableHover: false,
                  onClicked: () {
                    onCopied?.call();
                  },
                  child: SvgPicture.string(
                    SvgCollection.copy,
                    color: color,
                    width: 10,
                    height: 10,
                  ),
                ),
                if(onEditBuilder !=null) onEditBuilder!(
                SvgPicture.string(
                    SvgCollection.pen,
                    color: color,
                    width: 12,
                    height: 12,
                  )
              ),
              if (onEdit != null)
                ClickableContainer(
                  enableHover: false,
                  onClicked: () {
                    onEdit!.call();
                  },
                  child: SvgPicture.string(
                    SvgCollection.pen,
                    color: color,
                    width: 12,
                    height: 12,
                  ),
                ),
    
              if (onRemoved != null)
                ClickableContainer(
                  enableHover: false,
                  onClicked: () {
                    onRemoved!.call();
                  },
                  child: Icon(Icons.clear, size: 12, color: color),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

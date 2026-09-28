// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';

// class OptionsRow extends StatelessWidget {
//   bool visible;
//   Function? onEdit;
//   Function? onRemoved;
//   Function? onView;
  

//   Widget Function(Widget)? onViewBuilder;
//   Widget Function(Widget)? onEditBuilder;


//   Function? onCopied;
//   MainAxisAlignment mainAxisAlignment;

//   Color color;
//   TextDirection textDirection;

//   OptionsRow({
//     super.key,
//     this.onRemoved,
//     this.onEdit,
//     this.onView,
//     this.onViewBuilder,
//     this.onEditBuilder,
//     this.onCopied,
//     this.visible = true,
//     this.color = Colors.white,
//     this.textDirection = TextDirection.ltr,
//     this.mainAxisAlignment = MainAxisAlignment.center,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 20,
//       child: Opacity(
//         opacity: visible ? 1.0 : 0,
//         child: Container(
//           padding: EdgeInsets.only(left: 5),
//           child: Row(
//             spacing: 8,
//             mainAxisAlignment: mainAxisAlignment,
//             textDirection: textDirection,
//             children: [
//               if (onView != null)
//                 ClickableContainer(
//                   enableHover: false,
//                   onClicked: () {
//                     onView!.call();
//                   },
//                   child: SvgPicture.string(
//                     Grid_SVG,
//                     color: color,
//                     width: 10,
//                     height: 10,
//                   ),
//                 ),
              
//               if(onViewBuilder !=null) onViewBuilder!(
//                 SvgPicture.string(
//                     Grid_SVG,
//                     color: color,
//                     width: 10,
//                     height: 10,
//                   )
//               ),
//               if (onCopied != null)
//                 ClickableContainer(
//                   enableHover: false,
//                   onClicked: () {
//                     onCopied?.call();
//                   },
//                   child: Icon(Iconsax.copy, size: 10, color: color),
//                 ),
//                 if(onEditBuilder !=null) onEditBuilder!(
//                 ImageIcon(
//                     Image.asset("assets/icons/iedit.png").image,
//                     size: 10,
//                     color: color,
//                   )
//               ),
//               if (onEdit != null)
//                 ClickableContainer(
//                   enableHover: false,
//                   onClicked: () {
//                     onEdit!.call();
//                   },
//                   child: ImageIcon(
//                     Image.asset("assets/icons/iedit.png").image,
//                     size: 10,
//                     color: color,
//                   ),
//                 ),
    
//               if (onRemoved != null)
//                 ClickableContainer(
//                   enableHover: false,
//                   onClicked: () {
//                     onRemoved!.call();
//                   },
//                   child: Icon(Icons.clear, size: 12, color: color),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

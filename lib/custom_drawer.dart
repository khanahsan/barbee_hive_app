// import 'package:flutter/material.dart';
// import 'package:my_responsive_ui/my_responsive_ui.dart';
//
// class CustomDrawer extends StatefulWidget {
//   const CustomDrawer({
//     super.key,
//     required this.child,
//     required this.drawer,
//     this.backdropColor,
//     this.backdrop,
//     this.openRatio = 0.75,
//     this.openScale = 0.85,
//     this.initialDrawerScale = 0.75,
//     this.drawerSlideRatio = 0,
//     this.animationDuration = const Duration(milliseconds: 250),
//     this.animationCurve,
//     this.childDecoration,
//     this.animateChildDecoration = true,
//     this.rtlOpening = false,
//     this.disabledGestures = false,
//   });
//
//   final Widget child;
//   final Widget drawer;
//   final Color? backdropColor;
//   final Widget? backdrop;
//   final double openRatio;
//   final double openScale;
//   final double initialDrawerScale;
//   final double drawerSlideRatio;
//   final Duration animationDuration;
//   final Curve? animationCurve;
//   final BoxDecoration? childDecoration;
//   final bool animateChildDecoration;
//   final bool rtlOpening;
//   final bool disabledGestures;
//
//   @override
//   State<CustomDrawer> createState() => CustomDrawerState();
// }
//
// class CustomDrawerState extends State<CustomDrawer>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _drawerScaleAnimation;
//   late Animation<Offset> _childSlideAnimation;
//   late Animation<double> _childScaleAnimation;
//   late Animation<Offset> _drawerSlideAnimation;
//   late Animation<Decoration> _childDecorationAnimation;
//
//   bool _captured = false;
//   double _offsetValue = 0.0;
//   Offset? _startPosition;
//
//   void toggleDrawer() {
//     if (_animationController.isCompleted) {
//       _animationController.reverse();
//     } else {
//       _animationController.forward();
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: widget.animationDuration,
//     );
//
//     final parentAnimation =
//         widget.animationCurve == null
//             ? _animationController
//             : CurvedAnimation(
//               parent: _animationController,
//               curve: widget.animationCurve!,
//             );
//
//     _drawerScaleAnimation = Tween<double>(
//       begin: widget.initialDrawerScale,
//       end: 1.0,
//     ).animate(parentAnimation);
//
//     _drawerSlideAnimation = Tween<Offset>(
//       begin: Offset(-widget.drawerSlideRatio, 0),
//       end: Offset.zero,
//     ).animate(parentAnimation);
//
//     _childSlideAnimation = Tween<Offset>(
//       begin: Offset.zero,
//       end: Offset(widget.openRatio, 0),
//     ).animate(parentAnimation);
//
//     _childScaleAnimation = Tween<double>(
//       begin: 1.0,
//       end: widget.openScale,
//     ).animate(parentAnimation);
//
//     _childDecorationAnimation = DecorationTween(
//       begin: const BoxDecoration(),
//       end: widget.childDecoration,
//     ).animate(parentAnimation);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: widget.backdropColor,
//       child: GestureDetector(
//         onHorizontalDragStart:
//             widget.disabledGestures ? null : _handleDragStart,
//         onHorizontalDragUpdate:
//             widget.disabledGestures ? null : _handleDragUpdate,
//         onHorizontalDragEnd: widget.disabledGestures ? null : _handleDragEnd,
//         child: Stack(
//           children: [
//             if (widget.backdrop != null) widget.backdrop!,
//             Align(
//               alignment:
//                   widget.rtlOpening
//                       ? Alignment.centerRight
//                       : Alignment.centerLeft,
//               child: SlideTransition(
//                 position: _drawerSlideAnimation,
//                 child: FractionallySizedBox(
//                   widthFactor: widget.openRatio,
//                   child: ScaleTransition(
//                     scale: _drawerScaleAnimation,
//                     alignment:
//                         widget.rtlOpening
//                             ? Alignment.centerLeft
//                             : Alignment.centerRight,
//                     child: widget.drawer,
//                   ),
//                 ),
//               ),
//             ),
//             SlideTransition(
//               position: _childSlideAnimation,
//               textDirection:
//                   widget.rtlOpening ? TextDirection.rtl : TextDirection.ltr,
//               child: ScaleTransition(
//                 scale: _childScaleAnimation,
//                 alignment:
//                     widget.rtlOpening
//                         ? Alignment.centerRight
//                         : Alignment.centerLeft,
//                 child: Builder(
//                   builder: (_) {
//                     final childStack = Stack(
//                       clipBehavior: Clip.none,
//                       alignment: Alignment.center,
//                       children: [
//                         Positioned(
//                           left: -80.w,
//                           child: Container(
//                             width: 300.w,
//                             height: 700.h,
//                             decoration: BoxDecoration(
//                               color: Colors.blue,
//                               borderRadius: BorderRadius.circular(40.r),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           left: -40.w,
//                           child: Container(
//                             width: 300.w,
//                             height: 850.h,
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(40.r),
//                             ),
//                           ),
//                         ),
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(40.r),
//                           child: widget.child,
//                         ),
//                       ],
//                     );
//
//                     if (widget.animateChildDecoration &&
//                         widget.childDecoration != null) {
//                       return AnimatedBuilder(
//                         animation: _childDecorationAnimation,
//                         builder: (_, child) {
//                           return Container(
//                             clipBehavior: Clip.antiAlias,
//                             decoration: _childDecorationAnimation.value,
//                             child: child,
//                           );
//                         },
//                         child: childStack,
//                       );
//                     }
//
//                     return Container(
//                       clipBehavior:
//                           widget.childDecoration != null
//                               ? Clip.antiAlias
//                               : Clip.none,
//                       decoration: widget.childDecoration,
//                       child: childStack,
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _handleDragStart(DragStartDetails details) {
//     _captured = true;
//     _startPosition = details.globalPosition;
//     _offsetValue = _animationController.value;
//   }
//
//   void _handleDragUpdate(DragUpdateDetails details) {
//     if (!_captured) return;
//
//     final screenSize = MediaQuery.of(context).size;
//     final diff = (details.globalPosition - _startPosition!).dx;
//
//     _animationController.value =
//         _offsetValue +
//         (diff / (screenSize.width * widget.openRatio)) *
//             (widget.rtlOpening ? -1 : 1);
//   }
//
//   void _handleDragEnd(DragEndDetails details) {
//     if (!_captured) return;
//
//     _captured = false;
//
//     if (_animationController.value >= 0.5) {
//       _animationController.forward();
//     } else {
//       _animationController.reverse();
//     }
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
// }

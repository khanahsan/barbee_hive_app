import 'dart:math' as Math;
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import '../constants/app_colors.dart';

/*class HexagonClipper extends CustomClipper<Path> {
  final double scale;

  HexagonClipper({this.scale = 1.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    final double centerX = w / 2;
    final double centerY = h / 2;

    final double radius = w / 2 * scale;

    for (int i = 0; i < 6; i++) {
      final angle = (60 * i - 30) * 3.1415926535897932 / 180;
      final x = centerX + radius * Math.cos(angle);
      final y = centerY + radius * Math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class HexagonAvatar extends StatelessWidget {
  const HexagonAvatar({
    super.key,
    this.height,
    this.width,
    this.borderColor,
    required this.imagePath,
    this.name,
    this.totalMl,
    this.textStyle,
  });

  final double? height;
  final double? width;
  final Color? borderColor;
  final String imagePath;
  final String? name;
  final String? totalMl;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final double resolvedWidth = width ?? 80.w;
    final double resolvedHeight = height ?? resolvedWidth * 0.866;

    return ClipPath(
      clipper: HexagonClipper(),
      child: Container(
        padding: const EdgeInsets.all(2),
        width: resolvedWidth,
        height: resolvedHeight,
        color: borderColor ?? AppColors.primary,
        child: ClipPath(
          clipper: HexagonClipper(),
          child: Container(
            padding: const EdgeInsets.all(3.5),
            width: resolvedWidth,
            height: resolvedHeight,
            color: AppColors.black,
            child: ClipPath(
              clipper: HexagonClipper(),
              child: SizedBox(
                width: resolvedWidth,
                height: resolvedHeight,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    Image.asset(imagePath, fit: BoxFit.cover),
                    if (name != null)
                      Positioned(
                        bottom: 15.h,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              name!,
                              textAlign: TextAlign.center,
                              style:
                                  textStyle ??
                                  Theme.of(
                                    context,
                                  ).textTheme.titleSmall?.copyWith(
                                    fontSize: 10.sp,
                                    color: AppColors.white,
                                  ),
                            ),
                            Text(
                              totalMl!,
                              textAlign: TextAlign.center,
                              style:
                                  textStyle ??
                                  Theme.of(
                                    context,
                                  ).textTheme.titleSmall?.copyWith(
                                    fontSize: 9.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/

// class HexagonAvatar extends StatelessWidget {
//   const HexagonAvatar({
//     super.key,
//     this.height,
//     this.width,
//     this.borderColor,
//     required this.imagePath,
//   });
//
//   final double? height;
//   final double? width;
//   final Color? borderColor;
//   final String imagePath;
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipPath(
//       clipper: HexagonClipper(),
//       child: Container(
//         padding: EdgeInsets.all(2),
//         width: width ?? 80.w,
//         height: height ?? 90.h,
//         color: borderColor ?? AppColors.primary,
//         child: ClipPath(
//           clipper: HexagonClipper(),
//           child: Container(
//             padding: EdgeInsets.all(3.5),
//             width: width ?? 80.w,
//             height: height ?? 90.h,
//             color: AppColors.black,
//             child: ClipPath(
//               clipper: HexagonClipper(),
//               child: SizedBox(
//                 width: width ?? 80.w,
//                 height: height ?? 90.h,
//                 child: Image.asset(
//                   AppAssets.profileImage,
//                   fit: BoxFit.fitWidth,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//     // return Stack(
//     //   alignment: Alignment.center,
//     //   children: [
//     //     // Outer Hexagon (Border layer)
//     //     ClipPath(
//     //       clipper: HexagonClipper(scale: 0.9),
//     //       child: Container(
//     //         width: width ?? 80.w,
//     //         height: height ?? 90.h,
//     //         color: AppColors.primary,
//     //       ),
//     //     ),
//     //
//     //     ClipPath(
//     //       clipper: HexagonClipper(scale: 0.80),
//     //       child: Container(
//     //         width: width ?? 80.w,
//     //         height: height ?? 90.h,
//     //         color: AppColors.black,
//     //       ),
//     //     ),
//     //     ClipPath(
//     //       clipper: HexagonClipper(scale: 0.70),
//     //       child: SizedBox(
//     //         width: width ?? 80.w,
//     //         height: height ?? 90.h,
//     //         child: Image.asset(AppAssets.profileImage, fit: BoxFit.scaleDown),
//     //       ),
//     //     ),
//     //   ],
//     // );
//   }
// }

import 'dart:math' as Math;

class HexagonClipper extends CustomClipper<Path> {
  final double scale;

  HexagonClipper({this.scale = 1.0});

  // @override
  // Path getClip(Size size) {
  //   final path = Path();
  //   final w = size.width;
  //   final h = size.height;
  //
  //   final double centerX = w / 2;
  //   final double centerY = h / 2;
  //
  //   // final double radius = w / 2 * scale;
  //
  //   final double radius = (w / 2) / Math.cos(Math.pi / 7) * scale;
  //
  //
  //   for (int i = 0; i < 6; i++) {
  //     final angle = (60 * i - 30) * 3.1415926535897932 / 180;
  //     final x = centerX + radius * Math.cos(angle);
  //     final y = centerY + radius * Math.sin(angle);
  //     if (i == 0) {
  //       path.moveTo(x, y);
  //     } else {
  //       path.lineTo(x, y);
  //     }
  //   }
  //
  //   path.close();
  //   return path;
  // }

  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    final double centerX = w / 2;
    final double centerY = h / 2;

    // Calculate radius that fits within the height and width
    // Max radius that fits in both width and height
    final double radius =
        Math.min(w / 2, h / (Math.sin(Math.pi / 3) * 1.5)) * scale;

    for (int i = 0; i < 6; i++) {
      final angle = (60 * i - 30) * Math.pi / 180;
      final x = centerX + radius * Math.cos(angle);
      final y = centerY + radius * Math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}


class HexagonAvatar extends StatelessWidget {
  const HexagonAvatar({
    super.key,
    this.height,
    this.width,
    this.borderColor,
    required this.imagePath,
    // required this.optionIconPath,
    this.name,
    this.totalMl,
    this.textStyle,
    this.showOption = false,
  });

  final double? height;
  final double? width;
  final Color? borderColor;
  final String imagePath;
  final bool? showOption;

  // final String optionIconPath;
  final String? name;
  final String? totalMl;
  final TextStyle? textStyle;

  bool _isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final double resolvedWidth = width ?? 80.w;
    final double resolvedHeight = height ?? resolvedWidth * 0.866;

    return Stack(
      children: [
        ClipPath(
          clipper: HexagonClipper(),
          child: Container(
            padding: const EdgeInsets.all(1),
            width: resolvedWidth,
            height: resolvedHeight,
            color: borderColor ?? AppColors.primary,
            child: ClipPath(
              clipper: HexagonClipper(),
              child: Container(
                padding: const EdgeInsets.all(3.5),
                width: resolvedWidth,
                height: resolvedHeight,
                color: AppColors.black,
                child: ClipPath(
                  clipper: HexagonClipper(),
                  child: SizedBox(
                    width: resolvedWidth,
                    height: resolvedHeight,
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        _isNetworkImage(imagePath)
                            ? Image.network(imagePath, fit: BoxFit.cover)
                            : Image.asset(imagePath, fit: BoxFit.cover),
                        if (name != null && totalMl != null)
                          Positioned(
                            bottom: 15.h,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  name!,
                                  textAlign: TextAlign.center,
                                  style:
                                      textStyle ??
                                      Theme.of(
                                        context,
                                      ).textTheme.titleSmall?.copyWith(
                                        fontSize: 10.sp,
                                        color: AppColors.white,
                                      ),
                                ),
                                Text(
                                  totalMl!,
                                  textAlign: TextAlign.center,
                                  style:
                                      textStyle ??
                                      Theme.of(
                                        context,
                                      ).textTheme.titleSmall?.copyWith(
                                        fontSize: 9.sp,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        if(showOption ?? false)
        Positioned(
          bottom: 4.h,
          left: 22.w,
          child: ClipPath(
            clipper: HexagonClipper(),
            child: Container(
              padding: EdgeInsets.all(1),
              width: 35.w,
              height: 45.h,
              color: borderColor ?? AppColors.primary,
              child: ClipPath(
                clipper: HexagonClipper(),
                child: Container(
                  alignment: Alignment.center,
                  // padding: const EdgeInsets.all(5),
                  width: 40.w,
                  height: 45.h,
                  color: AppColors.black,
                  child: ClipPath(
                    clipper: HexagonClipper(),
                    child: SvgPicture.asset(
                      AppAssets.editIcon,
                      fit: BoxFit.scaleDown,
                      height: 25.h,
                      width: 25.w,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HoneycombLayoutDelegate extends MultiChildLayoutDelegate {
  final double itemWidth;
  final double itemHeight;
  final List<dynamic> users;
  final List<int> pattern;

  HoneycombLayoutDelegate({
    required this.itemWidth,
    required this.itemHeight,
    required this.users,
    required this.pattern,
  });

  @override
  Size getSize(BoxConstraints constraints) {
    final int totalItemsInPattern = pattern.reduce((a, b) => a + b);
    final int rowCount = (users.length / totalItemsInPattern).ceil() + (users.length % totalItemsInPattern > 0 ? 1 : 0);
    final double totalHeight = rowCount * itemHeight * 0.75; // Height based on number of rows
    return Size(constraints.maxWidth, totalHeight);
  }

  @override
  void performLayout(Size size) {
    int index = 0;
    double y = 0;
    int patternIndex = 0;

    while (index < users.length) {
      final int itemsInRow = pattern[patternIndex % pattern.length];
      double x = (patternIndex % 2 == 0) ? 0 : itemWidth / 2;

      for (int col = 0; col < itemsInRow && index < users.length; col++) {
        if (hasChild(index)) {
          layoutChild(
            index,
            BoxConstraints.tightFor(width: itemWidth, height: itemHeight),
          );
          positionChild(index, Offset(x, y));
        }
        x += itemWidth;
        index++;
      }

      y += itemHeight * 0.75;
      patternIndex++;
    }
  }

  @override
  bool shouldRelayout(covariant HoneycombLayoutDelegate oldDelegate) {
    return itemWidth != oldDelegate.itemWidth ||
        itemHeight != oldDelegate.itemHeight ||
        users != oldDelegate.users ||
        pattern != oldDelegate.pattern;
  }
}

// class HexagonAvatar extends StatelessWidget {
//   const HexagonAvatar({
//     super.key,
//     this.height,
//     this.width,
//     this.borderColor,
//     required this.imagePath,
//     this.name,
//     this.totalMl,
//     this.textStyle,
//   });
//
//   final double? height;
//   final double? width;
//   final Color? borderColor;
//   final String imagePath;
//   final String? name;
//   final String? totalMl;
//   final TextStyle? textStyle;
//
//   @override
//   Widget build(BuildContext context) {
//     final double resolvedWidth = width ?? 80.w;
//     final double resolvedHeight = height ?? resolvedWidth * 0.866;
//
//     return ClipPath(
//       clipper: HexagonClipper(),
//       child: Container(
//         padding: const EdgeInsets.all(1),
//         width: resolvedWidth,
//         height: resolvedHeight,
//         color: borderColor ?? AppColors.primary,
//         child: ClipPath(
//           clipper: HexagonClipper(),
//           child: Container(
//             padding: const EdgeInsets.all(3.5),
//             width: resolvedWidth,
//             height: resolvedHeight,
//             color: AppColors.black,
//             child: ClipPath(
//               clipper: HexagonClipper(),
//               child: SizedBox(
//                 width: resolvedWidth,
//                 height: resolvedHeight,
//                 child: Stack(
//                   fit: StackFit.expand,
//                   alignment: Alignment.center,
//                   children: [
//                     Image.asset(imagePath, fit: BoxFit.cover),
//                     if (name != null && totalMl != null)
//                       Positioned(
//                         bottom: 15.h,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               name!,
//                               textAlign: TextAlign.center,
//                               style: textStyle ??
//                                   Theme.of(context).textTheme.titleSmall?.copyWith(
//                                     fontSize: 10.sp,
//                                     color: AppColors.white,
//                                   ),
//                             ),
//                             Text(
//                               totalMl!,
//                               textAlign: TextAlign.center,
//                               style: textStyle ??
//                                   Theme.of(context).textTheme.titleSmall?.copyWith(
//                                     fontSize: 9.sp,
//                                     color: AppColors.primary,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                             ),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

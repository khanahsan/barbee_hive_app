import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import '../constants/app_colors.dart';

class HexagonClipper extends CustomClipper<Path> {
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
}

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

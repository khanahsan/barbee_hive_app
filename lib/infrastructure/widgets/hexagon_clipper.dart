import 'dart:math' as Math;

import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

    // final double radius = w / 2 * scale;

    final double radius = (w / 2) / Math.cos(Math.pi / 7) * scale;

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

  // @override
  // Path getClip(Size size) {
  //   final path = Path();
  //   final w = size.width;
  //   final h = size.height;
  //
  //   final double centerX = w / 2;
  //   final double centerY = h / 2;

  // Calculate radius that fits within the height and width
  // Max radius that fits in both width and height
  //   final double radius =
  //       Math.min(w / 2, h / (Math.sin(Math.pi / 3) * 1.5)) * scale;
  //
  //   for (int i = 0; i < 6; i++) {
  //     final angle = (60 * i - 30) * Math.pi / 180;
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
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

/*class HexagonAvatar extends StatelessWidget {
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
}*/

class HexagonAvatar extends StatelessWidget {
  const HexagonAvatar({
    super.key,
    this.height,
    this.width,
    this.borderColor,
    required this.imagePath,
    this.showOption = false,
    this.name,
    this.totalMl,
    this.textStyle,
    this.isBoosted = false,
  });

  final double? height;
  final double? width;
  final Color? borderColor;
  final String imagePath;
  final bool? showOption;
  final String? name;
  final String? totalMl;
  final TextStyle? textStyle;
  final bool isBoosted;

  bool _isNetworkImage(String path) {
    return path.isNotEmpty &&
        (path.startsWith('http://') || path.startsWith('https://'));
  }

  bool _isValidAssetImage(String path) {
    return path.isNotEmpty && path.endsWith('.png') ||
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg');
  }

  @override
  Widget build(BuildContext context) {
    final double resolvedWidth = width ?? 80;
    final double resolvedHeight = height ?? resolvedWidth * 0.866;

    // Determine if we should show the initial
    final bool showInitial =
        imagePath.isEmpty ||
        (!_isNetworkImage(imagePath) && !_isValidAssetImage(imagePath));

    final Gradient? borderGradient =
        isBoosted
            ? const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF8A3FFC), Color(0xFFFF4D4D)],
            )
            : null;

    return Stack(
      children: [
        ClipPath(
          clipper: HexagonClipper(),
          child: Container(
            padding: const EdgeInsets.all(1),
            width: resolvedWidth,
            height: resolvedHeight,
            decoration: BoxDecoration(
              color:
                  borderGradient == null
                      ? borderColor ?? AppColors.colorFF8600
                      : null,
              gradient: borderGradient,
            ),
            child: ClipPath(
              clipper: HexagonClipper(),
              child: Container(
                padding: EdgeInsets.all(isBoosted ? 4.5 : 3.5),
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
                        if (!showInitial)
                          _isNetworkImage(imagePath)
                              ? Image.network(
                                imagePath,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        _buildInitial(context),
                              )
                              : Image.asset(
                                imagePath,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        _buildInitial(context),
                              )
                        else
                          _buildInitial(context),
                        /*if (isBoosted)
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    AppColors.color000000.withValues(
                                      alpha: 0.62,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),*/
                      /*  if (isBoosted && name != null && name!.isNotEmpty)
                          Positioned(
                            left: 6.w,
                            right: 6.w,
                            bottom: 12.h,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  name!.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.colorFFFFFF,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    height: 1,
                                  ),
                                ),
                                if (totalMl != null && totalMl!.isNotEmpty)
                                  Text(
                                    totalMl!,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.colorFF8600,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      height: 1.05,
                                    ),
                                  ),
                              ],
                            ),
                          ),*/
                        /*if (name != null && totalMl != null)
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
                          ),*/
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showOption ?? false)
          Positioned(
            bottom: 4.h,
            left: 22.w,
            child: ClipPath(
              clipper: HexagonClipper(),
              child: Container(
                padding: const EdgeInsets.all(1),
                width: 35.w,
                height: 45.h,
                color: borderColor ?? AppColors.colorFF8600,
                child: ClipPath(
                  clipper: HexagonClipper(),
                  child: Container(
                    alignment: Alignment.center,
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

  Widget _buildInitial(BuildContext context) {
    return Container(
      color: AppColors.colorFF8600,
      alignment: Alignment.center,
      child:
          name != null && name!.isNotEmpty
              ? Text(
                name![0].toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorFFFFFF,
                ),
              )
              : Icon(Icons.person, color: AppColors.colorFFFFFF, size: 24.sp),
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
    final int rowCount =
        (users.length / totalItemsInPattern).ceil() +
        (users.length % totalItemsInPattern > 0 ? 1 : 0);
    final double totalHeight = rowCount * itemHeight * 0.75;

    // Find max number of items in any row
    final int maxItemsInRow = pattern.reduce((a, b) => a > b ? a : b);

    // Effective width of the widest row
    final double totalWidth =
        (maxItemsInRow * itemWidth) - ((maxItemsInRow - 1) * 1.5);

    return Size(totalWidth, totalHeight);
  }

  // @override
  // Size getSize(BoxConstraints constraints) {
  //   final int totalItemsInPattern = pattern.reduce((a, b) => a + b);
  //   final int rowCount =
  //       (users.length / totalItemsInPattern).ceil() +
  //       (users.length % totalItemsInPattern > 0 ? 1 : 0);
  //   final double totalHeight =
  //       rowCount * itemHeight * 0.75; // Height based on number of rows
  //   return Size(constraints.maxWidth, totalHeight);
  // }

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
        x += itemWidth - 1.5;
        index++;
      }

      // print("hello item $itemHeight");

      y += itemHeight * 0.74;

      print("$itemHeight item $y == ${patternIndex}");

      patternIndex++;
    }
    print("----------------------------------");
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

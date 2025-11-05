import 'package:flutter/material.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_colors.dart';

class AppShimmer extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final int itemCount;
  final bool isList;

  const AppShimmer({
    super.key,
    this.height = 100,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.itemCount = 1,
    this.isList = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isList) {
      return SingleChildScrollView(
        child: Column(
          children: List.generate(itemCount, (int index) {
            return Padding(
              padding: EdgeInsets.only(bottom: index == itemCount - 1 ? 0 : 20.h),
              child: _buildShimmerItem(),
            );
          }),
        ),
      );
    } else {
      return _buildShimmerItem();
    }
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: AppColors.color2E2E2E, // darker grey for depth
      highlightColor: AppColors.color545458.withOpacity(0.6),
      child: Container(
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(
          color: AppColors.color27272A, // subtle mid-grey background
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}


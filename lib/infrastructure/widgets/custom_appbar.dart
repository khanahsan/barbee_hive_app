import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import 'hexagon_clipper.dart';

PreferredSizeWidget customAppbar({
  required BuildContext context,
  required VoidCallback leadingTapFunction,
  // required int currentBottomIndex,
  required String title,
  String? leadingIconPath,
  bool? showActions,
  List<Widget>? actions,
  bool? showHexagon = true,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(90.h),
    child: AppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      backgroundColor: AppColors.color101010,
      toolbarHeight: 100.h,
      elevation: 0,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.w,
        children: [
          GestureDetector(
            onTap: leadingTapFunction,
            child: _buildSvgPicture(
              iconPath: leadingIconPath ?? AppAssets.menuIcon,
              iconHeight: 18.h,
              iconWidth: 18.w,
            ),
          ),
          if(showHexagon == true)
          HexagonAvatar(
            imagePath: AppAssets.profileImage,
            width: 50.w,
            height: 60.h,
          ),
        ],
      ).paddingSymmetric(horizontal: 15.w),
      leadingWidth: 120.w,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.white,
          fontSize: 25.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actionsPadding: EdgeInsets.symmetric(horizontal: 15.w),
      actions: actions,
      // actions:
      //     showActions == true
      //         ? [
      //           _buildSvgPicture(
      //             iconPath: AppAssets.bellIcon,
      //             iconHeight: 24.h,
      //             iconWidth: 24.w,
      //           ),
      //           SizedBox(width: 10.w),
      //           _buildSvgPicture(
      //             iconPath: AppAssets.filterIcon,
      //             iconHeight: 24.h,
      //             iconWidth: 24.w,
      //           ),
      //         ]
      //         : null,
    ),
  );
}

Widget _buildSvgPicture({
  required String iconPath,
  required double iconHeight,
  required double iconWidth,
}) {
  return SvgPicture.asset(
    iconPath,
    fit: BoxFit.cover,
    height: iconHeight,
    width: iconWidth,
  );
}

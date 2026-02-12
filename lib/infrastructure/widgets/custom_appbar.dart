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
  required String title,
  String? profileImagePath,
  String? profileName,
  String? leadingIconPath,
  bool? showActions,
  List<Widget>? actions,
  bool? showHexagon = true,
  VoidCallback? hexagonTapFunction,
  Widget? titleWidget,  // Accept custom widget for the title
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
          if (showHexagon == true)
            GestureDetector(
              onTap: hexagonTapFunction?.call,
              child: HexagonAvatar(
                imagePath: profileImagePath ?? '',
                name: profileName,
                width: 40.w,
                height: 50.h,
              ),
            ),
        ],
      ).paddingSymmetric(horizontal: 15.w),
      leadingWidth: 120.w,
      title: titleWidget ?? Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.colorFFFFFF,
          fontSize: 25.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actionsPadding: EdgeInsets.symmetric(horizontal: 15.w),
      actions: actions,
    ),
  );
}

/*PreferredSizeWidget customAppbar({
  required BuildContext context,
  required VoidCallback leadingTapFunction,
  // required int currentBottomIndex,
  required String title,
  String? profileImagePath,
  String? leadingIconPath,
  bool? showActions,
  List<Widget>? actions,
  bool? showHexagon = true,
  VoidCallback? hexagonTapFunction,
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
          if (showHexagon == true)
            GestureDetector(
              onTap: hexagonTapFunction?.call,
              child: HexagonAvatar(
                imagePath: profileImagePath ?? '',
                name: profileName,
                width: 40.w,
                height: 50.h,
              ),
            ),
        ],
      ).paddingSymmetric(horizontal: 15.w),
      leadingWidth: 120.w,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.colorFFFFFF,
          fontSize: 25.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actionsPadding: EdgeInsets.symmetric(horizontal: 15.w),
      actions: actions,
    ),
  );
}*/

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

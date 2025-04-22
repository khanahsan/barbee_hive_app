import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.color101010,
        toolbarHeight: 80.h,
        centerTitle: true,
        actionsPadding: EdgeInsets.symmetric(horizontal: 15.w),
        actions: [
          SvgPicture.asset(
            AppAssets.bellIcon,
            fit: BoxFit.scaleDown,
            height: 26.h,
            width: 26.w,
          ),
          SizedBox(width: 10.w),
          SvgPicture.asset(
            AppAssets.filterIcon,
            fit: BoxFit.scaleDown,
            height: 26.h,
            width: 26.w,
          ),
        ],
        title: Text(
          'Dashboard',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.white,
            fontSize: 30.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: SvgPicture.asset(
          AppAssets.menuIcon,
          fit: BoxFit.scaleDown,
          height: 8.h,
          width: 8.w,
        ),
      ),
    );
  }
}

import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/fading_image_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import '../../../infrastructure/widgets/hexagon_clipper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      AppAssets.sampleImage,
      AppAssets.sampleImage2,
      AppAssets.sampleImage,
      AppAssets.sampleImage2,
    ];

    return Scaffold(
      // appBar: appBarSection(context),
      backgroundColor: AppColors.black,

      body: SingleChildScrollView(
        child: Column(
          spacing: 30.h,
          children: [
            FadingImageCarousel(imagePaths: imagePaths),
            B2BSection(context),
            hiveSection(context),
          ],
        ).paddingSymmetric(horizontal: 15.w, vertical: 20.h),
      ),
    );
  }

  Widget hiveSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.boxBorder, width: 3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5.h,
        children: [
          Text(
            'HIVE',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.white,
              fontSize: 30.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.white,
                name: "Brew House",
                totalMl: ".6Ml",
              ),
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.primary,
                name: "Keithston’s",
                totalMl: ".4Ml",
              ),
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.white,
                name: "Alex",
                totalMl: ".8Ml",
              ),
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.primary,
                name: "Zach",
                totalMl: ".8Ml",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8.w,
            children: [
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.white,
                name: "Brew House",
                totalMl: ".6Ml",
              ),
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.primary,
                name: "Keithston’s",
                totalMl: ".4Ml",
              ),
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.white,
                name: "Alex",
                totalMl: ".8Ml",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.white,
                name: "Brew House",
                totalMl: ".6Ml",
              ),
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.primary,
                name: "Keithston’s",
                totalMl: ".4Ml",
              ),
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.white,
                name: "Alex",
                totalMl: ".8Ml",
              ),
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.primary,
                name: "Zach",
                totalMl: ".8Ml",
              ),
            ],
          ),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.white,
                name: "Brew House",
                totalMl: ".6Ml",
              ),
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.primary,
                name: "Keithston’s",
                totalMl: ".4Ml",
              ),
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.white,
                name: "Alex",
                totalMl: ".8Ml",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget B2BSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.boxBorder, width: 3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5.h,
        children: [
          Text(
            'B2B',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.white,
              fontSize: 30.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.white,
                name: "Brew House",
                totalMl: ".6Ml",
              ),
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.primary,
                name: "Keithston’s",
                totalMl: ".4Ml",
              ),
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.white,
                name: "Alex",
                totalMl: ".8Ml",
              ),
              HexagonAvatar(
                imagePath: AppAssets.profileImage,
                width: 85.w,
                height: 95.h,
                borderColor: AppColors.primary,
                name: "Zach",
                totalMl: ".8Ml",
              ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSize appBarSection(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100.h),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.r),
          bottomRight: Radius.circular(25.r),
        ),
        child: AppBar(
          backgroundColor: AppColors.color101010,
          toolbarHeight: 100.h,
          elevation: 0,

          title: Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSvgPicture(
                    iconPath: AppAssets.menuIcon,
                    iconHeight: 20.h,
                    iconWidth: 20.w,
                  ),
                  SizedBox(width: 10.w),
                  HexagonAvatar(
                    imagePath: AppAssets.profileImage,
                    width: 60.w,
                    height: 70.h,
                  ),
                ],
              ),
              SizedBox(width: 50.w),
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.white,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSvgPicture(
                    iconPath: AppAssets.bellIcon,
                    iconHeight: 26.h,
                    iconWidth: 26.w,
                  ),
                  SizedBox(width: 10.w),
                  _buildSvgPicture(
                    iconPath: AppAssets.filterIcon,
                    iconHeight: 26.h,
                    iconWidth: 26.w,
                  ),
                ],
              ),
            ],
          ),
        ),
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
}

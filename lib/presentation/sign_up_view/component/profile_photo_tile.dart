import 'package:barbee_hive_app/presentation/sign_up_view/component/hexagon_widget.dart';
import 'package:flutter/material.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';

class ProfilePhotoTile extends StatelessWidget {
  const ProfilePhotoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: EdgeInsets.all(10.w),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipPath(
            clipper: HexagonClipper(),
            child: Container(
              padding: EdgeInsets.all(10),
              width: 124.w,
              height: 124.h,
              color: AppColors.primary,
            ),
          ),
          ClipPath(
            clipper: HexagonClipper(),
            child: Container(
              width: 120.w,
              height: 120.h,
              color: AppColors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.cameraLogo,
                    color: AppColors.grey,
                    height: 25.0.h,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Upload Photo',
                    style: TextStyle(color: AppColors.grey, fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

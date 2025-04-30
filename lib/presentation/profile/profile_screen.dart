import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:barbee_hive_app/presentation/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/constants/app_images.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int currentBottomIndex = 0;
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

    PreferredSize appBarSection({
      required BuildContext context,
    }) {
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
               /* GestureDetector(
                  onTap: onMenuPressed,
                  child: _buildSvgPicture(
                    iconPath: AppAssets.menuIcon,
                    iconHeight: 18.h,
                    iconWidth: 18.w,
                  ),
                ),
                SizedBox(width: 10.w),*/
                HexagonAvatar(
                  imagePath: AppAssets.profileImage,
                  width: 55.w,
                  height: 65.h,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Profile',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.white,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                _buildSvgPicture(
                  iconPath: AppAssets.settingIcon,
                  iconHeight: 24.h,
                  iconWidth: 24.w,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: appBarSection(
        context: context,

      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [

        ],
      ),
    );
  }
}

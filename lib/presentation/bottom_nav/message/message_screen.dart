import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        separatorBuilder: (context, index) => SizedBox(height: 15.h),
        itemCount: 3,
        itemBuilder: (context, index) {
          return messageTile(context);
        },
      ),
    );
  }

  Widget messageTile(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.color101010,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        spacing: 15.w,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HexagonAvatar(
            imagePath: AppAssets.profileImage,
            width: 80.w,
            height: 90.h,
            borderColor: AppColors.white,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // if you want left aligned text
              mainAxisSize: MainAxisSize.min,
              // Important to prevent extra vertical stretching
              children: [
                Text(
                  "Kyle Crane",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  "Hey, I saw your profile and found you suitable for this position",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey.withOpacity(0.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            AppAssets.arrowForwardIcon,
            height: 18.h,
            width: 18.w,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

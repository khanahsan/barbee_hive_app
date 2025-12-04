import 'dart:developer';

import 'package:barbee_hive_app/infrastructure/widgets/custom_app_shimmer.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/widgets/custom_appbar.dart';
import '../../../infrastructure/widgets/custom_btn.dart';
import '../../../infrastructure/widgets/hexagon_clipper.dart';
import 'controller/dashboardController.dart';

class DashboardScreen extends GetView<DashboardController> {
  DashboardScreen({super.key, this.onMenuPressed});

  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        showHexagon: true,
        hexagonTapFunction: (){
          Get.toNamed(Routes.PROFILE_SCREEN);
        },
        profileImagePath: controller.userProfileImage.value,
        context: context,
        leadingTapFunction: () {
          if (onMenuPressed != null) onMenuPressed!();
        },
        // actions: [
        //   SvgPicture.asset(AppAssets.bellIcon, height: 24.h, width: 24.w),
        // ],
        title: 'Home',
      ),
      backgroundColor: AppColors.black,
      body: Obx(() {
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              spacing: 10.h,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  title: controller.errorMessage.value,
                  fontSize: 16,
                  color: AppColors.expiredBannerColor,
                ),
                CustomBtn(
                  btnTitle: 'Retry',
                  onPressed: () => controller.fetchDashboardUsers(),
                  buttonHeight: 50,
                  btnBackgroundColor: AppColors.colorFF8600,
                  btnTxtColor: AppColors.colorFFFFFF,
                ),
              ],
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () => controller.fetchDashboardUsers(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // <- Important

              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 25.h,
                children: [
                  /// B2B SECTION
                  b2bSection(context),

                  /// BANNER AD SECTION
                  Obx(() {
                    if (!controller.isBannerLoaded.value || controller.bannerAd == null) {
                      return AppShimmer(height: 80.h, width: double.infinity);
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: controller.bannerAd!.size.width.toDouble(),
                        height: controller.bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: controller.bannerAd!),
                      ),
                    );
                  }),



                  /// HIVE SECTION
                  hiveSection(context),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  RxDouble hOfW = 0.0.obs;

  Widget hiveSection(BuildContext context) {
    return Obx(() {
      final users = controller.employees;
      final double itemWidth = 95.w;
      final double itemHeight = 105.h;
      final List<int> pattern = _getPattern(users.length, itemHeight);
      final maxHeight = MediaQuery.of(context).size.height * 0.6;

      if (controller.isLoading.value) {
        return AppShimmer(height: 450.h, width: double.infinity);
      }
      if (users.isEmpty) {
        return Container(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.boxBorder, width: 3.w),
          ),
          child: Center(
            child: Text(
              'No Hive users found',
              style: TextStyle(color: AppColors.colorFFFFFF, fontSize: 16.sp),
            ),
          ),
        );
      }

      return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'HIVE',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.colorFFFFFF,
                fontSize: 25.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 15.h),

            Container(
              height: hOfW.value,
              child: CustomMultiChildLayout(
                delegate: HoneycombLayoutDelegate(
                  itemWidth: itemWidth,
                  itemHeight: itemHeight,
                  users: users,
                  pattern: pattern,
                ),
                children: [
                  for (int index = 0; index < users.length; index++)
                    LayoutId(
                      id: index,
                      child: GestureDetector(
                        onTap:
                            () => Get.toNamed(
                              Routes.hiveProfileScreen,
                              arguments: {'currentUser': users[index]},
                            ),
                        child: SingleChildScrollView(
                          child: HexagonAvatar(
                            imagePath:
                                users[index].profileImage!.isNotEmpty == true
                                    ? users[index].profileImage!
                                    : '',
                            // Set to null to trigger name-based avatar
                            width: itemWidth,
                            height: itemHeight,
                            borderColor:
                                index % 2 == 0
                                    ? AppColors.colorFFFFFF
                                    : AppColors.colorFF8600,
                            name:
                                (users[index].employee?.name ??
                                            users[index].email.split('@').first)
                                        .isNotEmpty
                                    ? (users[index].employee?.name ??
                                        users[index].email.split('@').first)
                                    : 'Unknown Employee',
                            totalMl:
                                users[index].employee?.experienceYears ?? 'N/A',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  List<int> _getPattern(int userCount, itemHeight) {
    hOfW.value = 0.0;
    print("cehck :");
    if (userCount <= 0) return []; // Return empty list for invalid input
    if (userCount <= 4) {
      hOfW.value = 90;
      return [userCount]; // Single row for 4 or fewer users
    }

    final List<int> basePattern = [4, 3]; // Base repeating pattern
    final int patternSum = basePattern.reduce(
      (a, b) => a + b,
    ); // Sum of base pattern (7)
    final int fullCycles =
        userCount ~/ patternSum; // Number of complete 4-3 cycles
    int remaining = userCount % patternSum; // Remaining items after full cycles

    List<int> pattern = [];
    // Add full cycles of [4, 3]
    for (int i = 0; i < fullCycles; i++) {
      pattern.addAll(basePattern);
    }

    // Handle remaining items
    if (remaining > 0) {
      int index = 0;
      while (remaining > 0) {
        print("remain $remaining");
        final int itemsToAdd =
            remaining >= basePattern[index % basePattern.length]
                ? basePattern[index % basePattern.length]
                : remaining;
        print("items to add : $itemsToAdd");
        pattern.add(itemsToAdd);
        remaining -= itemsToAdd;
        index++;
      }
    }

    hOfW.value = (pattern.length * 90).toDouble();

    print("HOW PSHLR : ${hOfW.value}");
    //var val = (82 * 0.75);
    // var val = (pattern.length - 1) * 20;
    var val = 31.5;
    // var result = (pattern.length - 1) * val;
    //print("pattern.length * 0.75 :==  ${result / 2}");
    var t = (pattern.length - 1) * val;
    // print("ttt : $t");
    // var res = t * val;
    hOfW.value -= t;

    print("HOW AFTER : ${hOfW.value}");

    //y = 1783

    print("------------------ ${pattern.length} == hOfW.value = ${hOfW.value}");

    return pattern;
  }

  // Widget b2bSection(BuildContext context) {
  //
  //   log('controller.employers ${controller.employers.isEmpty}');
  //   if (controller.isLoading.value) {
  //     return AppShimmer(height: 250.h, width: double.infinity);
  //   }
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
  //     alignment: Alignment.center,
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(15.r),
  //       border: Border.all(color: AppColors.boxBorder, width: 2.5.w),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       spacing: 5.h,
  //       children: [
  //         Text(
  //           'B2B',
  //           style: Theme.of(context).textTheme.titleSmall?.copyWith(
  //             color: AppColors.colorFFFFFF,
  //             fontSize: 25.sp,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         Obx(
  //           () =>
  //               controller.employers.isEmpty
  //                   ? Text(
  //                     'No B2B users found',
  //                     style: TextStyle(
  //                       color: AppColors.colorFFFFFF,
  //                       fontSize: 16.sp,
  //                     ),
  //                   )
  //                   : SingleChildScrollView(
  //                     scrollDirection: Axis.horizontal,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children:
  //                           controller.employers.asMap().entries.map((entry) {
  //                             final index = entry.key;
  //                             final user = entry.value;
  //                             final name =
  //                                 user.employer?.businessName ??
  //                                 user.email.split('@').first;
  //
  //                             return GestureDetector(
  //                               onTap:
  //                                   () => Get.toNamed(
  //                                     Routes.b2bScreen,
  //                                     arguments: {'currentUser': user},
  //                                   ),
  //
  //                               child: HexagonAvatar(
  //                                 imagePath:
  //                                     user.profileImage!.isNotEmpty == true
  //                                         ? user.profileImage!
  //                                         : '',
  //                                 width: 90.w,
  //                                 height: 100.h,
  //                                 borderColor:
  //                                     index % 2 == 0
  //                                         ? AppColors.colorFFFFFF
  //                                         : AppColors.colorFF8600,
  //                                 name: name,
  //                                 totalMl: "aa",
  //                               ),
  //                             );
  //                           }).toList(),
  //                     ),
  //                   ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget b2bSection(BuildContext context) {
    return Obx(() {
      log('controller.employers empty? ${controller.employers.isEmpty}');
      log('isLoading: ${controller.isLoading.value}');

      if (controller.isLoading.value) {
        return AppShimmer(height: 250.h, width: double.infinity);
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: AppColors.boxBorder, width: 2.5.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5.h,
          children: [
            Text(
              'B2B',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.colorFFFFFF,
                fontSize: 25.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            controller.employers.isEmpty
                ? Text(
              'No B2B users found',
              style: TextStyle(
                color: AppColors.colorFFFFFF,
                fontSize: 16.sp,
              ),
            )
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                controller.employers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final user = entry.value;

                  return GestureDetector(
                    onTap: () => Get.toNamed(
                      Routes.b2bScreen,
                      arguments: {'currentUser': user},
                    ),
                    child: HexagonAvatar(
                      imagePath: user.profileImage ?? "",
                      width: 90.w,
                      height: 100.h,
                      borderColor: index % 2 == 0
                          ? AppColors.colorFFFFFF
                          : AppColors.colorFF8600,
                      name: user.employer?.businessName ??
                          user.email.split('@').first,
                      totalMl: "aa",
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

}

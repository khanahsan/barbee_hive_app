import 'package:barbee_hive_app/infrastructure/widgets/custom_select_role_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../../../infrastructure/constants/app_images.dart';
import '../../../infrastructure/navigation/routes.dart';

class SelectRoleView extends StatelessWidget {
  const SelectRoleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'account type',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              AppAssets.logo,
              width: 200.w,
              //height: 120.h,
            ),
            SizedBox(height: 10.h),

            Hero(
              tag: 'gold_line',
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.only(top: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0.r),
                      topRight: Radius.circular(20.0.r),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(18.0), topLeft: Radius.circular(18.0))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 20.h,
                      children: [
                        SizedBox(height: 15.h,),
                        const Text(
                          'Choose an account type',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomSelectRoleWidget(iconPath: AppAssets.employeeLogo,
                              onTap: (){
                              Get.toNamed(Routes.SIGN_UP_VIEW);
                              },
                            ),
                            CustomSelectRoleWidget(iconPath: AppAssets.employerLogo, onTap: (){}),
                          ],
                        )
                      ],
                    ),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

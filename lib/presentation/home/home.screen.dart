
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/constants/app_images.dart';
import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/widgets/custom_btn.dart';
import '../../infrastructure/widgets/custom_text_btn.dart';
import '../sign_up_view/sign_up_view.screen.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child:  Padding(
          padding:  EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15.0.h,
            children: [
              Image.asset(
                AppAssets.logo,
                fit: BoxFit.contain,
                height: 269.h,
                width: 178.w,
              ),
              CustomBtn(
                  btnTitle: 'Sign in',
                  onPressed: (){},
              ),
              CustomBtn(
                btnBackgroundColor: Colors.black,
                btnTitle: 'New To BarBee?',
                borderColor: Colors.white,
                borderWidth: 1.0.w,
                onPressed: (){
                  //Get.to(SignUpViewScreen());
                  //Get.to(() => SignUpViewScreen());
                  Get.toNamed(Routes.SIGN_UP_VIEW);
                },
              ),
              CustomBtn(
                btnBackgroundColor: Colors.black,
                btnTitle: 'Continue with Google',
                borderColor: Colors.grey.shade900,
                borderWidth: 1.0.w,
                onPressed: (){},
                iconPath: AppAssets.googleLogo,
              ),
              CustomBtn(
                btnBackgroundColor: Colors.black,
                btnTitle: 'Continue with Apple',
                borderColor: Colors.grey.shade900,
                borderWidth: 1.0.w,
                onPressed: (){},
                iconPath: AppAssets.appleLogo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:barbee_hive_app/presentation/sign_up_view/controllers/sign_up_employee_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';

class AgreeTermsTile extends GetView<SignUpEmployeeController> {
  const AgreeTermsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              controller.toggleCheckbox();
            },
            child: Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.grey,
                  width: 2.w,
                ),
                color:
                controller.isChecked.value
                    ? AppColors.colorFF8600
                    : Colors.transparent,
              ),
              child:
              controller.isChecked.value
                  ? Icon(
                Icons.check,
                size: 15.sp,
                color: Colors.white,
              )
                  : null,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            'I agree to the Terms of Service',
            style: TextStyle(
              color: AppColors.colorFF8600,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

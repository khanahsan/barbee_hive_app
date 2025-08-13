import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';

class CustomDropdownField extends StatelessWidget {
  final String hint;
  final String iconPath;
  final RxString selectedValue;
  final Function(String?) onChanged;
  final List<DropdownMenuItem<String>> items;

  const CustomDropdownField({
    super.key,
    required this.hint,
    required this.iconPath,
    required this.selectedValue,
    required this.onChanged,
    required this.items,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 18.w),
      decoration: BoxDecoration(
        color: AppColors.textFieldBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        spacing: 30.w,
        children: [
          Image.asset(
            iconPath,
            color: AppColors.textFieldTextColor,
            width: 16.w,
            height: 16.h,
          ),
          Expanded(
            child: Obx(
                  () => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: Colors.grey[900],
                  hint: Text(
                    selectedValue.value.isEmpty ? hint : selectedValue.value,
                    style: TextStyle(
                      color: AppColors.textFieldTextColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  iconEnabledColor: Colors.grey,
                  items: items,
                  onChanged: onChanged,
                  value:
                  selectedValue.value.isEmpty ? null : selectedValue.value,
                  menuMaxHeight: 300.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

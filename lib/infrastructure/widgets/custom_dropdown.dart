

import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';

/*class CustomDropdown extends StatelessWidget {
  final String hint;
  final String? iconPath; // Nullable now
  final RxString selectedValue;
  final Function(String?) onChanged;
  final List<DropdownMenuItem<String>> items;
  final double? fontSize;
  final double? iconSize;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? dropdownColor;
  final Color? borderColor;
  final String? Function(String?)? validator;

  const CustomDropdown({
    super.key,
    required this.hint,
    this.iconPath, // Nullable
    required this.selectedValue,
    required this.onChanged,
    required this.items,
    this.fontSize,
    this.iconSize,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.dropdownColor,
    this.borderColor,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    Widget? iconWidget;

    if (iconPath != null && iconPath!.isNotEmpty) {
      if (iconPath!.toLowerCase().endsWith('.svg')) {
        iconWidget = SvgPicture.asset(
          iconPath!,
          color: textColor ?? AppColors.textFieldTextColor,
          width: iconSize ?? 24.w,
          height: iconSize ?? 24.h,
        );
      } else {
        iconWidget = Image.asset(
          iconPath!,
          color: textColor ?? AppColors.textFieldTextColor,
          width: iconSize ?? 20.w,
          height: iconSize ?? 20.h,
        );
      }
    }

    return FormField<String>(
      initialValue: selectedValue.value.isEmpty ? null : selectedValue.value,
      validator: validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56.h,
              padding: EdgeInsets.symmetric(vertical: 0.2.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: backgroundColor ?? AppColors.textFieldBackground,
                borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
                border: Border.all(
                  color: state.hasError
                      ? Colors.red
                      : borderColor ?? Colors.black,
                  width: 1.2,
                ),
              ),
              child: Row(
                spacing: 20.w,
                children: [
                  if (iconWidget != null) iconWidget, // Only show if not null
                  Expanded(
                    child: Obx(
                          () => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          dropdownColor: dropdownColor ?? Colors.white,
                          style: TextStyle(
                            fontSize: fontSize ?? 16.sp,
                            overflow: TextOverflow.ellipsis,
                            color: textColor ?? Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          hint: Text(
                            selectedValue.value.isEmpty
                                ? hint
                                : selectedValue.value,
                            style: TextStyle(
                              color: textColor ?? AppColors.color4C4C4C,
                              fontSize: fontSize ?? 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          iconEnabledColor: Colors.grey,
                          items: items,
                          value: selectedValue.value.isEmpty
                              ? null
                              : selectedValue.value,
                          onChanged: (value) {
                            selectedValue.value = value ?? '';
                            onChanged(value);
                            state.didChange(value);
                          },
                          menuMaxHeight: 250.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (state.hasError)
              CustomText(
                title: state.errorText ?? '',
                color: AppColors.colorFF3B30,
                fontSize: 13,
              ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
          ],
        );
      },
    );
  }
}*/



class CustomDropdown extends StatelessWidget {
  final String hint;
  final String? iconPath; // Nullable now
  final RxString selectedValue;
  final Function(String?) onChanged;
  final List<DropdownMenuItem<String>> items;
  final double? fontSize;
  final double? iconSize;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? dropdownColor;
  final Color? borderColor;
  final String? Function(String?)? validator;

  const CustomDropdown({
    super.key,
    required this.hint,
    this.iconPath, // Nullable
    required this.selectedValue,
    required this.onChanged,
    required this.items,
    this.fontSize,
    this.iconSize,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.dropdownColor,
    this.borderColor,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    Widget? iconWidget;

    if (iconPath != null && iconPath!.isNotEmpty) {
      if (iconPath!.toLowerCase().endsWith('.svg')) {
        iconWidget = SvgPicture.asset(
          iconPath!,
          color: textColor ?? AppColors.textFieldTextColor,
          width: iconSize ?? 24.w,
          height: iconSize ?? 24.h,
        );
      } else {
        iconWidget = Image.asset(
          iconPath!,
          color: textColor ?? AppColors.textFieldTextColor,
          width: iconSize ?? 20.w,
          height: iconSize ?? 20.h,
        );
      }
    }

    return FormField<String>(
      initialValue: selectedValue.value.isEmpty ? null : selectedValue.value,
      validator: validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56.h,
              padding: EdgeInsets.symmetric(vertical: 0.2.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: backgroundColor ?? AppColors.textFieldBackground,
                borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
                border: Border.all(
                  color:
                  state.hasError ? Colors.red : borderColor ?? Colors.black,
                  width: 1.2,
                ),
              ),
              child: Row(
                spacing: 20.w,
                children: [
                  if (iconWidget != null) iconWidget, // Only show if not null
                  Expanded(
                    child: Obx(
                          () => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          dropdownColor: dropdownColor ?? AppColors.textFieldBackground,
                          // dropdown background = black
                          style: TextStyle(
                            fontSize: fontSize ?? 16.sp,
                            overflow: TextOverflow.ellipsis,
                            color: textColor ?? AppColors.colorA3A3A3,
                            // selected text = white
                            fontWeight: FontWeight.w400,
                          ),

                          hint: Text(
                            selectedValue.value.isEmpty
                                ? hint
                                : selectedValue.value,
                            style: TextStyle(
                              color: textColor ?? AppColors.colorA3A3A3,
                              // hint text color = white
                              fontSize: fontSize ?? 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          iconEnabledColor: Colors.white,
                          // dropdown arrow white
                          value:
                          selectedValue.value.isEmpty
                              ? null
                              : selectedValue.value,

                          items: items.map((item) {
                            return DropdownMenuItem<String>(
                              value: item.value,
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  color: AppColors.colorA3A3A3,
                                  fontSize: fontSize ?? 16.sp,
                                ),
                                child: item.child, // <-- Correct way
                              ),
                            );
                          }).toList(),


                          // items:
                          //     items.map((item) {
                          //       return DropdownMenuItem<String>(
                          //         value: item.value,
                          //         child: Text(
                          //           item.child.toString(), // ensure same text
                          //           style: TextStyle(
                          //             color: Colors.white,
                          //             // dropdown item text = white
                          //             fontSize: fontSize ?? 16.sp,
                          //           ),
                          //         ),
                          //       );
                          //     }).toList(),
                          // items:
                          //     items.map((item) {
                          //       return DropdownMenuItem<String>(
                          //         value: item.value,
                          //         child: CustomText(
                          //           title: (item.child as CustomText).title ?? "",
                          //
                          //           color: AppColors.colorA3A3A3,
                          //           fontSize: fontSize ?? 18.sp,
                          //           fontWeight: FontWeight.w400,
                          //         ),
                          //       );
                          //     }).toList(),

                        /*  items:
                          items.map((item) {
                            return DropdownMenuItem<String>(
                              value: item.value,
                              child: Text(
                                item.child.toString(), // ensure same text
                                style: TextStyle(
                                  color: Colors.white,
                                  // dropdown item text = white
                                  fontSize: fontSize ?? 16.sp,
                                ),
                              ),
                            );
                          }).toList(),*/


                          onChanged: (value) {
                            selectedValue.value = value ?? '';
                            onChanged(value);
                            state.didChange(value);
                          },
                          menuMaxHeight: 250.h,
                        ),
                        // child: DropdownButton<String>(
                        //   isExpanded: true,
                        //   dropdownColor: dropdownColor ?? Colors.white,
                        //   style: TextStyle(
                        //     fontSize: fontSize ?? 16.sp,
                        //     overflow: TextOverflow.ellipsis,
                        //     color: textColor ?? Colors.black,
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        //   hint: Text(
                        //     selectedValue.value.isEmpty
                        //         ? hint
                        //         : selectedValue.value,
                        //     style: TextStyle(
                        //       color: textColor ?? Colors.black,
                        //       fontSize: fontSize ?? 16.sp,
                        //       fontWeight: FontWeight.w400,
                        //     ),
                        //   ),
                        //   iconEnabledColor: Colors.grey,
                        //   items: items,
                        //   value: selectedValue.value.isEmpty
                        //       ? null
                        //       : selectedValue.value,
                        //   onChanged: (value) {
                        //     selectedValue.value = value ?? '';
                        //     onChanged(value);
                        //     state.didChange(value);
                        //   },
                        //   menuMaxHeight: 250.h,
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (state.hasError)
              CustomText(
                title: state.errorText ?? '',
                color: AppColors.colorFF3B30,
                fontSize: 13,
              ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
          ],
        );
      },
    );
  }
}

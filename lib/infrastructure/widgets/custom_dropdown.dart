import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../constants/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final String hintText;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? prefixIconPath;
  final double? dropDownHeight;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.prefixIconPath,
    this.dropDownHeight,
  });

  @override
  Widget build(BuildContext context) {
    final safeValue = (value != null && items.contains(value)) ? value : null;

    return Container(
      height: dropDownHeight ?? 65.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.textFieldBackground,
        // border: Border.all(color: AppColors.colorA3A3A3),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (prefixIconPath != null) ...[
            SvgPicture.asset(prefixIconPath ?? ''),
            SizedBox(width: 25.w),
          ],
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: safeValue,
                hint: Text(
                  hintText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.color4C4C4C,
                    fontSize: 16.sp,
                  ),
                ),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.color4C4C4C,
                  fontSize: 16.sp,
                ),
                items:
                    items.toSet().map((String val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

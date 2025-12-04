import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/widgets/custom_text.dart';

class CustomMultiSelectDropdown extends StatelessWidget {
  final String hint;
  final String iconPath;
  final RxList<String> selectedValues;
  final List<String> items;
  final double? fontSize;
  final double? iconSize;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? dropdownColor;
  final String? Function(List<String>?)? validator;

  const CustomMultiSelectDropdown({
    super.key,
    required this.hint,
    required this.iconPath,
    required this.selectedValues,
    required this.items,
    this.fontSize,
    this.iconSize,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.dropdownColor,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;

    if (iconPath.toLowerCase().endsWith('.svg')) {
      iconWidget = SvgPicture.asset(
        iconPath,
        color: textColor ?? AppColors.textFieldTextColor,
        width: iconSize ?? 24.w,
        height: iconSize ?? 24.h,
      );
    } else {
      iconWidget = Image.asset(
        iconPath,
        color: textColor ?? AppColors.textFieldTextColor,
        width: iconSize ?? 20.w,
        height: iconSize ?? 20.h,
      );
    }

    return FormField<List<String>>(
      initialValue: selectedValues.toList(),
      validator: validator,
      builder: (FormFieldState<List<String>> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showMultiSelectDialog(context, state),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: backgroundColor ?? AppColors.textFieldBackground,
                  borderRadius: BorderRadius.circular(borderRadius ?? 10),
                  border: Border.all(
                    color: state.hasError ? Colors.red : Colors.transparent,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  spacing: 18.w,
                  children: [
                    iconWidget,
                    Expanded(
                      child: Obx(() => Text(
                        selectedValues.isEmpty ? hint : selectedValues.join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fontSize ?? 16.sp,
                          color: textColor ?? AppColors.colorA3A3A3,
                        ),
                      )),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),

            if (state.hasError)
              CustomText(
                title: state.errorText!,
                color: AppColors.colorFF3B30,
                fontSize: 13,
              ).paddingSymmetric(horizontal: 16, vertical: 5),
          ],
        );
      },
    );
  }

  void _showMultiSelectDialog(
      BuildContext context,
      FormFieldState<List<String>> state,
      ) async {
    List<String> tempSelected = List.from(selectedValues);

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(hint, style: const TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  children: items.map((item) {
                    bool isChecked = tempSelected.contains(item);
                    return CheckboxListTile(
                      title: Text(item, style: const TextStyle(color: Colors.white)),
                      value: isChecked,
                      activeColor: AppColors.colorFF8600,
                      onChanged: (val) {
                        setStateSB(() {
                          if (val == true) {
                            tempSelected.add(item);
                          } else {
                            tempSelected.remove(item);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    /// Update RxList
                    selectedValues.assignAll(tempSelected);

                    /// IMPORTANT: Sync with FormField (like CustomDropdown example)
                    state.didChange(selectedValues.toList());

                    /// Force validation to show error immediately
                    state.validate();

                    Get.back();
                  },
                  child: const Text("OK", style: TextStyle(color: AppColors.colorFF8600)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

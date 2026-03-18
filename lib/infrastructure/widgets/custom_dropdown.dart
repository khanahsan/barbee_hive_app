import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final String? iconPath; // Nullable now
  final RxString selectedValue;
  final Function(String?) onChanged;
  final List<DropdownMenuItem<String>> items;
  final bool enableSearch;
  final String? searchHint;
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
    this.enableSearch = false,
    this.searchHint,
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
          color: AppColors.textFieldTextColor,
          width: iconSize ?? 24.w,
          height: iconSize ?? 24.h,
        );
      } else {
        iconWidget = Image.asset(
          iconPath!,
          color: AppColors.textFieldTextColor,
          width: iconSize ?? 20.w,
          height: iconSize ?? 20.h,
        );
      }
    }

    return FormField<String>(
      initialValue: selectedValue.value.isEmpty ? null : selectedValue.value,
      validator: validator,
      builder: (FormFieldState<String> state) {
        Widget buildContent() {
          if (enableSearch) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _showSearchDialog(context, state),
              child: Row(
                spacing: 20.w,
                children: [
                  if (iconWidget != null) iconWidget,
                  Expanded(
                    child: Text(
                      selectedValue.value.isEmpty ? hint : selectedValue.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor ?? AppColors.colorFFFFFF,
                        fontSize: fontSize ?? 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            );
          }

          return Row(
            spacing: 20.w,
            children: [
              if (iconWidget != null) iconWidget,
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    dropdownColor:
                        dropdownColor ?? AppColors.textFieldBackground,
                    // dropdown background = black
                    style: TextStyle(
                      fontSize: fontSize ?? 16.sp,
                      overflow: TextOverflow.ellipsis,
                      color: textColor ?? AppColors.colorA3A3A3,
                      // selected text = white
                      fontWeight: FontWeight.w400,
                    ),

                    hint: Text(
                      selectedValue.value.isEmpty ? hint : selectedValue.value,
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

                    items:
                        items.map((item) {
                          return DropdownMenuItem<String>(
                            value: item.value,
                            child: DefaultTextStyle(
                              style: TextStyle(
                                color: AppColors.colorFFFFFF,
                                fontSize: fontSize ?? 16.sp,
                              ),
                              child: item.child, // <-- Correct way
                            ),
                          );
                        }).toList(),

                    onChanged: (value) {
                      selectedValue.value = value ?? '';
                      onChanged(value);
                      state.didChange(value);
                    },
                    menuMaxHeight: 250.h,
                  ),
                ),
              ),
            ],
          );
        }

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
              child: Obx(() => buildContent()),
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

  void _showSearchDialog(BuildContext context, FormFieldState<String> state) {
    final TextEditingController searchController = TextEditingController();

    Get.dialog(
      StatefulBuilder(
        builder: (context, setStateSB) {
          final query = searchController.text.trim().toLowerCase();
          final filteredItems =
              query.isEmpty
                  ? items
                  : items.where((item) {
                    final label = _getItemLabel(item).toLowerCase();
                    return label.contains(query);
                  }).toList();

          return AlertDialog(
            backgroundColor: AppColors.textFieldBackground,
            title: Text(hint, style: const TextStyle(color: Colors.white)),
            content: SizedBox(
              width: double.maxFinite,
              height: 360.h,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: searchHint ?? 'Search',
                      hintStyle: TextStyle(color: AppColors.colorA3A3A3),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.colorA3A3A3,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.color4C4C4C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.colorFF8600),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (_) => setStateSB(() {}),
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child:
                        filteredItems.isEmpty
                            ? Center(
                              child: Text(
                                'No results',
                                style: TextStyle(
                                  color: AppColors.colorA3A3A3,
                                  fontSize: 14.sp,
                                ),
                              ),
                            )
                            : ListView.builder(
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                final label = _getItemLabel(item);
                                final value = item.value ?? label;
                                return ListTile(
                                  title: Text(
                                    label,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  onTap: () {
                                    selectedValue.value = value;
                                    onChanged(value);
                                    state.didChange(value);
                                    if (Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).canPop()) {
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pop();
                                    }
                                  },
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.of(context, rootNavigator: true).canPop()) {
                    Navigator.of(context, rootNavigator: true).pop();
                    return;
                  }
                  if (Get.isDialogOpen ?? false) {
                    Get.back(closeOverlays: true);
                  }
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
      barrierDismissible: true,
    );
  }

  String _getItemLabel(DropdownMenuItem<String> item) {
    final child = item.child;
    if (child is Text) {
      return child.data ?? child.textSpan?.toPlainText() ?? item.value ?? '';
    }
    if (child is CustomText) {
      return child.title ?? item.value ?? '';
    }
    return item.value ?? '';
  }
}

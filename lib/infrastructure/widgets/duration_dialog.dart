import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../infrastructure/constants/app_colors.dart';
import '../../../../infrastructure/constants/app_images.dart';
import '../../../../infrastructure/widgets/custom_btn.dart';
import '../../../../infrastructure/widgets/custom_dropdown.dart';
import '../../../../data/model/duration_model.dart';

class DurationDialog extends StatelessWidget {
  final List<DurationModel> durations;
  final DurationModel? selectedDuration;
  final String Function(DurationModel) durationLabel;

  const DurationDialog({
    super.key,
    required this.durations,
    required this.selectedDuration,
    required this.durationLabel,
  });

  String _amountLabel(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final selectedLabel =
        (selectedDuration != null
            ? durationLabel(selectedDuration!)
            : '')
            .obs;

    final selectedAmount =
        (selectedDuration != null
            ? _amountLabel(selectedDuration!.amount)
            : '')
            .obs;

    DurationModel? selected = selectedDuration;

    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        backgroundColor: AppColors.textFieldBackground,
        insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
        contentPadding: EdgeInsets.fromLTRB(
          15.w,
          12.h,
          15.w,
          15.h,
        ),

        title: Row(
          children: [
            const Expanded(
              child: Text(
                'Select Duration',
                style: TextStyle(
                  color: AppColors.colorFFFFFF,
                  fontSize: 20,
                ),
              ),
            ),

            GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(
                Icons.close,
                color: AppColors.colorFFFFFF,
                size: 20,
              ),
            ),
          ],
        ),

        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 450.w,
            maxHeight: 420.h,
          ),

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomDropdown(
                  borderColor: AppColors.colorFF8600,
                  hint: 'Select Duration',
                  iconPath: AppAssets.cardIcon,
                  selectedValue: selectedLabel,

                  onChanged: (value) {
                    if (value == null || value.isEmpty) {
                      selected = null;
                      selectedAmount.value = '';
                      return;
                    }

                    selected = durations.firstWhere(
                          (duration) =>
                      durationLabel(duration) == value,
                      orElse: () => durations.first,
                    );

                    selectedAmount.value = _amountLabel(
                      selected?.amount ?? 0,
                    );
                  },

                  items:
                  durations.map((duration) {
                    final label = durationLabel(duration);

                    return DropdownMenuItem(
                      value: label,
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: AppColors.colorFFFFFF,
                        ),
                      ),
                    );
                  }).toList(),

                  textColor: AppColors.colorFF8600,
                  dropdownColor: AppColors.colorFFFFFF,
                ),

                SizedBox(height: 20.h),

                Obx(
                      () =>
                  selectedAmount.value.isEmpty
                      ? const SizedBox.shrink()
                      : Column(
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          color: AppColors.colorA3A3A3,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 5.h),

                      Text(
                        selectedAmount.value,
                        style: const TextStyle(
                          color: AppColors.colorFF8600,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.h),

                Obx(
                      () => CustomBtn(
                    btnTitle: 'Select Duration',
                    buttonWidth: double.infinity,
                    buttonHeight: 45.h,
                    btnBackgroundColor:
                    selectedLabel.value.isEmpty
                        ? AppColors.color282828
                        : AppColors.colorFF8600,
                    btnTxtColor: AppColors.colorFFFFFF,
                    fontWeight: FontWeight.w600,
                    borderRadius: 10,

                    onPressed: () {
                      if (selected == null) return;

                      Get.back(result: selected);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
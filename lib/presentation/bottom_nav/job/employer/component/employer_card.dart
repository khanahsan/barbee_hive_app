import 'dart:io';

import 'package:barbee_hive_app/data/model/job_list_response.dart';
import 'package:barbee_hive_app/data/model/job_posting_model.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/services/stripe_service.dart';
import 'package:barbee_hive_app/infrastructure/utils/log_util.dart';
import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_dropdown.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../../../data/api/auth_provider.dart';
import '../../../../../../data/api/job/job_api.dart';
import '../../../../../../data/model/duration_model.dart';
import '../../../../../../presentation/bottom_nav/job/controller/job_controller.dart';

class EmployerCard extends StatelessWidget {
  final JobListData job;
  static final RxBool _isRenewing = false.obs;

  const EmployerCard({required this.job, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.color101010,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hours Design Tile
          Container(
            padding: EdgeInsets.only(
              left: 2.w,
              right: 5.w,
              top: 1.5.h,
              bottom: 1.5.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.r),
              border: Border.all(color: AppColors.colorFF8600, width: 1),
            ),
            child: Row(
              spacing: 5.w,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.color282828,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.r),
                      bottomLeft: Radius.circular(5.r),
                    ),
                  ),
                  child: Row(
                    spacing: 2.w,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.clockIcon,
                        height: 17.h,
                        width: 17.w,
                        fit: BoxFit.cover,
                      ),
                      CustomText(
                        title: "${job.remainingHours}hrs",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorFFFFFF,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (_isRenewing.value) return;
                    _isRenewing.value = true;
                    try {
                      final durationsResponse =
                          await AuthProvider.getDurations();
                      if (durationsResponse.duration.isEmpty) {
                        Utilities.showSnackBar(
                          title: 'Error',
                          message: 'No durations available. Please try again.',
                          isSuccess: false,
                        );
                        return;
                      }

                      final response = await _pickDurationAndRenew(
                        context,
                        durationsResponse.duration,
                        job.id,
                      );

                      if (response == null) return;

                      if (!response.status) {
                        Utilities.showSnackBar(
                          title: 'Error',
                          message: response.message,
                          isSuccess: false,
                        );
                        return;
                      }

                      final data = response.data;
                      final paymentRequired = data?.paymentRequired == true;

                      if (paymentRequired) {
                        final clientSecret = data?.payment?.clientSecret;

                        if (clientSecret == null || clientSecret.isEmpty) {
                          Utilities.showSnackBar(
                            title: 'Payment Error',
                            message:
                                'Payment details are missing. Please try again.',
                            isSuccess: false,
                          );
                          return;
                        }

                        if (Platform.isIOS) {
                          await StripeService.instance.initPaymentSheetIOS(
                            clientSecret: clientSecret,
                            merchantDisplayName: 'Barbee Hive',
                          );
                        } else {
                          await StripeService.instance.initPaymentSheetAndroid(
                            clientSecret: clientSecret,
                            merchantDisplayName: 'Barbee Hive',
                          );
                        }

                        final paymentSuccess =
                            await StripeService.instance.presentPaymentSheet();

                        if (!paymentSuccess) {
                          Utilities.showSnackBar(
                            title: 'Payment',
                            message: 'Payment was cancelled',
                            isSuccess: false,
                          );
                          return;
                        }

                        final controller = Get.find<JobController>();
                        controller.fetchEmployerJobs();
                      }

                      Utilities.showSnackBar(
                        title: 'Success',
                        message: response.message,
                        isSuccess: true,
                      );
                    } catch (e) {
                      Utilities.showSnackBar(
                        title: 'Error',
                        message: e.toString().replaceFirst('Exception: ', ''),
                        isSuccess: false,
                      );
                    } finally {
                      _isRenewing.value = false;
                    }
                  },
                  child: Text(
                    "Extend Job for \$1.99",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorFF8600,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.colorFF8600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Info Tile
          _buildRow(context: context),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: CustomBtn(
                  onPressed: () {
                    LogUtil.logError('job.id ${job.id}');
                    Get.toNamed(
                      Routes.applicationsScreen,
                      arguments: {'jobId': job.id},
                    );
                  },
                  btnTitle: "View Applications",
                  btnBackgroundColor: AppColors.color101010,
                  borderColor: AppColors.colorFF8600,
                  borderWidth: 1.0,
                  buttonHeight: 50.h,
                  fontSize: 15.sp,
                  btnTxtColor: AppColors.colorFFFFFF,
                ),
              ),
            /*  SizedBox(width: 10.w), // spacing between buttons
              Expanded(
                child: CustomBtn(
                  onPressed: () {
                    Get.toNamed(Routes.jobUpdateScreen, arguments: job);
                  },
                  btnTitle: "Edit Job",
                  btnBackgroundColor: AppColors.color101010,
                  borderColor: AppColors.colorFF8600,
                  borderWidth: 1.0,
                  buttonHeight: 50.h,
                  fontSize: 15.sp,
                  btnTxtColor: AppColors.colorFFFFFF,
                ),
              ),*/
            ],
          ),
        ],
      ),
    );
  }

  Future<JobPostResponse?> _pickDurationAndRenew(
    BuildContext context,
    List<DurationModel> durations,
    int jobId,
  ) {
    return showDialog<JobPostResponse>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final selectedLabel = ''.obs;
        final selectedAmount = ''.obs;
        final isProcessing = false.obs;
        DurationModel? selected;
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: AppColors.textFieldBackground,
            contentPadding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 15.h),
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
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    color: AppColors.colorFFFFFF,
                    size: 20,
                  ),
                ),
              ],
            ),
            content: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 420.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          (d) => _durationLabel(d) == value,
                          orElse: () => durations.first,
                        );
                        selectedAmount.value = _amountLabel(
                          selected?.amount ?? 0,
                        );
                      },
                      items:
                          durations.map((duration) {
                            final label = _durationLabel(duration);
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
                      textColor: AppColors.colorFFFFFF,
                      dropdownColor: AppColors.color4A4A4A,
                    ),
                    SizedBox(height: 20.h),
                    Obx(
                      () =>
                          selectedAmount.value.isEmpty
                              ? const SizedBox.shrink()
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                        btnTitle: 'Proceed Payment',
                        buttonWidth: double.infinity,
                        buttonHeight: 45.h,
                        btnBackgroundColor:
                            selectedLabel.value.isEmpty || isProcessing.value
                                ? AppColors.color282828
                                : AppColors.colorFF8600,
                        btnTxtColor: AppColors.colorFFFFFF,
                        fontWeight: FontWeight.w600,
                        borderRadius: 10,
                        isLoading: isProcessing.value,
                        onPressed: () async {
                          if (selectedLabel.value.isEmpty ||
                              isProcessing.value) {
                            return;
                          }
                          isProcessing.value = true;
                          try {
                            final response = await JobApi.renewJobIntent(
                              jobId: jobId,
                              days: selected?.days ?? 0,
                            );
                            if (!response.status) {
                              Utilities.showSnackBar(
                                title: 'Error',
                                message: response.message,
                                isSuccess: false,
                              );
                              return;
                            }
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop(response);
                            }
                          } catch (e) {
                            Utilities.showSnackBar(
                              title: 'Error',
                              message: e.toString().replaceFirst(
                                'Exception: ',
                                '',
                              ),
                              isSuccess: false,
                            );
                          } finally {
                            isProcessing.value = false;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _durationLabel(DurationModel duration) {
    return '${duration.days} Day';
  }

  String _amountLabel(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  Widget _buildRow({required BuildContext context}) {
    return Row(
      spacing: 20.w,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              title: "Job Role",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.colorFFFFFF,
            ),
            SizedBox(height: 15.h),

            CustomText(
              title: "Experience Level",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.colorFFFFFF,
            ),
            SizedBox(height: 15.h),

            CustomText(
              title: "Salary",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.colorFFFFFF,
            ),
            SizedBox(height: 15.h),

            CustomText(
              title: "Job Type",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.colorFFFFFF,
            ),
            SizedBox(height: 15.h),

            CustomText(
              title: "Location",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.colorFFFFFF,
            ),
          ],
        ),

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                title: job.title,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.colorFFFFFF,
              ),
              SizedBox(height: 15.h),

              CustomText(
                title: job.experienceLevel,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.colorFFFFFF,
              ),
              SizedBox(height: 15.h),

              CustomText(
                title: '\$${job.salaryRange.min} - ${job.salaryRange.max}',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.colorFFFFFF,
              ),
              SizedBox(height: 15.h),

              CustomText(
                title: job.jobType.name,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.colorFFFFFF,
              ),
              SizedBox(height: 15.h),

              SizedBox(
                width: 150.w,
                child: CustomText(
                  textOverflow: TextOverflow.ellipsis,
                  title:
                      '${job.country?.name}, ${job.state?.name}, ${job.city}',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorFFFFFF,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

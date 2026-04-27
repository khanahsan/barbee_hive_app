import 'package:barbee_hive_app/data/model/job_application_response.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/app_text_field.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/applications_screen/controller/application_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../../../infrastructure/widgets/custom_profile_image.dart';

class ApplicationsScreen extends GetView<ApplicationsController> {
  final int jobId;

  const ApplicationsScreen({required this.jobId, super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchApplications(jobId);
    });

    void showFilterDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          String? selectedPosition;
          String? selectedAge;
          String? selectedGender;
          String? selectedExperience;

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: AppColors.colorFFFFFF,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 10.h,
                ),
                insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20.h,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close,
                          color: AppColors.colorFF8600,
                          size: 24.sp,
                        ),
                      ),
                    ),

                    Text(
                      textAlign: TextAlign.center,
                      "Search Filter",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Obx(
                      () => _buildDropdownField(
                        context,
                        'Position',
                        controller.selectedSkill,
                        controller.updateSkill,
                        items:
                            controller.skills
                                .asMap()
                                .entries
                                .where(
                                  (entry) =>
                                      !controller.skills
                                          .sublist(0, entry.key)
                                          .map((e) => e.name)
                                          .contains(entry.value.name),
                                )
                                .map(
                                  (entry) => DropdownMenuItem(
                                    value: entry.value.name,
                                    child: Text(
                                      entry.value.name,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),

                    _buildTextField(context, 'Age', controller.ageController),

                    _buildDropdownField(
                      context,
                      'Gender',
                      controller.selectedGender,
                      controller.updateGender,
                      items: const [
                        DropdownMenuItem(
                          value: 'male',
                          child: Text(
                            'Male',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text(
                            'Female',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    _buildTextField(
                      context,
                      'Experience',
                      controller.experienceController,
                    ),
                    CustomBtn(
                      btnTitle: "Done",
                      buttonWidth: double.infinity,
                      fontSize: 15,
                      btnBackgroundColor: AppColors.colorFF8600,
                      buttonHeight: 55.h,
                      borderRadius: 10.r,
                      onPressed: () {
                        controller.filterApplicationsByText(
                          controller.searchController.text,
                        ); // Reapply filters
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: customAppbar(
        context: context,
        leadingTapFunction: () {
          Get.back();
        },
        leadingIconPath: AppAssets.backIcon,
        showHexagon: false,
        title: "Applications",
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () => controller.fetchApplications(jobId),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            children: [
              AppTextField(
                enabledBorderColor: AppColors.lightgrey,
                fillColor: AppColors.color101010,
                // cursorColor: AppColors.grey,
                // focusedBorderColor: AppColors.grey,
                // hintColor: Colors.grey.shade700,
                fontColor: Colors.white,
                filled: true,
                hintText: "Search by Filters",
                controller: controller.searchController,
                onChanged:
                    (value) => controller.filterApplicationsByText(value),
                suffixIcon: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => showFilterDialog(context),
                  child: SvgPicture.asset(
                    AppAssets.searchFilterIcon,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              if (controller.isLoading.value)
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.colorFF8600,
                  ),
                )
              else if (controller.errorMessage.isNotEmpty)
                Column(
                  children: [
                    Text(
                      controller.errorMessage.value,
                      style: TextStyle(color: Colors.red, fontSize: 16.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    CustomBtn(
                      btnTitle: 'Retry',
                      onPressed: () => controller.fetchApplications(jobId),
                      buttonWidth: 100.w,
                      btnBackgroundColor: AppColors.colorFF8600,
                      buttonHeight: 40.h,
                      fontSize: 16.sp,
                    ),
                  ],
                )
              else if (controller.filteredApplications.isEmpty)
                Center(
                  child: Text(
                    'No applications found',
                    style: TextStyle(
                      color: AppColors.colorFFFFFF,
                      fontSize: 16.sp,
                    ),
                  ),
                )
              else
                ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 15.h),
                  itemCount: controller.filteredApplications.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    print('Building card for index: $index'); // Debug
                    return _applicationsCard(
                      context: context,
                      application: controller.filteredApplications[index],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _applicationsCard({
    required BuildContext context,
    required JobApplyData application,
  }) {
    print('Rendering card for: ${application.applicant.email}');
    print('Application details: $application');
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 8.h, left: 8.w, right: 8.w, top: 5.h),
      decoration: BoxDecoration(
        color: AppColors.color101010,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: 15.w,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomProfileImage(
                imagePath: application.applicant.profileImage ?? '',
                width: 100.w,
                height: 110.h,
                borderColor: AppColors.colorFF8600,
                isEditMode: false,
                // set to true if you want edit functionality
                wholeAvatarClickable: false,
                testIcon: '',
                // optional, if you want to show an icon when no image
                text:
                    application.applicant.name != null
                        ? application.applicant.name![0].toUpperCase()
                        : '', // initial
              ),

              Column(
                spacing: 5.h,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title:
                        application.applicant.name ??
                        application.applicant.email,
                    fontSize: 20,
                    color: AppColors.colorFFFFFF,
                    fontWeight: FontWeight.w800,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: AppColors.colorE0E0E0),
                    ),
                    child: Row(
                      spacing: 3.w,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppAssets.locationBIcon,
                          height: 15.h,
                          width: 15.w,
                          fit: BoxFit.cover,
                        ),
                        CustomText(
                          title:
                              application.applicant.country?.name ?? 'Unknown',

                          fontSize: 10,
                          color: AppColors.colorFFFFFF,
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            spacing: 15.w,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                spacing: 10.h,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    title: 'Job Role',
                    fontSize: 14,
                    color: AppColors.colorFFFFFF,
                    fontWeight: FontWeight.w800,
                  ),

                  CustomText(
                    title: 'Years of Experience',
                    fontSize: 14,
                    color: AppColors.colorFFFFFF,
                    fontWeight: FontWeight.w800,
                  ),

                  CustomText(
                    title: 'Expected Salary',
                    fontSize: 14,
                    color: AppColors.colorFFFFFF,
                    fontWeight: FontWeight.w800,
                  ),

                  CustomText(
                    title: 'Experience Level',
                    fontSize: 14,
                    color: AppColors.colorFFFFFF,
                    fontWeight: FontWeight.w800,
                  ),
                ],
              ),

              Column(
                spacing: 10.h,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150.w,
                    child: CustomText(
                      title:
                          application.applicant.skills != null &&
                                  application.applicant.skills!.isNotEmpty
                              ? application.applicant.skills!
                                  .map((skill) => skill.name)
                                  .join(', ')
                              : 'N/A',
                      fontSize: 14,
                      color: AppColors.colorFFFFFF,
                      fontWeight: FontWeight.w800,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ),

                  CustomText(
                    title: '${application.yearsOfExperience} Years',
                    fontSize: 14,
                    color: AppColors.colorFFFFFF,
                    fontWeight: FontWeight.w800,
                  ),

                  CustomText(
                    title: '\$${application.expectedSalary}',
                    fontSize: 14,
                    color: AppColors.colorFFFFFF,
                    fontWeight: FontWeight.w800,
                  ),

                  CustomText(
                    title: application.experienceLevel.name,
                    fontSize: 14,
                    color: AppColors.colorFFFFFF,
                    fontWeight: FontWeight.w800,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: CustomBtn(
                  btnTitle: 'View Profile',
                  buttonWidth: double.infinity,
                  btnBackgroundColor: AppColors.color101010,
                  borderColor: AppColors.colorFF8600,
                  borderWidth: 1.0,
                  fontSize: 15.sp,
                  buttonHeight: 55.h,
                  onPressed:
                      () => Get.toNamed(
                        Routes.applicantProfile,
                        arguments: {'applicationData': application},
                      ),

                  // onTap:
                  //     () => Get.toNamed(
                  //       Routes.applicantProfile,
                  //       arguments: {'userId': application.applicant.id},
                  //     ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomBtn(
                  btnTitle: 'Send Message',
                  buttonWidth: double.infinity,
                  btnBackgroundColor: AppColors.colorFF8600,
                  fontSize: 15.sp,
                  buttonHeight: 55.h,
                  // onTap: () {
                  //   Get.to(
                  //     () => ChatScreen(
                  //       chatId:
                  //           "${chatController.currentUserId.value}-${application.applicant.uid}", // Potential chatId
                  //       otherUserId: application.applicant.uid,
                  //       otherName:
                  //           application.applicant.name ??
                  //           application.applicant.email,
                  //       otherImage: application.applicant.profileImage ?? '',
                  //       employeeData: {
                  //         'uid': application.applicant.uid,
                  //         'name':
                  //             application.applicant.name ??
                  //             application.applicant.email,
                  //         'profileImage':
                  //             application.applicant.profileImage ?? '',
                  //       },
                  //     ),
                  //   );
                  // },
                  onPressed: () {
                    Get.toNamed(
                      Routes.chatScreen,
                      arguments: {"otherUserID": application.applicant.uid},
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    BuildContext context,
    String hint,
    RxString selectedValue,
    Function(String?) onChanged, {
    required List<DropdownMenuItem<String>> items,
  }) {
    return Obx(
      () => DropdownButtonFormField<String>(
        dropdownColor: AppColors.colorFF8600,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.colorFFFFFF,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.colorA3A3A3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.colorA3A3A3),
          ),
        ),
        hint: Text(
          selectedValue.value.isEmpty ? hint : selectedValue.value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 15.sp,
            color: AppColors.colorA3A3A3,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 15.sp,
          color: AppColors.colorFFFFFF,
          fontWeight: FontWeight.w500,
        ),
        iconEnabledColor: AppColors.colorFFFFFF,
        value: selectedValue.value.isEmpty ? null : selectedValue.value,
        items:
            items.map((DropdownMenuItem<String> item) {
              return DropdownMenuItem<String>(
                value: item.value,
                child: Text(
                  item.value!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.colorFFFFFF,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
        onChanged: onChanged,
        isExpanded: true,
        menuMaxHeight: 300.h,
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String hint,
    TextEditingController textController, {
    String? icon,
    bool readOnly = false,
    void Function()? onTap,
    int? maxLine,
  }) {
    return GetBuilder<ApplicationsController>(
      builder:
          (controller) => TextField(
            maxLines: maxLine ?? 1,
            controller: textController,
            readOnly: readOnly,
            onTap: onTap,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 15.sp,
              color: AppColors.colorA3A3A3,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 15.sp,
                color: AppColors.colorA3A3A3,
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: AppColors.colorFFFFFF,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 8.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.colorA3A3A3),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.colorA3A3A3),
              ),
            ),
          ),
    );
  }
}

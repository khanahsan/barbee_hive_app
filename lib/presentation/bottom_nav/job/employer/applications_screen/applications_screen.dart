import 'package:barbee_hive_app/data/model/job_application_response.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/navigation/routes.dart';
import 'package:barbee_hive_app/infrastructure/widgets/app_text_field.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_appbar.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/infrastructure/widgets/hexagon_clipper.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/job/employer/applications_screen/controller/application_controller.dart';
import 'package:barbee_hive_app/presentation/bottom_nav/message/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class ApplicationsScreen extends GetView<ApplicationsController> {
  final int jobId;

  ApplicationsScreen({required this.jobId, super.key});

  // final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchApplications(jobId);
    });

    Widget _buildDropdown({
      required String label,
      required String? value,
      required List<String> items,
      required ValueChanged<String?> onChanged,
    }) {
      return DropdownButtonFormField<String>(
        dropdownColor: AppColors.color101010,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.colorFFFFFF,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.colorA3A3A3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.colorA3A3A3),
          ),
        ),
        hint: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 15.sp,
            color: AppColors.colorA3A3A3,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconEnabledColor: AppColors.colorA3A3A3,
        value: value,
        items:
            items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.colorA3A3A3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
        onChanged: onChanged,
      );
    }

    void _showFilterDialog(BuildContext context) {
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
                    CustomButton(
                      buttonText: "Done",
                      buttonWidth: double.infinity,
                      buttonTextSize: 15.sp,
                      buttonColor: AppColors.colorFF8600,
                      buttonHeight: 55.h,
                      borderRadius: 10.r,
                      onTap: () {
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
        () => Column(
          mainAxisSize: MainAxisSize.min,
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
              onChanged: (value) => controller.filterApplicationsByText(value),
              suffixIcon: GestureDetector(
                onTap: () => _showFilterDialog(context),
                child: SvgPicture.asset(
                  AppAssets.searchFilterIcon,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            if (controller.isLoading.value)
              const Center(
                child: CircularProgressIndicator(color: AppColors.colorFF8600),
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
                  CustomButton(
                    buttonText: 'Retry',
                    onTap: () => controller.fetchApplications(jobId),
                    buttonWidth: 100.w,
                    buttonColor: AppColors.colorFF8600,
                    buttonHeight: 40.h,
                    buttonTextSize: 16.sp,
                  ),
                ],
              )
            else if (controller.filteredApplications.isEmpty)
              Text(
                'No applications found',
                style: TextStyle(color: AppColors.colorFFFFFF, fontSize: 16.sp),
              )
            else
              Flexible(
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 15.h),
                  itemCount: controller.filteredApplications.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    print('Building card for index: $index'); // Debug
                    return _applicationsCard(
                      context: context,
                      application: controller.filteredApplications[index],
                    );
                  },
                ),
              ),
          ],
        ).paddingSymmetric(horizontal: 15.w, vertical: 15.h),
      ),
    );
  }

  Widget _applicationsCard({
    required BuildContext context,
    required JobApplicationData application,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              HexagonAvatar(
                imagePath:
                    application.applicant.profileImage ??
                    AppAssets.profileImage,
                width: 80.w,
                height: 90.h,
              ),
              SizedBox(width: 15.w),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    application.applicant.name ?? application.applicant.email,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 22.sp,
                      color: AppColors.colorFFFFFF,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: AppColors.colorE0E0E0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppAssets.locationBIcon,
                          height: 15.h,
                          width: 15.w,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          application.applicant.country ?? 'Unknown',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontSize: 10.sp,
                            color: AppColors.colorFFFFFF,
                            fontWeight: FontWeight.w800,
                          ),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Job Role',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.colorFFFFFF,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Years of Experience',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.colorFFFFFF,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Expected Salary',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.colorFFFFFF,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Experience Level',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.colorFFFFFF,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 15.w),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    application.applicant.skills!.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.colorFFFFFF,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    '${application.yearsOfExperience} Years',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.colorFFFFFF,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    '\$${application.expectedSalary}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.colorFFFFFF,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    application.experienceLevel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.colorFFFFFF,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: CustomButton(
                  buttonText: 'View Profile',
                  buttonWidth: double.infinity,
                  buttonColor: AppColors.color101010,
                  borderColor: AppColors.colorFF8600,
                  buttonTextSize: 15.sp,
                  buttonHeight: 55.h,

                  /*onTap: () {
                    print('View Profile: ${application.applicant.id}');
                    // Get.toNamed('/profile/${application.applicant.id}');

                  },*/
                  onTap:
                      () => Get.toNamed(
                        Routes.applicantProfile,
                        arguments: {'userId': application.applicant.id},
                      ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomButton(
                  buttonText: 'Send Message',
                  buttonWidth: double.infinity,
                  buttonColor: AppColors.colorFF8600,
                  buttonTextSize: 15.sp,
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
                  onTap: () {
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
        dropdownColor: AppColors.colorFFFFFF,
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
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        iconEnabledColor: AppColors.colorA3A3A3,
        value: selectedValue.value.isEmpty ? null : selectedValue.value,
        items:
            items.map((DropdownMenuItem<String> item) {
              return DropdownMenuItem<String>(
                value: item.value,
                child: Text(
                  item.value!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 15.sp,
                    color: Colors.black,
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

import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/presentation/sign_up_view/views/select_role_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/constants/app_colors.dart';
import '../../infrastructure/widgets/custom_btn.dart';
import 'controllers/sign_up_view.controller.dart';


class HexagonClipper extends CustomClipper<Path> {
  final double borderOffset;

  HexagonClipper({this.borderOffset = 0.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    final double width = size.width;
    final double height = size.height;
    final double offset = borderOffset;

    // Adjust the points to account for the offset (for border)
    path.moveTo(width * 0.5, offset); // Top center
    path.lineTo(width - offset, height * 0.25 + offset); // Top right
    path.lineTo(width - offset, height * 0.75 - offset); // Bottom right
    path.lineTo(width * 0.5, height - offset); // Bottom center
    path.lineTo(offset, height * 0.75 - offset); // Bottom left
    path.lineTo(offset, height * 0.25 + offset); // Top left
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SignUpViewScreen extends GetView<SignUpViewController> {
  const SignUpViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
     
      body: SafeArea(
        child: Hero(
          tag: 'gold_line',
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(top: 20.h),
              padding: EdgeInsets.only(top: 3.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0.r),
                  topRight: Radius.circular(20.0.r),
                ),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18.0),
                        topLeft: Radius.circular(18.0))),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        spacing: 30.w,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Get.back(),
                          ),
                          Text(
                            'Sign Up as Employee',
                            style: TextStyle(color: Colors.white, fontSize: 25.0.sp, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(10.w),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Border layer (slightly larger hexagon)
                            ClipPath(
                              clipper: HexagonClipper(borderOffset: -2.w), // Negative offset to make it larger
                              child: Container(
                                width: 124.w, // Slightly larger to accommodate the border
                                height: 124.h,
                                color: AppColors.primary, // Border color
                              ),
                            ),
                            // Content layer (inner hexagon)
                            ClipPath(
                              clipper: HexagonClipper(),
                              child: Container(
                                width: 120.w,
                                height: 120.h,
                                color: Colors.black, // Background color
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.linked_camera_outlined,
                                      color: AppColors.grey, // Gray color for the icon
                                      size: 40.sp,
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      'Upload Photo',
                                      style: TextStyle(
                                        color: AppColors.grey, // Gray color for the text
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _buildTextField(context, 'Name', Icons.person),
                      SizedBox(height: 15.h),
                      _buildTextField(context, 'Email Address', Icons.email),
                      SizedBox(height: 15.h),
                      _buildTextField(context, 'Password', Icons.lock, isPassword: true),
                      SizedBox(height: 15.h),
                      _buildTextField(context, 'Confirm Password', Icons.lock, isPassword: true),
                      SizedBox(height: 15.h),
                      _buildTextField(context, 'Experience', Icons.work),
                      SizedBox(height: 15.h),
                      _buildTextField(context, 'MM/DD/YYYY', Icons.calendar_today),
                      SizedBox(height: 15.h),
                      _buildDropdownField(context, 'Select Gender', Icons.female),
                      SizedBox(height: 15.h),
                      _buildDropdownField(context, 'Select Height', Icons.height),
                      SizedBox(height: 30.h),
                      CustomButton(
                        btnTitle: 'Create Account',
                        btnBackgroundColor: Colors.orange,
                        btnTxtColor: Colors.white,
                        width: double.infinity,
                        height: 45.h,
                        borderRadius: 25.r,
                        onPressed: () {
                          // Handle sign-up logic
                        },
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String hint, IconData icon, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: isPassword
            ? IconButton(
          icon: const Icon(Icons.visibility, color: Colors.grey),
          onPressed: () {},
        )
            : null,
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context, String hint, IconData icon) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor: Colors.grey[900],
      items: const [
        DropdownMenuItem(value: 'Option 1', child: Text('Option 1', style: TextStyle(color: Colors.white))),
        DropdownMenuItem(value: 'Option 2', child: Text('Option 2', style: TextStyle(color: Colors.white))),
      ],
      onChanged: (value) {},
    );
  }
}
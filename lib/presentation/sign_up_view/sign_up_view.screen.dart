import 'package:barbee_hive_app/infrastructure/widgets/custom_button.dart';
import 'package:barbee_hive_app/presentation/sign_up_view/views/select_role_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../infrastructure/widgets/custom_btn.dart';
import 'controllers/sign_up_view.controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Custom Clipper for Hexagonal Shape (if needed for the Upload Photo section)
class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double width = size.width;
    final double height = size.height;

    path.moveTo(width * 0.5, 0); // Top center
    path.lineTo(width, height * 0.25); // Top right
    path.lineTo(width, height * 0.75); // Bottom right
    path.lineTo(width * 0.5, height); // Bottom center
    path.lineTo(0, height * 0.75); // Bottom left
    path.lineTo(0, height * 0.25); // Top left
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Sign Up as Employee',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload Photo Section
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    child: ClipPath(
                      clipper: HexagonClipper(),
                      child: Container(
                        width: 120.w,
                        height: 120.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 2.w),
                          color: Colors.black,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 40.sp,
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              'Upload Photo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Gold line with Hero widget for animation
                  Hero(
                    tag: 'gold_line', // Same tag as AccountTypeScreen
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 50.w,
                        height: 2.h,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Form Fields
            _buildTextField(context, 'Name', Icons.person),
            SizedBox(height: 10.h),
            _buildTextField(context, 'Email Address', Icons.email),
            SizedBox(height: 10.h),
            _buildTextField(context, 'Password', Icons.lock, isPassword: true),
            SizedBox(height: 10.h),
            _buildTextField(context, 'Confirm Password', Icons.lock, isPassword: true),
            SizedBox(height: 10.h),
            _buildTextField(context, 'Experience', Icons.work),
            SizedBox(height: 10.h),
            _buildTextField(context, 'MM/DD/YYYY', Icons.calendar_today),
            SizedBox(height: 10.h),
            _buildDropdownField(context, 'Select Gender', Icons.female),
            SizedBox(height: 10.h),
            _buildDropdownField(context, 'Select Height', Icons.height),
            SizedBox(height: 20.h),
            // Create Account Button
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
          ],
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
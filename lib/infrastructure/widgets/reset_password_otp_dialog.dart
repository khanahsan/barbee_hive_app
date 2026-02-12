import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:barbee_hive_app/infrastructure/widgets/app_text_field.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_btn.dart';
import 'package:barbee_hive_app/infrastructure/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class ResetPasswordOtpDialog extends StatefulWidget {
  const ResetPasswordOtpDialog({super.key, required this.email, this.onDone});

  final String email;
  final Future<void> Function(String otp)? onDone;

  @override
  State<ResetPasswordOtpDialog> createState() => _ResetPasswordOtpDialogState();
}

class _ResetPasswordOtpDialogState extends State<ResetPasswordOtpDialog> {
  final _controllers = List<TextEditingController>.generate(
    6,
    (_) => TextEditingController(),
  );
  final _focusNodes = List<FocusNode>.generate(6, (_) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _handleChanged(String value, int index) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.white,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 30.h,
                bottom: 24.h,
                left: 20.w,
                right: 20.w,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Image.asset(
                      AppAssets.emailSend,
                      width: 80.w,
                      height: 80.h,
                    ),
                  ),
                  SizedBox(height: 15.h),

                  CustomText(
                    title: "Reset Password",
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: AppColors.color000000,
                  ),
                  SizedBox(height: 5.h),

                  CustomText(
                    title: "We've sent an OTP to your email.",
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.color000000,
                  ),
                  SizedBox(height: 10.h),

                  CustomText(
                    title: widget.email,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.colorFF8600,
                  ),
                  SizedBox(height: 10.h),

                  CustomText(
                    textAlign: TextAlign.center,
                    title:
                        "Please enter the code below\n"
                        "to verify your identity.",
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.color000000,
                  ),
                  SizedBox(height: 30.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      6,
                      (i) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: SizedBox(
                          width: 45.w,
                          height: 45.h,
                          child: AppTextField(
                            controller: _controllers[i],
                            focusNode: _focusNodes[i],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            hintText: "",
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1),
                            ],
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 15.h,
                            ),
                            fillColor: AppColors.colorFAFAFA,
                            enabledBorderColor: AppColors.colorE3E3E3,
                            focusedBorderColor: AppColors.colorFF8600,
                            fontColor: AppColors.color000000,
                            onChanged: (v) => _handleChanged(v, i),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35.h),

                  CustomBtn(
                    btnTitle: "Done",
                    isLoading: _isLoading,
                    onPressed: () async {
                      final otp = _controllers.map((c) => c.text).join();
                      if (otp.length < 6) return;
                      if (widget.onDone != null) {
                        setState(() => _isLoading = true);
                        try {
                          await widget.onDone!(otp);
                        } finally {
                          if (mounted) {
                            setState(() => _isLoading = false);
                          }
                        }
                      } else {
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                    },
                    buttonHeight: 46,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            Positioned(
              right: 4.w,
              top: 4.h,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: AppColors.colorFF8600,
                  size: 22.sp,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

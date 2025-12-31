import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../constants/app_colors.dart';

class Utilities {
  static void showSnackBar({
    required String message,
    String? title,
    Color? textColor,
    double? borderRadius,
    bool isSuccess = true,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    Get.snackbar(
      title ?? '',
      message,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      colorText: textColor ?? AppColors.colorFFFFFF,
      duration: duration,
      borderRadius: borderRadius ?? 12.r,
      dismissDirection: DismissDirection.startToEnd,
    );
  }

  static void showToast({required String toastMsg, required bool isSuccess}) {
    Fluttertoast.showToast(
      msg: toastMsg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }


  static getTime(DateTime time){
    DateTime localDateTime = time.toLocal();
    return DateFormat('hh:mm a').format(localDateTime);
  }

}

extension StringCasingExtension on String {
  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String get toTitleCase => replaceAll(
    RegExp(' +'),
    ' ',
  ).split(' ').map((str) => str.toCapitalized).join(' ');
}



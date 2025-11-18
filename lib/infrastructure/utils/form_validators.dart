import 'dart:developer';

import 'package:flutter/material.dart';

class FormValidators {
  // Validate if the user is at least 18 years old
  static String? validateAge(dynamic value) {
    if (value == null || value.isEmpty) {
      return 'Date of Birth required';
    }

    try {
      final normalized = value.toString().replaceAll('/', '-');
      final parts = normalized.split('-');
      if (parts.length != 3) return 'Invalid date format';

      final int month = int.parse(parts[0]);
      final int day = int.parse(parts[1]);
      final int year = int.parse(parts[2]);

      final birthDate = DateTime(year, month, day);

      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      if (age < 18) return 'You must be at least 18 years old';
    } catch (_) {
      return 'Invalid date format';
    }

    return null;
  }


  // Email validation
  static String? validateEmail(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'Email required';
    }
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.toString())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password validation
  static String? validatePassword(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'Please enter your password';
    }
    if (value.toString().length < 8) {
      return 'Password must be at least 8 characters long';
    }
    // Uncomment these for additional password strength checks
    // if (!value.contains(RegExp(r'[A-Z]'))) {
    //   return 'Password must contain at least one uppercase letter';
    // }
    // if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    //   return 'Password must contain at least one special character';
    // }
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(dynamic value, dynamic password) {
    if (value == null || value.toString().isEmpty) {
      return 'Please confirm your password';
    }
    debugPrint(value);
    debugPrint(password);
    if (value.toString() != password.toString()) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Expiry date validation
  static String? validateExpiryDate(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'Expiry date required';
    }
    try {
      final DateTime expiryDate = DateTime.parse(value.toString());
      final DateTime today = DateTime.now();
      if (expiryDate.isBefore(DateTime(today.year, today.month, today.day))) {
        return 'Expiry date cannot be earlier than today';
      }
    } catch (e) {
      return 'Invalid date format';
    }
    return null;
  }

  // Phone number validation
  static String? validatePhoneNumber(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'Phone Number required';
    }
    final regex = RegExp(r'^1868\d{7}$');
    if (!regex.hasMatch(value.toString())) {
      return 'Phone number must be in the format 1868(1234567)';
    }
    return null;
  }

  // Helper function to calculate age
  static int _calculateAge(DateTime birthDate) {
    final DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Account number validation (8 to 30 digits)
  static String? validateAccountNumber(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'Account Number required';
    }
    final regex = RegExp(r'^\d{8,30}$');
    if (!regex.hasMatch(value.toString())) {
      return 'Account Number must be between 8 and 30 digits';
    }
    return null;
  }

  // License plate validation (Format: ABC-123)
  static String? validateLicensePlate(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'License plate is required';
    }
    // final regex = RegExp(r'^[A-Z]{3}-\d{3}$');
    // if (!regex.hasMatch(value.toString())) {
    //   return 'License plate must be in the format ABC-123';
    // }
    return null;
  }

  // IBAN validation (15 to 50 alphanumeric characters)
  static String? validateIBAN(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'IBAN required';
    }
    final regex = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z0-9]+$',
    ); // Ensures both letters and numbers
    if (!regex.hasMatch(value.toString())) {
      return 'IBAN must contain both letters and numbers';
    }
    return null;
  }

  // static String? validateIBAN(dynamic value) {
  //   if (value == null || value.toString().isEmpty) {
  //     return 'IBAN required';
  //   }
  //   final regex = RegExp(r'^[A-Za-z0-9]{15,50}$'); // Corrected regex
  //   if (!regex.hasMatch(value.toString())) {
  //     return 'IBAN must be alphanumeric and between 15 to 50 characters';
  //   }
  //   return null;
  // }

  // Validate required field
  static String? validateRequired(dynamic value, String fieldName) {
    if (value == null || value.toString().isEmpty) {
      return '$fieldName required';
    }
    return null;
  }

  static String? validateSalary(
      String? value,
      String fieldName, {
        int min = 5,
        int max = 10000,
        bool isMinField = true, // true if this is the minimum salary field
      }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    final parsed = int.tryParse(value);
    if (parsed == null) {
      return '$fieldName must be a number';
    }

    if (isMinField && parsed < min) {
      return 'Minimum salary is $min';
    }

    if (!isMinField && parsed > max) {
      return 'Maximum salary is $max';
    }

    return null;
  }



  // Account Name validation (Only alphabets allowed)
  static String? validateName(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'Name required';
    }
    final regex = RegExp(r'^[a-zA-Z\s]+$'); // Allows only alphabets and spaces
    if (!regex.hasMatch(value.toString())) {
      return 'Only letters allowed';
    }
    return null;
  }

  static String? validateEventName(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'Name required';
    }
    return null;
  }

  static String? validateEndDateField(String? endDate, String? startDate) {
    if (endDate == null || endDate.isEmpty || startDate == null || startDate.isEmpty) {
      return null; // Skip if one is empty – let required validator handle it
    }

    try {
      final DateTime start = DateTime.parse(startDate);
      final DateTime end = DateTime.parse(endDate);
      if (start.isAfter(end)) {
        return 'Must be after start date';
      }
    } catch (_) {
      return 'Invalid date format';
    }
    return null;
  }

  static String? validateEndTimeField({
    required String? startTime,
    required String? endTime,
    required String? startDate,
    required String? endDate,
  }) {
    if (startTime == null || startTime.isEmpty || endTime == null || endTime.isEmpty) {
      return null; // Let the required validator handle this case
    }

    try {
      final DateTime startDateTime = _combineDateAndTime(startDate, startTime);
      final DateTime endDateTime = _combineDateAndTime(endDate, endTime);

      if (!endDateTime.isAfter(startDateTime)) {
        return 'Must be after start time';
      }
    } catch (_) {
      return 'Invalid time or date format';
    }

    return null;
  }

  static DateTime _combineDateAndTime(String? dateStr, String timeStr) {
    final DateTime date = DateTime.parse(dateStr!);
    final TimeOfDay time = TimeOfDay(
      hour: int.parse(timeStr.split(":")[0]),
      minute: int.parse(timeStr.split(":")[1].split(" ")[0]),
    );
    final bool isPM = timeStr.toLowerCase().contains("pm");
    final int hour = isPM && time.hour < 12 ? time.hour + 12 : time.hour;

    return DateTime(date.year, date.month, date.day, hour, time.minute);
  }

  static String? validateAvailableSlots(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return 'Available Slots required';
    }

    final int? parsedValue = int.tryParse(value.toString());
    if (parsedValue == null) {
      return 'Available Slots must be a number';
    }

    if (parsedValue < 1) {
      return 'Available Slots must be at least 1';
    }

    return null;
  }
}

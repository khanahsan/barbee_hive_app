import 'dart:io';

import 'package:barbee_hive_app/infrastructure/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../constants/app_images.dart';
import 'hexagon_clipper.dart';

/*
typedef OnImagePicked = void Function(File file);

class CustomProfileImage extends StatelessWidget {
  const CustomProfileImage({
    super.key,
    required this.imagePath,
    this.width = 130,
    this.height = 140,
    this.borderColor,
    this.text,
    this.onImagePicked,
    this.isEditMode = false, // NEW FLAG
    this.showFullText = false,
    this.testIcon = '',
  });

  final String imagePath;
  final double width;
  final double height;
  final Color? borderColor;
  final String? text;
  final OnImagePicked? onImagePicked;
  final bool showFullText;
  final String? testIcon;

  /// NEW FLAG
  /// true  → only edit icon clickable
  /// false → whole avatar widget clickable
  final bool isEditMode;

  bool get _isNetworkImage =>
      imagePath.isNotEmpty &&
      (imagePath.startsWith('http://') || imagePath.startsWith('https://'));

  bool get _isAssetImage =>
      imagePath.isNotEmpty &&
      (imagePath.endsWith('.png') ||
          imagePath.endsWith('.jpg') ||
          imagePath.endsWith('.jpeg'));

  Widget _buildInitial() {
    return Container(
      color: AppColors.color000000,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Show icon if testIcon is not null or empty
          if (testIcon != null && testIcon!.trim().isNotEmpty)
            SvgPicture.asset(
              testIcon!,
              width: showFullText ? width * 0.17 : width * 0.21,
              height: showFullText ? width * 0.17 : width * 0.21,
              color: AppColors.colorFFFFFF,
            ).paddingOnly(bottom: width * 0.05),

          // Show text
          if (text != null && text!.trim().isNotEmpty)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                showFullText
                    ? text!
                        .trim() // full name smaller
                    : text!.trim()[0].toUpperCase(), // single letter bigger
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.colorFFFFFF,
                  fontWeight: FontWeight.bold,
                  fontSize: showFullText ? width * 0.11 : width * 0.45,
                ),
              ),
            )
          else
            // fallback person icon if text is null
            Icon(
              Icons.person,
              size: width * 0.35,
              color: AppColors.colorFFFFFF,
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final bool showInitial =
        !_isNetworkImage && !_isAssetImage && !File(imagePath).existsSync();

    return ClipPath(
      clipper: HexagonClipper(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
        color: borderColor ?? AppColors.colorFF8600,
        child: ClipPath(
          clipper: HexagonClipper(),
          child: Container(
            padding: const EdgeInsets.all(3.5),
            color: AppColors.black,
            child: ClipPath(
              clipper: HexagonClipper(),
              child: SizedBox(
                width: width.w,
                height: height.h,
                child:
                    showInitial
                        ? _buildInitial()
                        : _isNetworkImage
                        ? Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildInitial(),
                        )
                        : File(imagePath).existsSync()
                        ? Image.file(File(imagePath), fit: BoxFit.cover)
                        : Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildInitial(),
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    if (!isEditMode) return const SizedBox.shrink();

    return Positioned(
      bottom: height.h * 0.08,
      right: width.w * 0.65,
      child: GestureDetector(
        onTap:
            isEditMode
                ? () => _showImagePickerOptions(context)
                : null, // Only clickable in edit mode
        child: ClipPath(
          clipper: HexagonClipper(),
          child: Container(
            padding: const EdgeInsets.all(1),
            color: borderColor ?? AppColors.colorFF8600,
            child: ClipPath(
              clipper: HexagonClipper(),
              child: Container(
                alignment: Alignment.center,
                color: AppColors.black,
                padding: const EdgeInsets.all(4),
                child: SvgPicture.asset(
                  AppAssets.editIcon,
                  width: width.w * 0.125,
                  height: height.h * 0.125,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text(
                  "Pick from Camera",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text(
                  "Pick from Gallery",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final hasPermission = await _requestPermission(source);

    if (!hasPermission) {
      // Show simple message
      Utilities.showSnackBar(
        title: 'Permission Denied',
        message:
            source == ImageSource.camera
                ? 'Camera permission is required.'
                : 'Gallery permission is required.',
        isSuccess: false,
      );

      await Future.delayed(const Duration(seconds: 3));
      openAppSettings();
      return;
    }

    // Permission granted, proceed to pick image
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null && onImagePicked != null) {
      onImagePicked!(File(pickedFile.path));
    }
  }

  Future<bool> _requestPermission(ImageSource source) async {
    Permission permission =
        source == ImageSource.camera ? Permission.camera : Permission.photos;

    if (await permission.isGranted) return true;

    final result = await permission.request();
    return result.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SizedBox(
      width: width.w,
      height: height.h,
      child: Stack(
        alignment: Alignment.center,
        children: [_buildAvatar(), _buildEditButton(context)],
      ),
    );

    // NEW BEHAVIOR:
    // If NOT edit mode → whole widget opens image picker
    return isEditMode
        ? content
        : GestureDetector(
          onTap: () => _showImagePickerOptions(context),
          child: content,
        );
  }
}
*/


typedef OnImagePicked = void Function(File file);

class CustomProfileImage extends StatelessWidget {
  const CustomProfileImage({
    super.key,
    required this.imagePath,
    this.width = 130,
    this.height = 140,
    this.borderColor,
    this.text,
    this.onImagePicked,
    this.isEditMode = false,
    this.wholeAvatarClickable = true,
    this.showFullText = false,
    this.testIcon = '',
  });

  final String imagePath;
  final double width;
  final double height;
  final Color? borderColor;
  final String? text;
  final OnImagePicked? onImagePicked;
  final bool isEditMode;            // edit profile mode
  final bool wholeAvatarClickable;  // registration mode
  final bool showFullText;
  final String? testIcon;

  bool get _isNetworkImage =>
      imagePath.isNotEmpty &&
          (imagePath.startsWith('http://') || imagePath.startsWith('https://'));

  bool get _isAssetImage =>
      imagePath.isNotEmpty &&
          (imagePath.endsWith('.png') ||
              imagePath.endsWith('.jpg') ||
              imagePath.endsWith('.jpeg'));

  Widget _buildInitial() {
    return Container(
      color: AppColors.color000000,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (testIcon != null && testIcon!.trim().isNotEmpty)
            SvgPicture.asset(
              testIcon!,
              width: showFullText ? width * 0.17 : width * 0.21,
              height: showFullText ? width * 0.17 : width * 0.21,
              color: AppColors.colorFFFFFF,
            ).paddingOnly(bottom: width * 0.05),
          if (text != null && text!.trim().isNotEmpty)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                showFullText
                    ? text!.trim()
                    : text!.trim()[0].toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.colorFFFFFF,
                  fontWeight: FontWeight.bold,
                  fontSize: showFullText ? width * 0.11 : width * 0.45,
                ),
              ),
            )
          else
            Icon(
              Icons.person,
              size: width * 0.35,
              color: AppColors.colorFFFFFF,
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final bool showInitial =
        !_isNetworkImage && !_isAssetImage && !File(imagePath).existsSync();

    return ClipPath(
      clipper: HexagonClipper(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
        color: borderColor ?? AppColors.colorFF8600,
        child: ClipPath(
          clipper: HexagonClipper(),
          child: Container(
            padding: const EdgeInsets.all(3.5),
            color: AppColors.black,
            child: ClipPath(
              clipper: HexagonClipper(),
              child: SizedBox(
                width: width.w,
                height: height.h,
                child: showInitial
                    ? _buildInitial()
                    : _isNetworkImage
                    ? Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildInitial(),
                )
                    : File(imagePath).existsSync()
                    ? Image.file(File(imagePath), fit: BoxFit.cover)
                    : Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildInitial(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    if (!isEditMode) return const SizedBox.shrink();

    return Positioned(
      bottom: height.h * 0.08,
      right: width.w * 0.65,
      child: GestureDetector(
        onTap: () => _showImagePickerOptions(context),
        child: ClipPath(
          clipper: HexagonClipper(),
          child: Container(
            padding: const EdgeInsets.all(1),
            color: borderColor ?? AppColors.colorFF8600,
            child: ClipPath(
              clipper: HexagonClipper(),
              child: Container(
                alignment: Alignment.center,
                color: AppColors.black,
                padding: const EdgeInsets.all(4),
                child: SvgPicture.asset(
                  AppAssets.editIcon,
                  width: width.w * 0.125,
                  height: height.h * 0.125,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.white),
            title: const Text(
              "Pick from Camera",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.white),
            title: const Text(
              "Pick from Gallery",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final hasPermission = await _requestPermission(source);

    if (!hasPermission) {
      Utilities.showSnackBar(
        title: 'Permission Denied',
        message: source == ImageSource.camera
            ? 'Camera permission is required.'
            : 'Gallery permission is required.',
        isSuccess: false,
      );

      await Future.delayed(const Duration(seconds: 3));
      openAppSettings();
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null && onImagePicked != null) {
      onImagePicked!(File(pickedFile.path));
    }
  }

  Future<bool> _requestPermission(ImageSource source) async {
    Permission permission =
    source == ImageSource.camera ? Permission.camera : Permission.photos;

    if (await permission.isGranted) return true;

    final result = await permission.request();
    return result.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SizedBox(
      width: width.w,
      height: height.h,
      child: Stack(
        alignment: Alignment.center,
        children: [_buildAvatar(), _buildEditButton(context)],
      ),
    );

    // Registration: whole avatar clickable
    if (wholeAvatarClickable) {
      return GestureDetector(
        onTap: () => _showImagePickerOptions(context),
        child: content,
      );
    }

    // Edit profile: only edit button clickable when isEditMode=true
    return content;
  }
}

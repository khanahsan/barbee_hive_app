/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../constants/app_images.dart';
import 'hexagon_clipper.dart';

class CustomProfileImage extends StatelessWidget {
  const CustomProfileImage({
    super.key,
    required this.imagePath,
    this.width = 130,
    this.height = 140,
    this.borderColor,
    this.name,
    this.showEditButton = false,
    this.onEditPressed,
  });

  final String imagePath;
  final double width;
  final double height;
  final Color? borderColor;
  final String? name;
  final bool showEditButton;
  final VoidCallback? onEditPressed;

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
      color: AppColors.colorFF8600,
      alignment: Alignment.center,
      child: Text(
        name != null && name!.isNotEmpty ? name![0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: width * 0.25,
          fontWeight: FontWeight.bold,
          color: AppColors.colorFFFFFF,
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final bool showInitial = !_isNetworkImage && !_isAssetImage;

    return ClipPath(
      clipper: HexagonClipper(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
        color: borderColor ?? AppColors.colorFF8600, // Outer border
        child: ClipPath(
          clipper: HexagonClipper(),
          child: Container(
            padding: const EdgeInsets.all(3.5), // Inner padding
            color: AppColors.black, // Inner border
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

  Widget _buildEditButton() {
    if (!showEditButton) return const SizedBox.shrink();

    return Positioned(
      bottom: height.h * 0.08,
      right: width.w * 0.65,
      child: GestureDetector(
        onTap: onEditPressed,
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildAvatar(),
          _buildEditButton(),
        ],
      ),
    );
  }
}
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../infrastructure/constants/app_colors.dart';
import '../constants/app_images.dart';
import 'hexagon_clipper.dart';

typedef OnImagePicked = void Function(File file);

class CustomProfileImage extends StatelessWidget {
  const CustomProfileImage({
    super.key,
    required this.imagePath,
    this.width = 130,
    this.height = 140,
    this.borderColor,
    this.name,
    this.showEditButton = false,
    this.onImagePicked,
  });

  final String imagePath;
  final double width;
  final double height;
  final Color? borderColor;
  final String? name;
  final bool showEditButton;

  /// Callback when a new image is picked
  final OnImagePicked? onImagePicked;

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
      color: AppColors.colorFF8600,
      alignment: Alignment.center,
      child: Text(
        name != null && name!.isNotEmpty ? name![0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: width * 0.25,
          fontWeight: FontWeight.bold,
          color: AppColors.colorFFFFFF,
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final bool showInitial = !_isNetworkImage &&
        !_isAssetImage &&
        !File(imagePath).existsSync(); // check for local file

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
                    ? Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                )
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
    if (!showEditButton) return const SizedBox.shrink();

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
            title: const Text("Pick from Camera", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.white),
            title: const Text("Pick from Gallery", style: TextStyle(color: Colors.white)),
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
    // Request permission
    if (!await _requestPermission(source)) return;

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
    return SizedBox(
      width: width.w,
      height: height.h,
      child: Stack(
        alignment: Alignment.center,
        children: [_buildAvatar(), _buildEditButton(context)],
      ),
    );
  }
}


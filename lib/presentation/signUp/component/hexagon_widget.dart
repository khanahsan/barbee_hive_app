import 'dart:io';

import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:barbee_hive_app/infrastructure/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    final centerX = width / 2;
    final centerY = height / 2;

    path.moveTo(centerX + width * 0.5 * 0.866, centerY - height * 0.5 * 0.5);
    path.lineTo(centerX + width * 0.5 * 0.866, centerY + height * 0.5 * 0.5);
    path.lineTo(centerX, centerY + height * 0.5);
    path.lineTo(centerX - width * 0.5 * 0.866, centerY + height * 0.5 * 0.5);
    path.lineTo(centerX - width * 0.5 * 0.866, centerY - height * 0.5 * 0.5);
    path.lineTo(centerX, centerY - height * 0.5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HexagonAvatar extends StatelessWidget {
  const HexagonAvatar({
    super.key,
    this.height,
    this.width,
    this.borderColor,
    required this.iconPath,
    this.selectedImage,
    this.imageUrl,
    this.onTap,
  });

  final double? height;
  final double? width;
  final Color? borderColor;
  final String iconPath;
  final File? selectedImage;
  final String? imageUrl;
  final VoidCallback? onTap;

  bool _isNetworkImage(String? path) {
    return path != null &&
        path.isNotEmpty &&
        (path.startsWith('http://') || path.startsWith('https://'));
  }

  @override
  Widget build(BuildContext context) {
    final double resolvedWidth = width ?? 160.w;
    final double resolvedHeight = height ?? resolvedWidth * 0.866;

    return GestureDetector(
      onTap: onTap,
      child: ClipPath(
        clipper: HexagonClipper(),
        child: Container(
          width: resolvedWidth,
          height: resolvedHeight,
          color:
              borderColor ??
              AppColors.colorFF8600, // Replace with AppColors.primary
          padding: EdgeInsets.all(3.w),
          child: ClipPath(
            clipper: HexagonClipper(),
            child: Container(
              color: Colors.black, // Replace with AppColors.black
              child: _buildImage(context, resolvedWidth, resolvedHeight),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, double width, double height) {
    if (_isNetworkImage(imageUrl)) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.contain,
        width: width,
        height: height,
        errorBuilder:
            (context, error, stackTrace) => _buildDefaultIcon(width, height),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
            ),
          );
        },
      );
    } else if (selectedImage != null) {
      return Image.file(
        selectedImage!,
        fit: BoxFit.contain,
        width: width,
        height: height,
        errorBuilder:
            (context, error, stackTrace) => _buildDefaultIcon(width, height),
      );
    } else {
      return SvgPicture.asset(
        iconPath,
        fit: BoxFit.contain,
        width: width * 0.6,
        height: height * 0.6,
        placeholderBuilder: (context) => _buildDefaultIcon(width, height),
      );
    }
  }

  Widget _buildDefaultIcon(double width, double height) {
    return Center(
      child: SvgPicture.asset(
        iconPath,
        fit: BoxFit.contain,
        width: width * 0.5,
        height: height * 0.5,
      ),
    );
  }
}


/*class HexagonProfilePhotoTile extends StatelessWidget {
  final File? selectedImage;
  final String? imageUrl;
  final VoidCallback? onTap;

  const HexagonProfilePhotoTile({
    super.key,
    this.selectedImage,
    this.imageUrl,
    this.onTap,
  });

  bool _isNetworkImage(String? path) {
    return path != null &&
        path.isNotEmpty &&
        (path.startsWith('http://') || path.startsWith('https://'));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer hexagon border
          ClipPath(
            clipper: HexagonClipper(),
            child: Container(
              width: 124.w,
              height: 124.h,
              color: AppColors.colorFF8600,
              padding: EdgeInsets.all(3.w),
              child: ClipPath(
                clipper: HexagonClipper(),
                child: Container(
                  color: AppColors.black,
                  child: _buildInnerContent(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerContent() {
    // ✅ Show network image
    if (_isNetworkImage(imageUrl)) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) =>
            _buildUploadPlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    // ✅ Show local selected image
    if (selectedImage != null) {
      return Image.file(
        selectedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) =>
            _buildUploadPlaceholder(),
      );
    }

    // ✅ Show upload placeholder
    return _buildUploadPlaceholder();
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppAssets.cameraLogo,
          color: AppColors.grey,
          height: 25.h,
        ),
        SizedBox(height: 5.h),
        Text(
          'Upload Photo',
          style: TextStyle(color: AppColors.grey, fontSize: 14.sp),
        ),
      ],
    );
  }
}*/

import 'dart:async';

import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class FadingImageCarousel extends StatefulWidget {
  const FadingImageCarousel({super.key, required this.imagePaths});

  final List<String> imagePaths;

  @override
  State<FadingImageCarousel> createState() => _FadingImageCarouselState();
}

class _FadingImageCarouselState extends State<FadingImageCarousel> {
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.imagePaths.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.imagePaths.length, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          height: 8.h,
          width: 8.w,
          decoration: BoxDecoration(
            color: _currentIndex == index ? AppColors.white : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 600),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: ClipRRect(
            key: ValueKey<int>(_currentIndex),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              height: 200.h,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.categoryLabel, width: 0.5),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.asset(
                  widget.imagePaths[_currentIndex],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        _buildDotsIndicator(),
      ],
    );
  }
}

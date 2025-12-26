import 'dart:async';
import 'dart:ui';

import 'package:barbee_hive_app/infrastructure/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

class CustomFadingCarousel extends StatefulWidget {
  const CustomFadingCarousel({
    super.key,
    required this.imagePaths,
    this.showIndicators,
  });

  final List<String> imagePaths;
  final bool? showIndicators;

  @override
  State<CustomFadingCarousel> createState() => _FadingImageCarouselState();
}

class _FadingImageCarouselState extends State<CustomFadingCarousel> {
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
      spacing: 6.w,
      children: List.generate(widget.imagePaths.length, (index) {
        double size = 11.w; // Equal height and width
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          height: size,
          width: size,
          child: CustomPaint(
            painter: HexagonPainter(
              color:
                  _currentIndex == index
                      ? AppColors.colorFF8600
                      : Colors.transparent,
              borderColor: AppColors.colorFFFFFF,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 600),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: ClipRRect(
            key: ValueKey<int>(_currentIndex),
            // borderRadius: BorderRadius.circular(12.r),
            child: Container(
              height: 370.h,
              decoration: BoxDecoration(
                // border: Border.all(color: AppColors.categoryLabel, width: 0.5),
                // borderRadius: BorderRadius.circular(20.r),
              ),
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(20.r),
                child: Image.network(
                  widget.imagePaths[_currentIndex],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        if(widget.showIndicators ?? true)
        Positioned(
          bottom: 130.h,
          right: 0.w,
          left: 0.w,
          //top: 0.w,
          child: _buildDotsIndicator(),
        ),
      ],
    );
  }
}

class HexagonPainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  HexagonPainter({required this.color, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Path hexagonPath = Path();
    final double w = size.width;
    final double h = size.height;

    hexagonPath.moveTo(w * 0.5, 0);
    hexagonPath.lineTo(w, h * 0.25);
    hexagonPath.lineTo(w, h * 0.75);
    hexagonPath.lineTo(w * 0.5, h);
    hexagonPath.lineTo(0, h * 0.75);
    hexagonPath.lineTo(0, h * 0.25);
    hexagonPath.close();

    // Fill paint
    final Paint fillPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Border paint
    final Paint borderPaint =
        Paint()
          ..color = borderColor
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    // Draw filled shape
    canvas.drawPath(hexagonPath, fillPaint);

    // Optional: round corners using PathMetrics (approximation)
    final PathMetrics pathMetrics = hexagonPath.computeMetrics();
    for (final PathMetric metric in pathMetrics) {
      final Path path = metric.extractPath(0, metric.length);
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsShimmer extends StatelessWidget {
  const DetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShimmerBox(height: 180.h, width: double.infinity),
            SizedBox(height: 16.h),
            _ShimmerBox(height: 20.h, width: 220.w),
            SizedBox(height: 10.h),
            _ShimmerBox(height: 14.h, width: 160.w),
            SizedBox(height: 24.h),
            _ShimmerBox(height: 120.h, width: double.infinity),
            SizedBox(height: 20.h),
            _ShimmerBox(height: 90.h, width: double.infinity),
            SizedBox(height: 20.h),
            _ShimmerBox(height: 140.h, width: double.infinity),
          ],
        ),
      ),
    );
  }
}
class _ShimmerBox extends StatefulWidget {
  final double height;
  final double width;

  const _ShimmerBox({
    required this.height,
    required this.width,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final shift = _controller.value * 2 - 1;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            gradient: LinearGradient(
              begin: Alignment(-1 - shift, 0),
              end: Alignment(1 - shift, 0),
              colors: [
                Colors.black.withValues(alpha: 0.04),
                Colors.black.withValues(alpha: 0.12),
                Colors.black.withValues(alpha: 0.04),
              ],
            ),
          ),
        );
      },
    );
  }
}

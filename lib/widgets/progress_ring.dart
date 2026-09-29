import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Inelul de progres din cardul „Today’s Challenge” (ex: 15/20).
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.value,
    required this.total,
    this.size = 50,
    this.strokeWidth = 5,
  });

  final int value;
  final int total;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final double progress = total == 0 ? 0 : (value / total).clamp(0.0, 1.0);
    return SizedBox.square(
      dimension: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, animated, _) => CustomPaint(
          painter: _RingPainter(animated, strokeWidth),
          child: Center(
            child: Text(
              '$value/$total',
              style: AppTextStyles.xSmallMedium
                  .copyWith(color: AppColors.greyscale0),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.progress, this.strokeWidth);

  final double progress;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset(strokeWidth / 2, strokeWidth / 2) &
        Size(size.width - strokeWidth, size.height - strokeWidth);

    final Paint track = Paint()
      ..color = AppColors.greyscale700
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect, 0, 2 * math.pi, false, track);

    final Paint arc = Paint()
      ..color = AppColors.primary500
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    // În design arcul pornește din stânga (ora 9) și merge în sens orar.
    canvas.drawArc(rect, math.pi, 2 * math.pi * progress, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.strokeWidth != strokeWidth;
}

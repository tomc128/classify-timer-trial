import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timer_trial/constants.dart';

class ZoneClockPainter extends CustomPainter {
  final double progress;

  const ZoneClockPainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kPurpleColor2
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 2;

    canvas.drawCircle(center, radius, paint);

    final progressPaint = Paint()
      ..color = homePink
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final progressPath = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        -2 * pi * (1 - progress),
      );

    canvas.drawPath(progressPath, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is ZoneClockPainter) {
      return oldDelegate.progress != progress;
    }

    return false;
  }
}

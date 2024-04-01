import 'dart:math' as math;
import 'package:flutter/material.dart';

class StepsDonutChart extends StatelessWidget {
  final int steps;
  final int maxSteps;

  const StepsDonutChart({
    Key? key,
    required this.steps,
    this.maxSteps = 10000,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = steps / maxSteps;
    return SizedBox(
      width: 150,
      height: 150,
      child: CustomPaint(
        painter: DonutChartPainter(percentage: percentage),
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color backgroundColor;
  final Color color;

  DonutChartPainter({
    required this.percentage,
    this.strokeWidth = 10,
    this.backgroundColor = Colors.grey,
    this.color = Colors.blue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final arcPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    const startAngle = -math.pi / 2;
    final sweepAngle = math.pi * 2 * percentage;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
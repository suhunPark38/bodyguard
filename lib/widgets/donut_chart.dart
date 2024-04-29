import 'package:flutter/material.dart';
import 'dart:math';

class DonutChart extends StatelessWidget {
  final double ratio;

  const DonutChart({required this.ratio});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(150, 150),
            painter: DonutChartPainter(ratio: ratio),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '${(ratio * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final double ratio;

  DonutChartPainter({required this.ratio});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.2;

    final paint = Paint()
      ..color = Colors.blue // 그래프 색상
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final backgroundPaint = Paint()
      ..color = Colors.grey[300]! // 배경 색상
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // 배경 그리기
    canvas.drawCircle(center, radius, backgroundPaint);

    // 그래프 그리기
    final sweepAngle = 2 * pi * ratio;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
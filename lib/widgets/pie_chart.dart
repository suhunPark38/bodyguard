import 'package:flutter/material.dart';
import 'dart:math';
import '../model/data_color_pair.dart'; // DataColorPair 클래스를 포함한 파일 import


class PieChart extends StatelessWidget {
  final List<DataColorPair> data;
  final double total; // 총합 추가
  const PieChart({required this.data, required this.total});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: CustomPaint(
        size: Size(150, 150),
        painter: PieChartPainter(data: data, total: total),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<DataColorPair> data;
  final double total;


  PieChartPainter({required this.data, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.2;
    final double total = data.fold(0, (previousValue, element) => previousValue + element.data);

    double startAngle = -pi / 2;

    for (int i = 0; i < data.length; i++) {
      final double sweepAngle = 2 * pi * (data[i].data / total);
      final paint = Paint()
        ..color = data[i].color // 데이터에 대응하는 색상 사용
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }


    // 총합 텍스트 표시
    final textStyle = TextStyle(fontSize: 14, color: Colors.black); // 텍스트 스타일 설정
    final textSpan = TextSpan(
      text: 'Total: $total kcal', // 텍스트 내용과 포맷 설정
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(); // 텍스트 레이아웃 설정
    final textWidth = textPainter.width;
    final textHeight = textPainter.height;
    final textOffset = Offset(center.dx - textWidth / 2, center.dy - textHeight / 2); // 텍스트 위치 계산

    textPainter.paint(canvas, textOffset); // 캔버스에 텍스트 그리기

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

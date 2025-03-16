import 'package:flutter/material.dart';

class DrawPainterWidget extends CustomPainter {
  final List<Map<String, dynamic>> points; // 좌표와 색상을 함께 저장
  final Offset? eraserPosition; // 지우개의 현재 위치
  final bool isEraserMode; // 지우개 모드 여부
  final double eraserSize; // 지우개 크기

  DrawPainterWidget(this.points, this.eraserPosition, this.isEraserMode, this.eraserSize);

  @override
  void paint(Canvas canvas, Size size) {
    // 배경색 설정
    final backgroundPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // 선 그리기
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i]['offset'] != null && points[i + 1]['offset'] != null) {
        final paint = Paint()
          ..color = points[i]['color'] // 각 점의 색상 적용
          ..strokeWidth = points[i]['strokeWidth'] ?? 4.0 // 각 점의 굵기 적용
          ..strokeCap = StrokeCap.round; // 선 끝을 둥글게 설정

        canvas.drawLine(
          points[i]['offset'],
          points[i + 1]['offset'],
          paint,
        );
      }
    }

    // 지우개 범위 표시
    if (isEraserMode && eraserPosition != null) {
      final eraserPaint = Paint()
        ..color = Colors.grey.shade400 // 지우개 범위 색상
        ..style = PaintingStyle.fill;

      canvas.drawCircle(eraserPosition!, eraserSize / 2, eraserPaint); // 지우개 범위 그리기
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true; // 항상 다시 그리도록 설정
}

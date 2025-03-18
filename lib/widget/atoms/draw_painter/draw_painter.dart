import 'package:flutter/material.dart';

class DrawPainterWidget extends CustomPainter {
  DrawPainterWidget(
    this.points,
    this.eraserPosition,
    this.isEraserMode,
    this.eraserSize,
  );

  final List<Map<String, dynamic>> points; // 좌표와 색상을 함께 저장
  final Offset? eraserPosition; // 지우개의 현재 위치
  final bool isEraserMode; // 지우개 모드 여부
  final double eraserSize; // 지우개 크기

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawLines(canvas);
    if (isEraserMode && eraserPosition != null) {
      _drawEraser(canvas);
    }
  }

  void _drawBackground(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
  }

  void _drawLines(Canvas canvas) {
    for (int i = 0; i < points.length - 1; i++) {
      final currentPoint = points[i];
      final nextPoint = points[i + 1];

      if (currentPoint['offset'] != null && nextPoint['offset'] != null) {
        final paint = Paint()
          ..color = currentPoint['color']
          ..strokeWidth = currentPoint['strokeWidth'] ?? 4.0
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(
          currentPoint['offset'],
          nextPoint['offset'],
          paint,
        );
      }
    }
  }

  void _drawEraser(Canvas canvas) {
    final eraserPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.fill;

    canvas.drawCircle(eraserPosition!, eraserSize / 2, eraserPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

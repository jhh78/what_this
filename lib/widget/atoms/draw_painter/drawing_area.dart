import 'package:flutter/material.dart';
import 'package:whats_this/widget/atoms/draw_painter/draw_painter.dart';

class DrawingAreaWidget extends StatelessWidget {
  final List<Map<String, dynamic>> points;
  final Offset? eraserPosition;
  final bool isEraserMode;
  final double selectedStrokeWidth;
  final Color selectedColor;
  final ValueChanged<Offset> onPanUpdate;
  final VoidCallback onPanEnd;

  const DrawingAreaWidget({
    super.key,
    required this.points,
    required this.eraserPosition,
    required this.isEraserMode,
    required this.selectedStrokeWidth,
    required this.selectedColor,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onPanUpdate: (details) => onPanUpdate(details.localPosition),
        onPanEnd: (_) => onPanEnd(),
        child: CustomPaint(
          painter: DrawPainterWidget(
            points,
            eraserPosition,
            isEraserMode,
            selectedStrokeWidth,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

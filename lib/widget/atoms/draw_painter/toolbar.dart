import 'package:flutter/material.dart';
import 'package:whats_this/widget/atoms/draw_painter/color_picker_button.dart';
import 'package:whats_this/widget/atoms/draw_painter/eraser_button.dart';
import 'stroke_width_dropdown.dart';

class ToolbarWidget extends StatelessWidget {
  final Color selectedColor;
  final VoidCallback onPickColor;
  final double selectedStrokeWidth;
  final ValueChanged<int?> onStrokeWidthChanged;
  final bool isEraserMode;
  final VoidCallback onToggleEraser;

  const ToolbarWidget({
    super.key,
    required this.selectedColor,
    required this.onPickColor,
    required this.selectedStrokeWidth,
    required this.onStrokeWidthChanged,
    required this.isEraserMode,
    required this.onToggleEraser,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ColorPickerButtonWidget(
          selectedColor: selectedColor,
          onPickColor: onPickColor,
        ),
        const SizedBox(width: 16),
        StrokeWidthDropdownWidget(
          selectedStrokeWidth: selectedStrokeWidth,
          onStrokeWidthChanged: onStrokeWidthChanged,
        ),
        const SizedBox(width: 16),
        EraserButtonWidget(
          isEraserMode: isEraserMode,
          onToggleEraser: onToggleEraser,
        ),
      ],
    );
  }
}

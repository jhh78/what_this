import 'package:flutter/material.dart';

class ColorPickerButtonWidget extends StatelessWidget {
  const ColorPickerButtonWidget({
    super.key,
    required this.selectedColor,
    required this.onPickColor,
  });

  final Color selectedColor;
  final VoidCallback onPickColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPickColor,
      icon: Icon(Icons.color_lens, color: selectedColor, size: 36),
    );
  }
}

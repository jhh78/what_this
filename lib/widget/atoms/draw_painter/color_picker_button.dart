import 'package:flutter/material.dart';

class ColorPickerButtonWidget extends StatelessWidget {
  final Color selectedColor;
  final VoidCallback onPickColor;

  const ColorPickerButtonWidget({
    super.key,
    required this.selectedColor,
    required this.onPickColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPickColor,
      icon: const Icon(Icons.color_lens),
      color: selectedColor,
      iconSize: 36,
    );
  }
}

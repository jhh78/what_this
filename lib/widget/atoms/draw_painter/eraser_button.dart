import 'package:flutter/material.dart';

class EraserButtonWidget extends StatelessWidget {
  final bool isEraserMode;
  final VoidCallback onToggleEraser;

  const EraserButtonWidget({
    super.key,
    required this.isEraserMode,
    required this.onToggleEraser,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onToggleEraser,
      icon: Icon(
        isEraserMode ? Icons.remove_circle : Icons.remove_circle_outline_outlined,
        color: Colors.blueAccent,
      ),
      iconSize: 36,
    );
  }
}

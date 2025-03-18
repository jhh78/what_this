import 'package:flutter/material.dart';
import 'package:whats_this/util/styles.dart';

class EraserButtonWidget extends StatelessWidget {
  const EraserButtonWidget({
    super.key,
    required this.isEraserMode,
    required this.onToggleEraser,
  });

  final bool isEraserMode;
  final VoidCallback onToggleEraser;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onToggleEraser,
      icon: Icon(
        isEraserMode ? Icons.remove_circle : Icons.remove_circle_outline,
        color: Colors.blueAccent,
        size: ICON_SIZE,
      ),
    );
  }
}

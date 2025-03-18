import 'package:flutter/material.dart';
import 'package:whats_this/util/styles.dart';

class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget({
    super.key,
    required this.color,
    required this.onPressed,
    required this.icon,
  });

  final Color color;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: ICON_SIZE_SMALL,
      icon: Icon(icon, color: color),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: ICON_SIZE_SMALL,
        minHeight: ICON_SIZE_SMALL,
      ),
      onPressed: onPressed,
    );
  }
}

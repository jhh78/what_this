import 'package:flutter/material.dart';

class SimpleButtonWidget extends StatelessWidget {
  const SimpleButtonWidget({
    super.key,
    required this.onClick,
    required this.title,
  });

  final VoidCallback onClick;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: _buttonStyle(),
      onPressed: onClick,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      side: const BorderSide(color: Colors.grey, width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}

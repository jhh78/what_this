import 'package:flutter/material.dart';

class StrokeWidthDropdownWidget extends StatelessWidget {
  final double selectedStrokeWidth;
  final ValueChanged<int?> onStrokeWidthChanged;

  const StrokeWidthDropdownWidget({
    super.key,
    required this.selectedStrokeWidth,
    required this.onStrokeWidthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: selectedStrokeWidth.toInt(),
      items: List.generate(100, (index) => index + 1)
          .map((int value) => DropdownMenuItem<int>(
                value: value,
                child: Text(
                  '$value pt',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ))
          .toList(),
      onChanged: onStrokeWidthChanged,
      dropdownColor: Colors.white,
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      menuMaxHeight: 250,
    );
  }
}

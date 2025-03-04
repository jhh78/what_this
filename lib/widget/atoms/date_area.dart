import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateAreaWidget extends StatelessWidget {
  const DateAreaWidget({super.key, required this.currentTime});

  final String currentTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5),
        Text(
          DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(currentTime)),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
        ),
      ],
    );
  }
}

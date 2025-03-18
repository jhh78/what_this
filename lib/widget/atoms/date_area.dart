import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateAreaWidget extends StatelessWidget {
  const DateAreaWidget({super.key, required this.currentTime});

  final String currentTime;

  @override
  Widget build(BuildContext context) {
    final localDateTime = DateTime.parse(currentTime).toLocal();
    final formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(localDateTime);

    return Text(
      formattedDate,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
    );
  }
}

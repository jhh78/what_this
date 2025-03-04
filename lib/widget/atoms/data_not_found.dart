import 'package:flutter/material.dart';

class DataNotFoundWidget extends StatelessWidget {
  const DataNotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            "😱 Data Not Found",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

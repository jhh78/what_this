import 'package:flutter/material.dart';

class DataNotFoundWidget extends StatelessWidget {
  const DataNotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(
              color: Colors.blueAccent.withAlpha(100),
              width: 2,
            ),
          ),
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                "😱 Data Not Found",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "😕",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black, fontSize: 200),
                ),
                SizedBox(height: 16),
                Text(
                  "Oops!",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

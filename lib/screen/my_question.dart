import 'package:flutter/material.dart';

class MyQuestionScreen extends StatelessWidget {
  const MyQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('My Question'),
        ),
      ),
    );
  }
}

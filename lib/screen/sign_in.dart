import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/screen/home.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: InkWell(
            onTap: () {
              Get.offAll(() => HomeScreen(), transition: Transition.fade);
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.cyan,
                    Colors.blue,
                  ],
                ),
              ),
              child: Text(
                'Sign In',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

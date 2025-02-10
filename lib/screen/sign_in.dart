import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:whats_this/screen/home.dart';
import 'package:whats_this/service/auth.dart';
import 'package:whats_this/util/hive.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  Future<void> _handleSignIn() async {
    try {
      if (Platform.isAndroid) {
        await AuthService.signInWithGoogle();
      } else if (Platform.isIOS) {
        await AuthService.signInWithApple();
      }

      Box box = await Hive.openBox(SYSTEM_BOX);
      box.put(IS_FIRST_INSTALL, true);

      Get.offAll(() => HomeScreen(), transition: Transition.fade);
    } catch (error) {
      log(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/signIn.png",
                fit: BoxFit.fill,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100, left: 30, right: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (Platform.isAndroid)
                      SignInButton(
                        Buttons.GoogleDark,
                        onPressed: _handleSignIn,
                      ),
                    if (Platform.isIOS)
                      SignInButton(
                        Buttons.AppleDark,
                        onPressed: _handleSignIn,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/screen/policy.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final UserProvider userProvider = Get.put(UserProvider());

  handleMovePolicy() {
    Get.to(() => PolicyScreen(), transition: Transition.upToDown, duration: Duration(milliseconds: 500));
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
                        onPressed: handleMovePolicy,
                      ),
                    if (Platform.isIOS)
                      SignInButton(
                        Buttons.AppleDark,
                        onPressed: handleMovePolicy,
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

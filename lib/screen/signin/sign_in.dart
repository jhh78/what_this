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

  void _handleMovePolicy() {
    Get.to(
      () => const PolicyScreen(),
      transition: Transition.upToDown,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _buildSignInButtons(),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        "assets/signIn.png",
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildSignInButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100, left: 30, right: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (Platform.isAndroid)
              SignInButton(
                Buttons.GoogleDark,
                onPressed: _handleMovePolicy,
              ),
            if (Platform.isIOS)
              SignInButton(
                Buttons.AppleDark,
                onPressed: _handleMovePolicy,
              ),
          ],
        ),
      ),
    );
  }
}

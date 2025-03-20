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
        fit: BoxFit.cover, // `BoxFit.fill` 대신 `BoxFit.cover`로 자연스러운 비율 유지
      ),
    );
  }

  Widget _buildSignInButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (Platform.isAndroid) _buildGoogleSignInButton(),
            if (Platform.isIOS) _buildAppleSignInButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return SignInButton(
      Buttons.GoogleDark,
      onPressed: _handleMovePolicy,
    );
  }

  Widget _buildAppleSignInButton() {
    return SignInButton(
      Buttons.AppleDark,
      onPressed: _handleMovePolicy,
    );
  }
}

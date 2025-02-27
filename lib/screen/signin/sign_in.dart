import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/screen/home/home.dart';
import 'package:whats_this/service/vender/auth.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final UserProvider userProvider = Get.put(UserProvider());

  Future<void> _handleSignIn() async {
    try {
      if (Platform.isAndroid) {
        await AuthService.signInWithGoogle();
      } else if (Platform.isIOS) {
        await AuthService.signInWithApple();
      }

      await userProvider.createUser();

      Get.offAll(() => HomeScreen(), transition: Transition.fade);
    } catch (error) {
      if (error is FirebaseAuthException && error.code == 'user-disabled') {
        Get.snackbar('Error', 'The user account has been disabled by an administrator.',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white, margin: EdgeInsets.all(10));
      } else {
        log('Error reloading user: $error');
      }
    }
  }

  void _handlePrivacyPolicy(BuildContext context) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.all(8.0),
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Expanded(
                child: WebViewWidget(
                  controller: WebViewController()..loadRequest(Uri.parse(dotenv.env['PRIVACY_POLICY_URL_JP']!)),
                ),
              ),
              TextButton(
                onPressed: () {
                  _handleSignIn();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(200, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  '同意する',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                        onPressed: () => _handlePrivacyPolicy(context),
                      ),
                    if (Platform.isIOS)
                      SignInButton(
                        Buttons.AppleDark,
                        onPressed: () => _handlePrivacyPolicy(context),
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

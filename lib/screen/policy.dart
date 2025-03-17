import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/service/vender/auth.dart';
import 'package:whats_this/widget/atoms/simple_button.dart';

import 'home/home.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  final UserProvider userProvider = Get.put(UserProvider());
  bool isLoading = false;

  Future<void> _handleSignIn() async {
    try {
      setState(() => isLoading = true);

      if (Platform.isAndroid) {
        await AuthService.signInWithGoogle();
      } else if (Platform.isIOS) {
        await AuthService.signInWithApple();
      }

      await userProvider.createUser();
      Get.offAll(() => HomeScreen(), transition: Transition.fade);
    } catch (error) {
      setState(() => isLoading = false);

      if (error is FirebaseAuthException && error.code == 'user-disabled') {
        Get.snackbar(
          'Error',
          'The user account has been disabled by an administrator.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
        );
      } else {
        log('Error reloading user: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: const Text('利用規約'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: WebViewWidget(
                    controller: WebViewController()
                      ..setBackgroundColor(Colors.white)
                      ..enableZoom(true)
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..loadRequest(Uri.parse(dotenv.env['PRIVACY_POLICY_URL_JP']!)),
                  ),
                ),
                SimpleButtonWidget(
                  onClick: _handleSignIn,
                  title: '同意する',
                ),
              ],
            ),
            if (isLoading)
              Container(
                color: Colors.black.withAlpha(200),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

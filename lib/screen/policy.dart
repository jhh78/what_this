import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/service/vender/auth.dart';
import 'package:whats_this/util/styles.dart';

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
      if (Platform.isAndroid) {
        await AuthService.signInWithGoogle();
      } else if (Platform.isIOS) {
        await AuthService.signInWithApple();
      }

      setState(() {
        isLoading = true;
      });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_drop_up_sharp,
            size: ICON_SIZE,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Privacy Policy'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 9,
                  child: WebViewWidget(
                    controller: WebViewController()
                      ..setBackgroundColor(Colors.white)
                      ..enableZoom(true)
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..loadRequest(Uri.parse(dotenv.env['PRIVACY_POLICY_URL_JP']!)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      backgroundColor: Colors.white),
                  onPressed: _handleSignIn,
                  child: Text(
                    'Agree and Continue',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.black87,
                        ),
                  ),
                ),
              ],
            ),
            if (isLoading)
              Container(
                color: Colors.black.withAlpha(100),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

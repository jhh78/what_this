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
        _showErrorSnackbar('Error', 'The user account has been disabled by an administrator.');
      } else {
        log('Error reloading user: $error');
      }
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            Column(
              children: [
                _buildWebView(),
                _buildAgreeButton(),
              ],
            ),
            if (isLoading) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      centerTitle: true,
      title: const Text('利用規約'),
    );
  }

  Widget _buildWebView() {
    return Expanded(
      child: WebViewWidget(
        controller: WebViewController()
          ..setBackgroundColor(Colors.white)
          ..enableZoom(true)
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(dotenv.env['PRIVACY_POLICY_URL_JP']!)),
      ),
    );
  }

  Widget _buildAgreeButton() {
    return SimpleButtonWidget(
      onClick: _handleSignIn,
      title: '同意する',
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withAlpha(200),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

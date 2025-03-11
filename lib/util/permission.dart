import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whats_this/widget/atoms/action_button.dart';

Future<void> checkCameraPermission({required Function acceptFunc}) async {
  final status = await Permission.camera.status;
  if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
    final result = await Permission.camera.request();
    if (!result.isGranted) {
      Get.dialog(
        AlertDialog(
          title: Text(
            'カメラ権限が必要です',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            'プロフィール写真の変更や質問登録を行うために、カメラの権限が必要です。設定からカメラの権限を許可してください。',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            ActionButtonWidget(
                buttonText: '権限設定に移動',
                isUpdated: false,
                onPressed: () async {
                  openAppSettings();
                  Get.back();
                }),
          ],
        ),
      );
      return;
    }
  }
  acceptFunc();
}

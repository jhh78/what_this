import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showConfirmDialog({
  required String title,
  required String middleText,
  required VoidCallback onConfirm,
  Widget? content,
  VoidCallback? onClose,
}) {
  Get.defaultDialog(
    title: title,
    middleText: middleText,
    content: content,
    actions: [
      TextButton(
        onPressed: () {
          if (onClose != null) {
            onClose();
          } else {
            Get.back();
          }
        },
        child: Text('No'),
      ),
      TextButton(
        onPressed: () {
          onConfirm();
        },
        child: Text('Yes'),
      ),
    ],
  );
}

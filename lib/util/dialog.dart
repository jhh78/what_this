import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/widget/atoms/simple_button.dart';

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
      SimpleButtonWidget(
          onClick: () {
            if (onClose != null) {
              onClose();
            }

            Get.back();
          },
          title: 'NO'),
      SimpleButtonWidget(
          onClick: () {
            onConfirm();
            Get.back();
          },
          title: 'Yes'),
    ],
  );
}

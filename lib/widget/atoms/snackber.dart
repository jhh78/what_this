import 'package:flutter/material.dart';
import 'package:get/get.dart';

Text _renderTitleText(String title) {
  return Text(
    title,
    style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
          color: Colors.white, // 다크 테마에 적합한 텍스트 색상
        ),
  );
}

Text _renderMessageText(String content) {
  return Text(
    content,
    style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white70, // 다크 테마에 적합한 텍스트 색상
        ),
  );
}

void successSnackBar({required String title, required String content}) {
  Get.snackbar(
    '',
    '',
    titleText: _renderTitleText(title),
    messageText: _renderMessageText(content),
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(24),
    backgroundColor: Colors.green.shade700, // 다크 테마 성공 색상
  );
}

void errorSnackBar({required String title, required String content}) {
  Get.snackbar(
    '',
    '',
    titleText: _renderTitleText(title),
    messageText: _renderMessageText(content),
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(24),
    backgroundColor: Colors.red.shade800, // 다크 테마 에러 색상
  );
}

void warningSnackBar({required String title, required String content}) {
  Get.snackbar(
    '',
    '',
    titleText: _renderTitleText(title),
    messageText: _renderMessageText(content),
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(24),
    backgroundColor: Colors.orange.shade700, // 다크 테마 경고 색상
  );
}

void infoSnackBar({required String title, required String content}) {
  Get.snackbar(
    '',
    '',
    titleText: _renderTitleText(title),
    messageText: _renderMessageText(content),
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(24),
    backgroundColor: Colors.blue.shade700, // 다크 테마 정보 색상
  );
}

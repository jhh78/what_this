import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActionButtonWidget extends StatelessWidget {
  const ActionButtonWidget({
    super.key,
    this.noticeTitle = '',
    this.noticeContent = '',
    this.showNotice = false,
    required this.buttonText,
    required this.isUpdated,
    required this.onPressed,
  });

  final String noticeTitle;
  final String noticeContent;
  final String buttonText;
  final bool showNotice;
  final bool isUpdated;
  final AsyncCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: _buttonStyle(context),
      onPressed: () async {
        await onPressed();
        if (showNotice) _showSnackbar();
      },
      child: isUpdated
          ? const LinearProgressIndicator()
          : Text(
              buttonText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
    );
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(48), // 버튼 높이 설정
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      side: BorderSide(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  void _showSnackbar() {
    Get.snackbar(
      noticeTitle,
      noticeContent,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}

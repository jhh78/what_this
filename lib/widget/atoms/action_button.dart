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
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(48), // Set the height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        side: BorderSide(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      onPressed: () async {
        await onPressed();

        if (showNotice) {
          Get.snackbar(
            noticeTitle,
            noticeContent,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(16),
          );
        }
      },
      child: isUpdated
          ? LinearProgressIndicator()
          : Text(
              buttonText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
    );
  }
}

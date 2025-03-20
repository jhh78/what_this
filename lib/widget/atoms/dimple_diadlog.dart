import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'simple_button.dart';

class SimpleDialogWidget extends StatelessWidget {
  const SimpleDialogWidget({
    super.key,
    required this.title,
    required this.content,
    this.cancelTitle = 'キャンセル',
    this.cancelFunction,
    required this.okTitle,
    required this.okFunction,
  });

  final String title;
  final String content;
  final String cancelTitle;
  final String okTitle;
  final Function() okFunction;
  final Function()? cancelFunction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(
        content,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SimpleButtonWidget(
                onClick: () {
                  if (cancelFunction != null) {
                    cancelFunction!();
                  }

                  Get.back();
                },
                title: cancelTitle),
            SimpleButtonWidget(onClick: okFunction, title: okTitle),
          ],
        )
      ],
    );
  }
}

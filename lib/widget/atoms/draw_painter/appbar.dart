import 'package:flutter/material.dart';

class DrawPainterAppbawWidget extends StatelessWidget implements PreferredSizeWidget {
  final Function initParameter;
  final Function({required BuildContext context}) saveAndClose;

  const DrawPainterAppbawWidget({
    super.key,
    required this.initParameter,
    required this.saveAndClose,
  });

  TextButton renderTextButton({
    required BuildContext context,
    required VoidCallback callback,
    required String text,
  }) {
    return TextButton(
      onPressed: () => callback(),
      style: TextButton.styleFrom(
        side: const BorderSide(color: Colors.white, width: 1.0), // 외곽선 추가
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0), // 모서리 둥글게 설정
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('画像描画'),
      actions: [
        renderTextButton(
          context: context,
          callback: () => initParameter(),
          text: '初期化',
        ),
        const SizedBox(width: 10),
        renderTextButton(
          context: context,
          callback: () => saveAndClose(context: context),
          text: '反映',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // AppBar의 기본 높이
}

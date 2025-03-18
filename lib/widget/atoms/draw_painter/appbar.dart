import 'package:flutter/material.dart';

class DrawPainterAppbawWidget extends StatelessWidget implements PreferredSizeWidget {
  const DrawPainterAppbawWidget({
    super.key,
    required this.initParameter,
    required this.saveAndClose,
  });

  final VoidCallback initParameter;
  final Function({required BuildContext context}) saveAndClose;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('画像描画'),
      actions: [
        _buildTextButton(
          context: context,
          onPressed: initParameter,
          text: '初期化',
        ),
        const SizedBox(width: 10),
        _buildTextButton(
          context: context,
          onPressed: () => saveAndClose(context: context),
          text: '反映',
        ),
      ],
    );
  }

  Widget _buildTextButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required String text,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        side: const BorderSide(color: Colors.white, width: 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/service/question.dart';
import 'package:whats_this/service/vender/camera.dart';
import 'package:whats_this/util/styles.dart';
import 'package:whats_this/widget/question/draw_image.dart';

class QuestionAddScreen extends StatefulWidget {
  const QuestionAddScreen({super.key});

  @override
  State<QuestionAddScreen> createState() => _QuestionAddScreenState();
}

class _QuestionAddScreenState extends State<QuestionAddScreen> {
  final HomeProvider homeProvider = Get.put(HomeProvider());
  final UserProvider userProvider = Get.put(UserProvider());
  final CameraService cameraService = CameraService();
  final QuestionService questionService = QuestionService();

  final TextEditingController textController = TextEditingController();
  final FocusNode textFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  File _image = File("");
  bool isUpdated = false;

  @override
  void initState() {
    super.initState();
    textFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    textFocusNode.removeListener(_onFocusChange);
    textFocusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (textFocusNode.hasFocus) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _handleRegister() async {
    if (textController.text.isEmpty) {
      Get.snackbar('質問未入力', '質問を入力してください。');
      return;
    }

    setState(() => isUpdated = true);

    await questionService.addQuestion(
      textController: textController,
      cameraService: cameraService,
      image: _image,
    );

    Get.back();
  }

  Future<void> _pickImage() async {
    final File? image = await cameraService.pickImageFromCamera();
    if (image != null) {
      setState(() => _image = image);
    }
  }

  void _clearImage() {
    setState(() => _image = File(""));
  }

  void _handleDrawImage() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: DrawImage(onSaved: (File file) {
            setState(() => _image = file);
          }),
        );
      },
    );
  }

  Widget _buildImageArea() {
    if (_image.path.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: [
        Image.file(
          _image,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          right: 0,
          child: IconButton(
            icon: const Icon(
              Icons.remove_circle_outline_rounded,
              color: Colors.red,
              size: ICON_SIZE,
            ),
            onPressed: _clearImage,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: _handleDrawImage,
          icon: const Icon(Icons.draw, size: ICON_SIZE_BIG),
        ),
        IconButton(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera, size: ICON_SIZE_BIG),
        ),
        IconButton(
          onPressed: _handleRegister,
          icon: const Icon(
            Icons.add_box_rounded,
            size: ICON_SIZE_BIG,
            color: Colors.lightBlueAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildGuidelineText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'ここはみんなが共にする空間です。お互いを尊重し、コミュニティのルールを守って、楽しく健全な交流を作りましょう。思いやりと責任ある行動が、健全なコミュニティを育てます。',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('質問する')),
        body: SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildActionButtons(),
              _buildGuidelineText(context),
              TextField(
                keyboardType: TextInputType.text,
                controller: textController,
                focusNode: textFocusNode,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: '質問を入力してください。',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              _buildImageArea(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/service/question.dart';
import 'package:whats_this/service/vender/camera.dart';
import 'package:whats_this/util/styles.dart';

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
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> handleRegister() async {
    if (textController.value.text.isEmpty) {
      Get.snackbar('質問未入力', '質問を入力してください。');
      return;
    }

    setState(() {
      isUpdated = true;
    });

    await questionService.addQuestion(
      textController: textController,
      cameraService: cameraService,
      image: _image,
    );

    Get.back();
  }

  Future<void> pickImage() async {
    final File? image = await cameraService.pickImageFromCamera();

    if (image == null) {
      return;
    }

    setState(() {
      _image = image;
    });
  }

  void clearImage() {
    setState(() {
      _image = File("");
    });
  }

  Widget renderImageArea() {
    if (_image.path.isEmpty) {
      return SizedBox.shrink();
    }

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
            icon: Icon(
              Icons.remove_circle_outline_rounded,
              color: Colors.red,
              size: ICON_SIZE,
            ),
            onPressed: () {
              clearImage();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('質問する'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              pickImage();
                            },
                            icon: Icon(
                              Icons.camera,
                              size: ICON_SIZE_BIG,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              handleRegister();
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              size: ICON_SIZE_BIG,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white70),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'ここはみんなが共にする空間です。お互いを尊重し、コミュニティのルールを守って、楽しく健全な交流を作りましょう。思いやりと責任ある行動が、健全なコミュニティを育てます。',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.text,
                        controller: textController,
                        focusNode: textFocusNode,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: '質問を入力してください。',
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      renderImageArea(),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

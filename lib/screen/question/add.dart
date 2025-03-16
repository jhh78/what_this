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

  void handleDrawImage() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 외부 클릭으로 닫히지 않도록 설정
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54, // 배경을 반투명하게 설정
      transitionDuration: const Duration(milliseconds: 300), // 애니메이션 지속 시간
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          insetPadding: EdgeInsets.zero, // 다이얼로그의 기본 패딩 제거
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white, // 배경색 설정
            child: DrawImage(onSaved: (File file) {
              setState(() {
                _image = file;
              });
            }),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, -1.0); // 위에서 시작
        const end = Offset(0.0, 0.0); // 화면 중앙에 정착
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
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
        body: SingleChildScrollView(
          controller: scrollController, // ScrollController 연결
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // 키보드 높이만큼 패딩 추가
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      handleDrawImage();
                    },
                    icon: Icon(
                      Icons.draw,
                      size: ICON_SIZE_BIG,
                    ),
                  ),
                  IconButton(
                    onPressed: pickImage,
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
                      Icons.add_box_rounded,
                      size: ICON_SIZE_BIG,
                      color: Colors.lightBlueAccent,
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
            ],
          ),
        ),
      ),
    );
  }
}

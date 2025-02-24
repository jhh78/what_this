import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/provider/question/add.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/service/camera.dart';
import 'package:whats_this/util/styles.dart';

class QuestionAddScreen extends StatelessWidget {
  QuestionAddScreen({super.key});

  final HomeProvider homeProvider = Get.put(HomeProvider());
  final QuestionAddProvider questionAddProvider = Get.put(QuestionAddProvider());
  final UserProvider userProvider = Get.put(UserProvider());
  final CameraService cameraService = CameraService();

  Future<void> handleRegister() async {
    if (questionAddProvider.textController.value.text.isEmpty) {
      Get.snackbar('質問未入力', '質問を入力してください。');
      return;
    }

    await questionAddProvider.addQuestion();
    await userProvider.addPoint();
    homeProvider.init();
  }

  Widget renderImageArea() {
    if (questionAddProvider.image.value.path.isEmpty) {
      return SizedBox.shrink();
    }

    return Stack(
      children: [
        Image.file(
          questionAddProvider.image.value,
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
              questionAddProvider.clearImage();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      questionAddProvider.pickImage();
                    },
                    icon: Icon(
                      Icons.camera,
                      size: ICON_SIZE,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      await Future.delayed(Duration(milliseconds: 1000));

                      handleRegister();
                    },
                    icon: Icon(
                      Icons.create_new_folder_outlined,
                      size: ICON_SIZE,
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
                controller: questionAddProvider.textController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: '質問を入力してください。',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Obx(() => renderImageArea()),
            ],
          ),
        ),
      ),
    );
  }
}

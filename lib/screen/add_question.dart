import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/provider/question_add.dart';
import 'package:whats_this/util/styles.dart';

class AddQuestionScreen extends StatelessWidget {
  AddQuestionScreen({super.key});

  final HomeProvider homeProvider = Get.put(HomeProvider());
  final QuestionAddProvider questionAddProvider = Get.put(QuestionAddProvider());

  Future<void> handleRegister() async {
    if (questionAddProvider.textController.value.text.isEmpty) {
      Get.snackbar('質問未入力', '質問を入力してください。');
      return;
    }

    await questionAddProvider.uploadQuestion();
    Get.snackbar('処理完了', '質問が登録されました。');
    homeProvider.init();
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
                      // questionAddProvider.pickImageFromCamera();
                    },
                    icon: Icon(
                      Icons.camera,
                      size: ICON_SIZE,
                    ),
                  ),
                  IconButton(
                    onPressed: handleRegister,
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
              Obx(
                () => GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                  ),
                  itemCount: questionAddProvider.images.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Image.file(
                          questionAddProvider.images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
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
                              questionAddProvider.images.removeAt(index);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

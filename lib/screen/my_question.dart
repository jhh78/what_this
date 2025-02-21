import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/model/question.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/provider/my_question.dart';
import 'package:whats_this/util/constants.dart';
import 'package:whats_this/widget/atoms/data_not_found.dart';
import 'package:whats_this/widget/contents_card.dart';

class MyQuestionScreen extends StatelessWidget {
  MyQuestionScreen({super.key});
  final HomeProvider homeProvider = Get.put(HomeProvider());
  final MyQuestionProvider myQuestionProvider = Get.put(MyQuestionProvider());

  void handleOnDelete(QuestionModel question) {
    Get.defaultDialog(
      title: '削除',
      middleText: "選択したコンテンツを削除しますか？",
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('キャンセル'),
        ),
        TextButton(
          onPressed: () {
            myQuestionProvider.handleDelete(question);
            Get.back();
          },
          child: Text('削除'),
        ),
      ],
    );
  }

  Widget renderQuestionContents() {
    if (myQuestionProvider.questionList.isEmpty) {
      return DataNotFoundWidget();
    }

    return ListView.builder(
      itemCount: myQuestionProvider.questionList.length,
      itemBuilder: (context, index) {
        if (myQuestionProvider.questionList[index].id == "-1") {
          return Container(
            margin: EdgeInsets.all(10.0),
            child: InkWell(
              onTap: myQuestionProvider.handleNextPage,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Colors.blueAccent.withAlpha(100), width: 2),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text("もっと見る", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black)),
                  ),
                ),
              ),
            ),
          );
        }

        final question = myQuestionProvider.questionList[index];
        return InkWell(
          onTap: () {
            homeProvider.changeScreenIndex(QUESTION_DETAIL);
          },
          child: ContentsCardWidget(
            questionModel: question,
            onDelete: () => handleOnDelete(question),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'マイ質問',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Obx(() => renderQuestionContents()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/model/question.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/provider/question/detail.dart';
import 'package:whats_this/provider/question/my_question.dart';
import 'package:whats_this/util/constants.dart';
import 'package:whats_this/util/dialog.dart';
import 'package:whats_this/widget/atoms/data_not_found.dart';
import 'package:whats_this/widget/question/contents_card.dart';

class MyQuestionScreen extends StatelessWidget {
  MyQuestionScreen({super.key});
  final HomeProvider homeProvider = Get.put(HomeProvider());
  final MyQuestionProvider myQuestionProvider = Get.put(MyQuestionProvider());
  final QuestionDetailProvider questionDetailProvider = Get.put(QuestionDetailProvider());

  void handleOnDelete(QuestionModel question) {
    showConfirmDialog(
        title: '削除',
        middleText: "選択したコンテンツを削除しますか？",
        onConfirm: () {
          myQuestionProvider.handleDelete(question);
          Get.back();
        });
  }

  Widget renderQuestionContents() {
    if (myQuestionProvider.isLoading.value) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

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
            questionDetailProvider.setQuestionModel(question);
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

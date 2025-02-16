import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/model/question.dart';
import 'package:whats_this/provider/form.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/provider/question_list.dart';
import 'package:whats_this/util/constants.dart';
import 'package:whats_this/widget/atoms/reason_form.dart';
import 'package:whats_this/widget/contents_card.dart';

class QuestionListScreen extends StatelessWidget {
  QuestionListScreen({super.key});
  final HomeProvider homeProvider = Get.put(HomeProvider());
  final QuestionListProvider questionListProvider = Get.put(QuestionListProvider());
  final FormProvider formProvider = Get.put(FormProvider());

  void handleOnBlock(QuestionModel question) {
    Get.defaultDialog(
      title: 'ブロック',
      middleText: "選択したコンテンツをブロックしますか？",
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('キャンセル'),
        ),
        TextButton(
          onPressed: () {
            questionListProvider.handleBlock(question);
            Get.back();
          },
          child: Text('ブロック'),
        ),
      ],
    );
  }

  void handleOnReport(QuestionModel question) {
    Get.defaultDialog(
      title: '通報',
      middleText: "通報理由を選択してください。",
      content: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ReasonFormWidget(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('キャンセル'),
        ),
        TextButton(
          onPressed: () {
            if (!(formProvider.formKey.currentState?.validate() ?? false)) {
              return;
            }

            questionListProvider.handleReport(question, formProvider.getData(REPORT_REASON_KIND));
            Get.back();
          },
          child: Text('通報'),
        ),
      ],
    );
  }

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
            questionListProvider.handleDelete(question);
            Get.back();
          },
          child: Text('削除'),
        ),
      ],
    );
  }

  void handleQuestionEdit(QuestionModel question) {
    questionListProvider.handleEdit(question);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() => ListView.builder(
                itemCount: questionListProvider.questionList.length,
                itemBuilder: (context, index) {
                  if (questionListProvider.questionList[index].id == "-1") {
                    return Container(
                      margin: EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: questionListProvider.handleNextPage,
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

                  final question = questionListProvider.questionList[index];
                  return InkWell(
                    onTap: () {
                      homeProvider.changeScreenIndex(QUESTION_DETAIL);
                    },
                    child: ContentsCardWidget(
                      questionModel: question,
                      onBlock: () => handleOnBlock(question),
                      onReport: () => handleOnReport(question),
                      onDelete: () => handleOnDelete(question),
                      onEdit: () => handleQuestionEdit(question),
                    ),
                  );
                },
              )),
        ),
      ],
    );
  }
}

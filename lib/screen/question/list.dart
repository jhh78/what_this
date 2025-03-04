import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/model/question.dart';
import 'package:whats_this/provider/question/detail.dart';
import 'package:whats_this/provider/form.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/provider/question/list.dart';
import 'package:whats_this/util/constants.dart';
import 'package:whats_this/util/dialog.dart';
import 'package:whats_this/widget/atoms/data_not_found.dart';
import 'package:whats_this/widget/atoms/reason_form.dart';
import 'package:whats_this/widget/question/contents_card.dart';

class QuestionListScreen extends StatelessWidget {
  QuestionListScreen({super.key});
  final HomeProvider homeProvider = Get.put(HomeProvider());
  final QuestionListProvider questionListProvider = Get.put(QuestionListProvider());
  final FormProvider formProvider = Get.put(FormProvider());
  final QuestionDetailProvider questionDetailProvider = Get.put(QuestionDetailProvider());

  void handleOnBlock({required QuestionModel question}) {
    showConfirmDialog(
      title: 'ブロック',
      middleText: "選択したコンテンツをブロックしますか？",
      onConfirm: () {
        questionListProvider.handleBlock(question);
        Get.back();
      },
    );
  }

  void handleOnReport({required BuildContext context, required QuestionModel question}) {
    showConfirmDialog(
      title: '通報',
      middleText: "通報理由を選択してください。",
      content: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ReasonFormWidget(),
      ),
      onClose: () {
        FocusScope.of(context).unfocus();
        Get.back();
      },
      onConfirm: () {
        if (!(formProvider.formKey.currentState?.validate() ?? false)) {
          return;
        }

        questionListProvider.handleReport(question, formProvider.getData(REPORT_REASON_KIND));
        Get.back();
      },
    );
  }

  void handleOnDelete({required QuestionModel question}) {
    showConfirmDialog(
      title: '削除',
      middleText: "選択したコンテンツを削除しますか？",
      onConfirm: () {
        questionListProvider.handleDelete(question);
        Get.back();
      },
    );
  }

  Widget renderListContents(BuildContext context) {
    if (questionListProvider.isLoading.value) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (questionListProvider.questionList.isEmpty) {
      return DataNotFoundWidget();
    }

    return Expanded(
      child: ListView.builder(
        itemCount: questionListProvider.questionList.length,
        itemBuilder: (context, index) {
          final question = questionListProvider.questionList[index];
          return InkWell(
            onTap: () {
              questionDetailProvider.setQuestionModel(question);
              homeProvider.changeScreenIndex(QUESTION_DETAIL);
            },
            child: ContentsCardWidget(
              questionModel: question,
              nextPage: () => questionListProvider.handleNextPage(),
              onBlock: () => handleOnBlock(question: question),
              onReport: () => handleOnReport(context: context, question: question),
              onDelete: () => handleOnDelete(question: question),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => renderListContents(context)),
      ],
    );
  }
}

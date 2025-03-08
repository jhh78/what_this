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

  void handleOnBlock({required BuildContext context, required QuestionModel question}) {
    FocusScope.of(context).unfocus(); // 포커스 해제
    showConfirmDialog(
      title: 'ブロック',
      middleText: "選択したコンテンツをブロックしますか？",
      onConfirm: () {
        questionListProvider.handleBlock(question);
        FocusScope.of(context).unfocus(); // 포커스 해제
        Get.back();
      },
      onClose: () {
        FocusScope.of(context).unfocus(); // 포커스 해제
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
        FocusScope.of(context).unfocus(); // 포커스 해제
        Get.back();
      },
      onConfirm: () {
        if (!(formProvider.formKey.currentState?.validate() ?? false)) {
          return;
        }

        questionListProvider.handleReport(question, formProvider.getData(REPORT_REASON_KIND));
        FocusScope.of(context).unfocus(); // 포커스 해제
        Get.back();
      },
    );
  }

  void handleOnDelete({required BuildContext context, required QuestionModel question}) {
    showConfirmDialog(
      title: '削除',
      middleText: "選択したコンテンツを削除しますか？",
      onConfirm: () {
        questionListProvider.handleDelete(question);
        FocusScope.of(context).unfocus(); // 포커스 해제
        Get.back();
      },
      onClose: () {
        FocusScope.of(context).unfocus(); // 포커스 해제
        Get.back();
      },
    );
  }

  Widget renderListContents(BuildContext context) {
    if (questionListProvider.isLoading.value) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (questionListProvider.questionList.isEmpty) {
      return DataNotFoundWidget();
    }

    return ListView.builder(
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
            onBlock: () => handleOnBlock(context: context, question: question),
            onReport: () => handleOnReport(context: context, question: question),
            onDelete: () => handleOnDelete(context: context, question: question),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(() => renderListContents(context)),
      ),
    );
  }
}

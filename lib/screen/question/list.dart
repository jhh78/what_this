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

  void _handleBlock(BuildContext context, QuestionModel question) {
    _showConfirmDialog(
      context: context,
      title: 'ブロック',
      middleText: '選択したコンテンツをブロックしますか？',
      onConfirm: () {
        questionListProvider.handleBlock(question);
        Get.back();
      },
    );
  }

  void _handleReport(BuildContext context, QuestionModel question) {
    _showConfirmDialog(
      context: context,
      title: '通報',
      middleText: '通報理由を選択してください。',
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ReasonFormWidget(),
      ),
      onConfirm: () {
        if (formProvider.formKey.currentState?.validate() ?? false) {
          questionListProvider.handleReport(
            question,
            formProvider.getData(REPORT_REASON_KIND),
          );
          Get.back();
        }
      },
    );
  }

  void _handleDelete(BuildContext context, QuestionModel question) {
    _showConfirmDialog(
      context: context,
      title: '削除',
      middleText: '選択したコンテンツを削除しますか？',
      onConfirm: () {
        questionListProvider.handleDelete(question);
        Get.back();
      },
    );
  }

  void _showConfirmDialog({
    required BuildContext context,
    required String title,
    required String middleText,
    Widget? content,
    required VoidCallback onConfirm,
  }) {
    FocusScope.of(context).unfocus();
    showConfirmDialog(
      title: title,
      middleText: middleText,
      content: content,
      onConfirm: onConfirm,
      onClose: () => Get.back(),
    );
  }

  Widget _buildListContents(BuildContext context) {
    if (questionListProvider.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (questionListProvider.questionList.isEmpty) {
      return const DataNotFoundWidget();
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
            nextPage: questionListProvider.handleNextPage,
            onBlock: () => _handleBlock(context, question),
            onReport: () => _handleReport(context, question),
            onDelete: () => _handleDelete(context, question),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(() => _buildListContents(context)),
      ),
    );
  }
}

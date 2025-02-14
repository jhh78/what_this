import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/provider/question_list.dart';
import 'package:whats_this/util/constants.dart';
import 'package:whats_this/widget/contents_card.dart';

class QuestionListScreen extends StatelessWidget {
  QuestionListScreen({super.key});
  final HomeProvider homeProvider = Get.put(HomeProvider());
  final QuestionListProvider questionListProvider = Get.put(QuestionListProvider());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
          itemCount: questionListProvider.questionList.length,
          itemBuilder: (context, index) {
            final question = questionListProvider.questionList[index];
            return InkWell(
              onTap: () {
                homeProvider.changeScreenIndex(QUESTION_DETAIL);
              },
              child: ContentsCardWidget(
                questionModel: question,
                onBlock: () => questionListProvider.handleBlock(question),
                onReport: () => questionListProvider.handleReport(question),
                onDelete: () => questionListProvider.handleDelete(question),
                onEdit: () => questionListProvider.handleEdit(question),
              ),
            );
          },
        ));
  }
}

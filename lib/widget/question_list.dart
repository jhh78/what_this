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
                onBlock: () {
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
                },
                onReport: () => questionListProvider.handleReport(question),
                onDelete: () {
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
                },
                onEdit: () => questionListProvider.handleEdit(question),
              ),
            );
          },
        ));
  }
}

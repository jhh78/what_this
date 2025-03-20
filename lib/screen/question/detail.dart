import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/model/comment.dart';
import 'package:whats_this/provider/form.dart';
import 'package:whats_this/provider/question/detail.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/util/constants.dart';
import 'package:whats_this/util/dialog.dart';
import 'package:whats_this/util/styles.dart';
import 'package:whats_this/widget/atoms/data_not_found.dart';
import 'package:whats_this/widget/atoms/reason_form.dart';
import 'package:whats_this/widget/atoms/simple_button.dart';
import 'package:whats_this/widget/question/comment_card.dart';
import 'package:whats_this/widget/question/contents_card.dart';

class QuestionDetailScreen extends StatelessWidget {
  QuestionDetailScreen({super.key});

  final HomeProvider homeProvider = Get.put(HomeProvider());
  final QuestionDetailProvider questionDetailProvider = Get.put(QuestionDetailProvider());
  final FormProvider formProvider = Get.put(FormProvider());

  void _handleDelete(CommentModel comment) {
    showConfirmDialog(
      title: "確認",
      middleText: "このコメントを削除しますか？",
      onConfirm: () {
        questionDetailProvider.deleteItem(comment.id);
        Get.back();
      },
    );
  }

  void _handleBlock(CommentModel comment) {
    showConfirmDialog(
      title: "確認",
      middleText: "このコメントをブロックしますか？",
      onConfirm: () {
        questionDetailProvider.blockItem(comment.id);
        Get.back();
      },
    );
  }

  void _handleReport(CommentModel comment) {
    showConfirmDialog(
      title: '通報',
      middleText: "通報理由を選択してください。",
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ReasonFormWidget(),
      ),
      onConfirm: () {
        if (!(formProvider.formKey.currentState?.validate() ?? false)) return;
        questionDetailProvider.handleReport(comment, formProvider.getData(REPORT_REASON_KIND));
        Get.back();
      },
    );
  }

  Widget _buildCommentList() {
    if (questionDetailProvider.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (questionDetailProvider.commentList.isEmpty) {
      return const DataNotFoundWidget();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: questionDetailProvider.commentList.length,
      itemBuilder: (context, index) {
        final comment = questionDetailProvider.commentList[index];
        return CommentCardWidget(
          commentModel: comment,
          onNextPage: questionDetailProvider.handleNextPage,
          onDelete: () => _handleDelete(comment),
          onBlock: () => _handleBlock(comment),
          onReport: () => _handleReport(comment),
        );
      },
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("コメント入力"),
          const SizedBox(height: 12),
          TextField(
            maxLines: 3,
            maxLength: MAX_CONTENTS_LENGTH,
            controller: questionDetailProvider.commentController,
            decoration: const InputDecoration(
              hintText: "コメントを入力してください",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SimpleButtonWidget(onClick: () => Get.back(), title: "キャンセル"),
              SimpleButtonWidget(onClick: questionDetailProvider.addComment, title: "送信")
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("質問詳細"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final entryPoint = homeProvider.entryPoint;
            if (entryPoint == QUESTION_LIST) {
              homeProvider.changeScreenIndex(QUESTION_LIST);
            } else if (entryPoint == MY_QUESTION) {
              homeProvider.changeScreenIndex(MY_QUESTION);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => ContentsCardWidget(
                  questionModel: questionDetailProvider.questionModel.value,
                )),
            Divider(thickness: 1, color: Colors.grey.shade300),
            Obx(() => _buildCommentList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.blue.shade400,
        shape: const CircleBorder(
          side: BorderSide(color: Colors.white, width: 3),
        ),
        onPressed: () {
          questionDetailProvider.commentController.clear();
          Get.bottomSheet(_buildBottomSheet());
        },
        child: const Icon(Icons.message_outlined, size: ICON_SIZE, color: Colors.white),
      ),
    );
  }
}

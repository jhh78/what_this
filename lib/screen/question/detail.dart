import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/question/detail.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/util/constants.dart';
import 'package:whats_this/util/styles.dart';
import 'package:whats_this/widget/atoms/data_not_found.dart';
import 'package:whats_this/widget/question/comment_card.dart';
import 'package:whats_this/widget/question/contents_card.dart';

class QuestionDetailScreen extends StatelessWidget {
  QuestionDetailScreen({super.key});

  final HomeProvider homeProvider = Get.put(HomeProvider());
  final QuestionDetailProvider commentListProvider = Get.put(QuestionDetailProvider());

  Widget renderCommentList() {
    if (commentListProvider.isLoading.value) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (commentListProvider.commentList.isEmpty) {
      return DataNotFoundWidget();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: commentListProvider.commentList.length,
      itemBuilder: (context, index) {
        final comment = commentListProvider.commentList[index];
        return CommentCardWidget(
          commentModel: comment,
          onDelete: () {
            commentListProvider.deleteItem(comment.id);
          },
          onBlock: () {
            commentListProvider.blockItem(comment.id);
          },
          onReport: () {
            commentListProvider.reportItem(comment.id);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            homeProvider.changeScreenIndex(QUESTION_LIST);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => ContentsCardWidget(questionModel: commentListProvider.questionModel.value),
            ),
            Obx(() => renderCommentList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.blue.shade400,
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.white,
            width: 3,
          ),
        ),
        onPressed: () {
          commentListProvider.commentController.clear();
          Get.bottomSheet(
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "コメント入力",
                  ),
                  SizedBox(height: 12),
                  TextField(
                    maxLines: 3,
                    maxLength: MAX_CONTENTS_LENGTH,
                    controller: commentListProvider.commentController,
                    decoration: InputDecoration(
                      hintText: "コメントを入力してください",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("キャンセル"),
                      ),
                      TextButton(
                        onPressed: () {
                          commentListProvider.addComment();
                          Get.back();
                        },
                        child: Text("送信"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        child: Icon(
          Icons.message_outlined,
          size: ICON_SIZE,
          color: Colors.white,
        ),
      ),
    );
  }
}

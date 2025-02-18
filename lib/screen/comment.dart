import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/comment_list.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/util/constants.dart';
import 'package:whats_this/widget/comment_card.dart';
import 'package:whats_this/widget/contents_card.dart';

class CommentScreen extends StatelessWidget {
  CommentScreen({super.key});

  final HomeProvider homeProvider = Get.put(HomeProvider());
  final CommentListProvider commentListProvider = Get.put(CommentListProvider());

  @override
  Widget build(BuildContext context) {
    if (commentListProvider.questionModel.value == null) {
      return SizedBox.shrink();
    }

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
            ContentsCardWidget(questionModel: commentListProvider.questionModel.value!),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return CommentCardWidget();
              },
            ),
          ],
        ),
      ),
    );
  }
}

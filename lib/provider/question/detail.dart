import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/comment.dart';
import 'package:whats_this/model/question.dart';
import 'package:whats_this/provider/user.dart';

class QuestionDetailProvider extends GetxService {
  RxList<CommentModel> commentList = <CommentModel>[].obs;
  Rx<QuestionModel> questionModel = QuestionModel.emptyMode().obs;

  RxBool isLoading = false.obs;
  int currentPage = 1;
  final UserProvider userProvider = Get.put(UserProvider());
  final TextEditingController commentController = TextEditingController();
  final String tableName = 'comment';

  void init() {
    commentList.clear();
    currentPage = 1;
  }

  void setQuestionModel(QuestionModel questionModel) {
    this.questionModel.value = questionModel;
  }

  void fetchCommentData() async {
    try {
      isLoading.value = true;
      final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);

      final resultList = await pb.collection('comment').getList(
            page: currentPage,
            perPage: 20,
            expand: "question,user",
            filter: 'question="${questionModel.value.id}"',
          );

      commentList.addAll(resultList.items.map((e) => CommentModel.fromRecordModel(e)).toList());

      log(resultList.toString());
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addComment() async {
    try {
      final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);

      final body = <String, dynamic>{
        "question": questionModel.value.id,
        "user": userProvider.user.value.id,
        "comment": "test",
      };

      await pb.collection(tableName).create(body: body);
      commentController.clear();
    } catch (e, stack) {
      log(stack.toString());
    }
  }

  Future<void> blockItem(String commentID) async {}

  Future<void> deleteItem(String commentID) async {}

  Future<void> reportItem(String commentID) async {}
}

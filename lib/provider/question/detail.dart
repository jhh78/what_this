import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/comment.dart';
import 'package:whats_this/model/question.dart';
import 'package:whats_this/model/system.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/util/constants.dart';

class QuestionDetailProvider extends GetxService {
  RxList<CommentModel> commentList = <CommentModel>[].obs;
  Rx<QuestionModel> questionModel = QuestionModel.emptyModel().obs;

  RxBool isLoading = false.obs;
  int currentPage = 1;
  final UserProvider userProvider = Get.put(UserProvider());
  final TextEditingController commentController = TextEditingController();
  final String tableName = 'comment';

  Future<void> init() async {
    commentList.clear();
    currentPage = 1;
  }

  Future<void> setQuestionModel(QuestionModel questionModel) async {
    this.questionModel.value = questionModel;
    init();
    fetchCommentData();
  }

  void fetchCommentData() async {
    try {
      final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);

      // 제외할 ID 목록
      final Box box = await Hive.openBox(SYSTEM_BOX);
      final SystemConfigModel config = box.get(SYSTEM_CONFIG);

      // 필터 조건 생성
      String filterCondition = config.blockList.isNotEmpty ? config.blockList.map((id) => 'id != "$id"').join(' && ') : '';

      final response = await pb.collection('comment').getList(
            page: currentPage,
            perPage: PAGE_PER_COUNT,
            sort: '-created',
            expand: "question,user",
            filter: 'question="${questionModel.value.id}" && $filterCondition',
          );

      commentList.addAll(response.items.map((e) => CommentModel.fromRecordModel(e)).toList());
      final ids = commentList.map((e) => e.id).toSet();
      commentList.retainWhere((x) => ids.remove(x.id));

      if (response.totalItems > currentPage * PAGE_PER_COUNT) {
        commentList.add(CommentModel.emptyModel());
      }
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    }
  }

  handleNextPage() {
    currentPage++;
    commentList.removeWhere((element) => element.id == QuestionModel.emptyModel().id);
    fetchCommentData();
  }

  Future<void> addComment() async {
    try {
      final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);

      final body = <String, dynamic>{
        "question": questionModel.value.id,
        "user": userProvider.user.value.id,
        "comment": commentController.text,
      };

      await pb.collection(tableName).create(body: body);
      init();
      fetchCommentData();
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    }
  }

  Future<void> blockItem(String commentID) async {
    try {
      Box box = await Hive.openBox(SYSTEM_BOX);
      SystemConfigModel config = box.get(SYSTEM_CONFIG);
      config.blockList.add(commentID);
      box.put(SYSTEM_CONFIG, config);

      commentList.removeWhere((element) => element.id == commentID);
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    }
  }

  Future<void> thumbUpItem({required CommentModel model}) async {
    try {
      final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);
      final body = <String, dynamic>{
        "thumb_up": model.thumb_up + 1,
      };

      await pb.collection('comment').update(model.id, body: body);

      commentList.value = commentList.map((e) {
        if (e.id == model.id) {
          e.thumb_up++;
        }
        return e;
      }).toList();
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    }
  }

  Future<void> thumbDownItem({required CommentModel model}) async {
    log('thumbDownItem');
    try {
      final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);
      final body = <String, dynamic>{
        "thumb_down": model.thumb_down + 1,
      };

      await pb.collection('comment').update(model.id, body: body);

      commentList.value = commentList.map((e) {
        if (e.id == model.id) {
          e.thumb_down++;
        }
        return e;
      }).toList();
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    }
  }

  Future<void> deleteItem(String commentID) async {
    try {
      final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);

      await pb.collection(tableName).delete(commentID);
      commentList.removeWhere((element) => element.id == commentID);
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    }
  }

  Future<void> handleReport(CommentModel model, String value) async {
    try {
      final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);
      await pb.collection('report').create(body: {
        'commentID': model.id,
        'reason': value,
      });

      commentList.removeWhere((element) => element.id == model.id);
      _addBlockList(model);
      commentList.removeWhere((element) => element.id == model.id);
    } catch (e, stack) {
      log(stack.toString());
      log(e.toString());
    }
  }

  _addBlockList(CommentModel model) async {
    final box = await Hive.openBox(SYSTEM_BOX);
    final SystemConfigModel config = box.get(SYSTEM_CONFIG);
    config.blockList.add(model.id);
    box.put(SYSTEM_CONFIG, config);
  }
}

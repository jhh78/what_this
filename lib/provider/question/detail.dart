import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/comment.dart';
import 'package:whats_this/model/question.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/service/vender/hive.dart';
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
    isLoading.value = true;
    this.questionModel.value = questionModel;
    init();
    await fetchCommentData();
    isLoading.value = false;
  }

  Future<void> fetchCommentData() async {
    final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);

    // 제외할 ID 목록
    final String? blockList = HiveService.getBoxValue(BLOCK_LIST_COMMENT);
    final List<dynamic> parseBlockList = blockList != null ? jsonDecode(blockList) : [];

    // 필터 조건 생성
    String filterCondition = parseBlockList.isNotEmpty ? parseBlockList.map((id) => 'id != "$id"').join(' && ') : '';

    final response = await pb.collection('comment').getList(
          page: currentPage,
          perPage: PAGE_PER_COUNT,
          sort: 'created',
          expand: "question,user",
          filter: 'question="${questionModel.value.id}" ${filterCondition.isNotEmpty ? '&& $filterCondition' : ''}',
        );

    commentList.addAll(response.items.map((e) => CommentModel.fromRecordModel(e)).toList());
    final ids = commentList.map((e) => e.id).toSet();
    commentList.retainWhere((x) => ids.remove(x.id));

    if (response.totalItems > currentPage * PAGE_PER_COUNT) {
      commentList.add(CommentModel.emptyModel());
    }
  }

  handleNextPage() {
    currentPage++;
    commentList.removeWhere((element) => element.id == QuestionModel.emptyModel().id);
    fetchCommentData();
  }

  Future<void> addComment() async {
    final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);

    final body = <String, dynamic>{
      "question": questionModel.value.id,
      "user": userProvider.user.value.id,
      "comment": commentController.text,
    };

    final response = await pb.collection(tableName).create(body: body, expand: "user");
    commentList.add(CommentModel.fromRecordModel(response));
  }

  Future<void> blockItem(String commentID) async {
    final String? blockList = HiveService.getBoxValue(BLOCK_LIST_COMMENT);
    final List<dynamic> parseBlockList = blockList != null ? jsonDecode(blockList) : [];
    parseBlockList.add(commentID);
    HiveService.putBoxValue(BLOCK_LIST_QUESTION, jsonEncode(parseBlockList));

    commentList.removeWhere((element) => element.id == commentID);
  }

  Future<void> thumbUpItem({required CommentModel model}) async {
    final thumbUp = HiveService.getBoxValue(THUMB_UP_COMMENT);
    final List<dynamic> parseThumbUp = thumbUp != null ? jsonDecode(thumbUp) : [];

    if (parseThumbUp.contains(model.id)) {
      return;
    }

    parseThumbUp.add(model.id);
    HiveService.putBoxValue(THUMB_UP_COMMENT, jsonEncode(parseThumbUp));

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
  }

  Future<void> thumbDownItem({required CommentModel model}) async {
    final thumbDown = HiveService.getBoxValue(THUMB_DOWN_COMMENT);
    final List<dynamic> parseThumbDown = thumbDown != null ? jsonDecode(thumbDown) : [];

    if (parseThumbDown.contains(model.id)) {
      return;
    }

    parseThumbDown.add(model.id);
    HiveService.putBoxValue(THUMB_DOWN_COMMENT, jsonEncode(parseThumbDown));

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
  }

  Future<void> deleteItem(String commentID) async {
    final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);

    await pb.collection(tableName).delete(commentID);
    commentList.removeWhere((element) => element.id == commentID);
  }

  Future<void> handleReport(CommentModel model, String value) async {
    final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);
    await pb.collection('report').create(body: {
      'commentID': model.id,
      'reason': value,
    });

    commentList.removeWhere((element) => element.id == model.id);
    _addBlockList(model);
    commentList.removeWhere((element) => element.id == model.id);
  }

  _addBlockList(CommentModel model) async {
    final String? blockList = HiveService.getBoxValue(BLOCK_LIST_COMMENT);
    final List<dynamic> parseBlockList = blockList != null ? jsonDecode(blockList) : [];
    parseBlockList.add(model.id);
    HiveService.putBoxValue(BLOCK_LIST_QUESTION, jsonEncode(parseBlockList));
  }
}

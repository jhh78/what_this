import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/question.dart';
import 'package:whats_this/model/system.dart';
import 'package:whats_this/util/constants.dart';

class MyQuestionProvider extends GetxService {
  int currentPage = 1;
  final pagePerCount = 10;
  PocketBase pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);
  String questionTable = 'questions';

  RxList<QuestionModel> questionList = <QuestionModel>[].obs;
  RxBool isLoading = false.obs;

  fetchInitQuestionList() {
    currentPage = 1;
    questionList.clear();
    fetchQuestionMadel();
  }

  fetchQuestionMadel() async {
    try {
      isLoading.value = true;
      final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);
      final Box box = await Hive.openBox(SYSTEM_BOX);
      final SystemConfigModel config = box.get(SYSTEM_CONFIG);

      // 필터 조건 생성
      final response = await pb.collection(questionTable).getList(
            page: currentPage,
            perPage: 10,
            expand: 'user',
            sort: '-created',
            filter: 'user = "${config.userId}"',
          );

      questionList.addAll(response.items.map((e) => QuestionModel.fromRecordModel(e)).toList());
    } catch (e, stackTrace) {
      log(stackTrace.toString());
    } finally {
      isLoading.value = false;
    }
  }

  handleNextPage() {
    currentPage++;
    fetchQuestionMadel();
  }

  handleDelete(QuestionModel model) async {
    try {
      await pb.collection(questionTable).delete(model.id);
    } catch (e) {
      log(e.toString());
    }
  }

  handleEdit(QuestionModel model) async {
    try {
      await pb.collection(questionTable).update(model.id, body: {'contents': '수정된 내용'});
    } catch (e) {
      log(e.toString());
    }
  }
}

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/question.dart';

class MyQuestionProvider extends GetxService {
  int currentPage = 1;
  final pagePerCount = 10;
  PocketBase pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);
  String questionTable = 'questions';

  RxList<QuestionModel> questionList = <QuestionModel>[].obs;

  fetchInitQuestionList() {
    log('MyQuestionProvider fetchInitQuestionList');
    currentPage = 1;
    questionList.clear();
    fetchQuestionMadel();
  }

  fetchQuestionMadel() async {
    try {
      final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);
      final User? user = FirebaseAuth.instance.currentUser;

      // 필터 조건 생성
      final response = await pb.collection(questionTable).getList(
            page: currentPage,
            perPage: 10,
            sort: '-created',
            filter: 'key = "${user!.uid}"',
          );

      questionList.addAll(response.items.map((e) => QuestionModel.fromRecordModel(e)).toList());
    } catch (e) {
      log(e.toString());
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

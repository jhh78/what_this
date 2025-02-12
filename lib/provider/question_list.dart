import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/question.dart';

class QuestionListProvider extends GetxService {
  int currentPage = 1;
  String questionTable = 'questions';
  RxList<QuestionModel> questionList = <QuestionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    log('\t\t\t\t\tQuestionListProvider onInit.');
    currentPage = 1;
    questionList.clear();
    fetchQuestionMadel();
  }

  fetchQuestionMadel() async {
    try {
      final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);

      final response = await pb.collection(questionTable).getList(
            page: currentPage,
            perPage: 30,
            sort: '-created',
            // filter: 'created >= "2022-01-01 00:00:00" && someField1 != someField2',
          );

      questionList.addAll(response.items.map((e) => QuestionModel.fromRecordModel(e)).toList());
    } catch (e) {
      log(e.toString());
    }
  }
}

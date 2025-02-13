import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/question.dart';

class QuestionListProvider extends GetxService {
  int currentPage = 1;
  PocketBase pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);
  String questionTable = 'questions';

  RxList<QuestionModel> questionList = <QuestionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    log('\t\t\t\t\tQuestionListProvider onInit.');
    currentPage = 1;
    questionList.clear();
    fetchQuestionMadel();

    pb.collection(questionTable).subscribe(
      '*',
      (e) {
        log("\t\t\t\t\t${e.action}");
        if (e.action == 'create') {
          questionList.insert(0, QuestionModel.fromRecordModel(e.record!));
        } else if (e.action == 'update') {
          final index = questionList.indexWhere((element) => element.id == e.record?.id);
          if (index != -1) {
            questionList[index] = QuestionModel.fromRecordModel(e.record!);
          }
        } else if (e.action == 'delete') {
          questionList.removeWhere((element) => element.id == e.record?.id);
        }
        log("\t\t\t\t\t${e.record.toString()}");
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    log('\t\t\t\t\tQuestionListProvider onClose.');
    pb.collection('questions').unsubscribe('*');
  }

  fetchInitQuestionList() {
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

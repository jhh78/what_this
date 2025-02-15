import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/question.dart';
import 'package:whats_this/model/system.dart';
import 'package:whats_this/util/constants.dart';

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

      // 제외할 ID 목록
      final Box box = await Hive.openBox(SYSTEM_BOX);
      final SystemConfigModel config = box.get(SYSTEM_CONFIG);

      // 필터 조건 생성
      String filterCondition = config.blockList.map((id) => 'id != "$id"').join(' && ');

      final response =
          await pb.collection(questionTable).getList(page: currentPage, perPage: 30, sort: '-created', filter: filterCondition);

      questionList.addAll(response.items.map((e) => QuestionModel.fromRecordModel(e)).toList());
    } catch (e) {
      log(e.toString());
    }
  }

  handleDelete(QuestionModel model) async {
    try {
      await pb.collection(questionTable).delete(model.id);
    } catch (e) {
      log(e.toString());
    }
  }

  handleBlock(QuestionModel model) async {
    log('handleBlock');
    try {
      _addBlockList(model);
      questionList.removeWhere((element) => element.id == model.id);
    } catch (e) {
      log(e.toString());
    }
  }

  handleReport(QuestionModel model, String value) async {
    try {
      await pb.collection('report').create(body: {
        'questionID': model.id,
        'reason': value,
      });

      questionList.removeWhere((element) => element.id == model.id);
      _addBlockList(model);
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

  _addBlockList(QuestionModel model) async {
    final box = await Hive.openBox(SYSTEM_BOX);
    final SystemConfigModel config = box.get(SYSTEM_CONFIG);
    config.blockList.add(model.id);
    box.put(SYSTEM_CONFIG, config);
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/question.dart';
import 'package:whats_this/service/vender/hive.dart';
import 'package:whats_this/util/constants.dart';

class QuestionListProvider extends GetxService {
  int currentPage = 1;
  PocketBase pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);
  String questionTable = 'questions';

  RxList<QuestionModel> questionList = <QuestionModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    pb.collection(questionTable).subscribe(
      '*',
      (e) {
        fetchInitQuestionList();
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    pb.collection('questions').unsubscribe('*');
  }

  fetchInitQuestionList() async {
    isLoading.value = true;
    currentPage = 1;
    questionList.clear();
    await fetchQuestionMadel();
    isLoading.value = false;
  }

  fetchQuestionMadel() async {
    final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);

    // 필터 조건 생성
    final String? blockList = HiveService.getBoxValue(BLOCK_LIST_QUESTION);
    final List<dynamic> parseBlockList = blockList != null ? jsonDecode(blockList) : [];

    String filterCondition = parseBlockList.isNotEmpty ? parseBlockList.map((id) => 'id != "$id"').join(' && ') : '';

    final response = await pb.collection(questionTable).getList(
          page: currentPage,
          perPage: PAGE_PER_COUNT,
          expand: 'user',
          sort: '-created',
          filter: filterCondition,
        );

    questionList.addAll(response.items.map((e) => QuestionModel.fromRecordModel(e)).toList());
    final ids = questionList.map((e) => e.id).toSet();
    questionList.retainWhere((x) => ids.remove(x.id));

    if (response.totalItems > currentPage * PAGE_PER_COUNT) {
      questionList.add(QuestionModel.emptyModel());
    }
  }

  handleNextPage() {
    currentPage++;
    questionList.removeWhere((element) => element.id == QuestionModel.emptyModel().id);
    fetchQuestionMadel();
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

  _addBlockList(QuestionModel model) async {
    final String? blockList = HiveService.getBoxValue(BLOCK_LIST_QUESTION);
    final List<dynamic> parseBlockList = blockList != null ? jsonDecode(blockList) : [];
    parseBlockList.add(model.id);
    HiveService.putBoxValue(BLOCK_LIST_QUESTION, jsonEncode(parseBlockList));
  }
}

import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/question.dart';
import 'package:whats_this/model/system.dart';
import 'package:whats_this/provider/focus_manager.dart';
import 'package:whats_this/util/constants.dart';

class QuestionListProvider extends GetxService {
  int currentPage = 1;
  final pagePerCount = 10;
  PocketBase pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);
  String questionTable = 'questions';

  RxList<QuestionModel> questionList = <QuestionModel>[].obs;
  RxBool isLoading = false.obs;
  final FocusManagerProvider focusManagerProvider = Get.put(FocusManagerProvider());

  @override
  void onInit() {
    super.onInit();

    focusManagerProvider.questionListFocusNode.addListener(() {
      if (focusManagerProvider.questionListFocusNode.hasFocus) {
        log("?????????????????????????????????????????? > questionListFocusNode");
        fetchInitQuestionList();
      }
    });

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

  fetchInitQuestionList() {
    currentPage = 1;
    questionList.clear();
    fetchQuestionMadel();
  }

  fetchQuestionMadel() async {
    try {
      isLoading.value = true;
      final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);

      // 제외할 ID 목록
      final Box box = await Hive.openBox(SYSTEM_BOX);
      final SystemConfigModel config = box.get(SYSTEM_CONFIG);

      // 필터 조건 생성
      String filterCondition = config.blockList.isNotEmpty ? config.blockList.map((id) => 'id != "$id"').join(' && ') : '';

      final response = await pb.collection(questionTable).getList(
            page: currentPage,
            perPage: 10,
            expand: 'user',
            sort: '-created',
            filter: filterCondition,
          );

      questionList.addAll(response.items.map((e) => QuestionModel.fromRecordModel(e)).toList());
      final ids = questionList.map((e) => e.id).toSet();
      questionList.retainWhere((x) => ids.remove(x.id));

      if (response.totalItems > currentPage * pagePerCount) {
        questionList.add(QuestionModel.emptyMode());
      }
    } catch (e, stackTrace) {
      log("fetchQuestionMadel error: $stackTrace");
    } finally {
      isLoading.value = false;
    }
  }

  handleNextPage() {
    currentPage++;
    questionList.removeAt(questionList.indexWhere((element) => element.id == QuestionModel.emptyMode().id));
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
    final box = await Hive.openBox(SYSTEM_BOX);
    final SystemConfigModel config = box.get(SYSTEM_CONFIG);
    config.blockList.add(model.id);
    box.put(SYSTEM_CONFIG, config);
  }
}

import 'package:get/get.dart';
import 'package:whats_this/provider/my_question.dart';
import 'package:whats_this/provider/question_add.dart';
import 'package:whats_this/provider/question_list.dart';
import 'package:whats_this/util/constants.dart';

class HomeProvider extends GetxService {
  final RxInt currentIndex = 0.obs;
  final RxInt menuIndex = 0.obs;

  final QuestionListProvider questionListProvider = Get.put(QuestionListProvider());
  final MyQuestionProvider myQuestionProvider = Get.put(MyQuestionProvider());
  final QuestionAddProvider questionAddProvider = Get.put(QuestionAddProvider());

  void init() {
    currentIndex.value = 0;
    menuIndex.value = 0;
  }

  void changeScreenIndex(String screen) {
    if (screen == QUESTION_LIST) {
      currentIndex.value = 0;
      menuIndex.value = 0;
      questionListProvider.fetchInitQuestionList();
    } else if (screen == MY_QUESTION) {
      currentIndex.value = 2;
      menuIndex.value = 1;
      myQuestionProvider.fetchInitQuestionList();
    } else if (screen == QUESTION_DETAIL) {
      currentIndex.value = 1;
    } else if (screen == ADD_QUESTION) {
      currentIndex.value = 3;
      menuIndex.value = 2;
      questionAddProvider.init();
    }
  }
}

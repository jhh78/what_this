import 'package:get/get.dart';
import 'package:whats_this/provider/my_question.dart';
import 'package:whats_this/provider/question_add.dart';
import 'package:whats_this/provider/question_list.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/util/constants.dart';

class HomeProvider extends GetxService {
  final RxInt currentIndex = 0.obs;
  final RxInt menuIndex = 0.obs;

  final QuestionListProvider questionListProvider = Get.put(QuestionListProvider());
  final MyQuestionProvider myQuestionProvider = Get.put(MyQuestionProvider());
  final QuestionAddProvider questionAddProvider = Get.put(QuestionAddProvider());
  final UserProvider userProvider = Get.put(UserProvider());

  void init() {
    currentIndex.value = 0;
    menuIndex.value = 0;
  }

  void changeScreenIndex(String screen) {
    if (screen == USER_INFO) {
      currentIndex.value = 0;
      menuIndex.value = 0;
      userProvider.fetchUserData();
    } else if (screen == QUESTION_LIST) {
      currentIndex.value = 1;
      menuIndex.value = 1;
      questionListProvider.fetchInitQuestionList();
    } else if (screen == MY_QUESTION) {
      currentIndex.value = 3;
      menuIndex.value = 2;
      myQuestionProvider.fetchInitQuestionList();
    } else if (screen == QUESTION_DETAIL) {
      currentIndex.value = 2;
    } else if (screen == ADD_QUESTION) {
      currentIndex.value = 4;
      menuIndex.value = 3;
      questionAddProvider.init();
    }
  }
}

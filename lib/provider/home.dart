import 'package:get/get.dart';
import 'package:whats_this/provider/question/detail.dart';
import 'package:whats_this/provider/question/my_question.dart';
import 'package:whats_this/provider/question/list.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/util/constants.dart';

class HomeProvider extends GetxService {
  final RxInt currentIndex = 0.obs;
  final RxInt menuIndex = 0.obs;
  String entryPoint = '';

  final QuestionListProvider questionListProvider = Get.put(QuestionListProvider());
  final MyQuestionProvider myQuestionProvider = Get.put(MyQuestionProvider());
  final UserProvider userProvider = Get.put(UserProvider());
  final QuestionDetailProvider questionDetailProvider = Get.put(QuestionDetailProvider());

  void init() {
    currentIndex.value = 1;
    menuIndex.value = 1;
  }

  void changeScreenIndex(String screen) {
    if (screen == USER_INFO) {
      currentIndex.value = 0;
      menuIndex.value = 0;
    } else if (screen == QUESTION_LIST) {
      entryPoint = QUESTION_LIST;
      currentIndex.value = 1;
      menuIndex.value = 1;
    } else if (screen == MY_QUESTION) {
      entryPoint = MY_QUESTION;
      currentIndex.value = 3;
      menuIndex.value = 2;
    } else if (screen == QUESTION_DETAIL) {
      currentIndex.value = 2;
      questionDetailProvider.init();
    } else if (screen == ADD_QUESTION) {
      menuIndex.value = 3;
    }
  }

  void fetchInitData(String screen) async {
    if (screen == QUESTION_LIST) {
      await questionListProvider.fetchInitQuestionList();
    } else if (screen == MY_QUESTION) {
      await myQuestionProvider.fetchInitQuestionList();
    } else if (screen == USER_INFO) {
      await userProvider.fetchUserData();
    }
  }
}

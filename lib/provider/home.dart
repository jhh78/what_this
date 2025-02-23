import 'package:get/get.dart';
import 'package:whats_this/provider/my_question.dart';
import 'package:whats_this/provider/question_add.dart';
import 'package:whats_this/provider/question_list.dart';
import 'package:whats_this/provider/focus_manager.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/util/constants.dart';

class HomeProvider extends GetxService {
  final RxInt currentIndex = 0.obs;
  final RxInt menuIndex = 0.obs;

  final QuestionListProvider questionListProvider = Get.put(QuestionListProvider());
  final MyQuestionProvider myQuestionProvider = Get.put(MyQuestionProvider());
  final QuestionAddProvider questionAddProvider = Get.put(QuestionAddProvider());
  final UserProvider userProvider = Get.put(UserProvider());
  final FocusManagerProvider routerProvider = Get.put(FocusManagerProvider());

  void init() {
    currentIndex.value = 1;
    menuIndex.value = 1;
  }

  void changeScreenIndex(String screen) {
    if (screen == USER_INFO) {
      currentIndex.value = 0;
      menuIndex.value = 0;
      routerProvider.changeFocusNode(USER_INFO);
    } else if (screen == QUESTION_LIST) {
      currentIndex.value = 1;
      menuIndex.value = 1;
      routerProvider.changeFocusNode(QUESTION_LIST);
    } else if (screen == MY_QUESTION) {
      currentIndex.value = 3;
      menuIndex.value = 2;
      routerProvider.changeFocusNode(MY_QUESTION);
    } else if (screen == QUESTION_DETAIL) {
      currentIndex.value = 2;
      routerProvider.changeFocusNode(QUESTION_DETAIL);
    } else if (screen == ADD_QUESTION) {
      currentIndex.value = 4;
      menuIndex.value = 3;
      routerProvider.changeFocusNode(ADD_QUESTION);
    }
  }
}

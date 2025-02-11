import 'package:get/get.dart';
import 'package:whats_this/provider/focus.dart';
import 'package:whats_this/util/constants.dart';

class HomeProvider extends GetxService {
  final RxInt currentIndex = 0.obs;
  final RxInt menuIndex = 0.obs;

  final FocusProvider focusProvider = Get.put(FocusProvider());

  void init() {
    focusProvider.changeFocus(QUESTION_LIST);
    currentIndex.value = 0;
    menuIndex.value = 0;
  }

  void changeScreenIndex(String screen) {
    if (screen == QUESTION_LIST) {
      focusProvider.changeFocus(QUESTION_LIST);
      currentIndex.value = 0;
    } else if (screen == MY_QUESTION) {
      focusProvider.changeFocus(MY_QUESTION);
      currentIndex.value = 2;
    } else if (screen == QUESTION_DETAIL) {
      focusProvider.changeFocus(QUESTION_DETAIL);
      currentIndex.value = 1;
    } else if (screen == ADD_QUESTION) {
      focusProvider.changeFocus(ADD_QUESTION);
      currentIndex.value = 3;
    }
  }

  void changeMenuIndex(int index) {
    menuIndex.value = index;
  }
}

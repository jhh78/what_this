import 'package:get/get.dart';
import 'package:whats_this/util/constants.dart';

class HomeProvider extends GetxService {
  final RxInt currentIndex = 0.obs;
  final RxInt menuIndex = 0.obs;

  void init() {
    currentIndex.value = 0;
    menuIndex.value = 0;
  }

  void changeScreenIndex(String screen) {
    if (screen == QUESTION_LIST) {
      currentIndex.value = 0;
      menuIndex.value = 0;
    } else if (screen == MY_QUESTION) {
      currentIndex.value = 2;
      menuIndex.value = 1;
    } else if (screen == QUESTION_DETAIL) {
      currentIndex.value = 1;
    } else if (screen == ADD_QUESTION) {
      currentIndex.value = 3;
      menuIndex.value = 2;
    }
  }
}

import 'package:get/get.dart';

class HomeProvider extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxInt currentCommentIndex = 0.obs;
  final RxInt menuIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  void changeCommentIndex(int index) {
    currentCommentIndex.value = index;
  }

  void changeMenuIndex(int index) {
    menuIndex.value = index;
  }
}

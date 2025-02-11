import 'package:get/get.dart';

class HomeProvider extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxInt menuIndex = 0.obs;

  void init() {
    currentIndex.value = 0;
    menuIndex.value = 0;
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  void changeMenuIndex(int index) {
    menuIndex.value = index;
  }
}

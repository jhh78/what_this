import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/screen/question/add.dart';
import 'package:whats_this/screen/signin/sign_in.dart';
import 'package:whats_this/service/vender/auth.dart';
import 'package:whats_this/util/constants.dart';

class HomeService {
  final HomeProvider homeProvider = Get.put(HomeProvider());

  int getScreenIndex() {
    return homeProvider.currentIndex.value;
  }

  int getMenuIndex() {
    return homeProvider.menuIndex.value;
  }

  void onTabScreen(value) async {
    final User? currentUser = await AuthService.checkUserStatus();
    if (currentUser == null) {
      Get.offAll(() => SignInScreen());
      return;
    }
    if (value == 0) {
      homeProvider.changeScreenIndex(USER_INFO);
    } else if (value == 1) {
      homeProvider.changeScreenIndex(QUESTION_LIST);
    } else if (value == 2) {
      homeProvider.changeScreenIndex(MY_QUESTION);
    } else if (value == 3) {
      Get.to(() => QuestionAddScreen(), transition: Transition.rightToLeft);
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/screen/question/add.dart';
import 'package:whats_this/screen/question/detail.dart';
import 'package:whats_this/screen/my_question/my_question.dart';
import 'package:whats_this/screen/question/list.dart';
import 'package:whats_this/screen/signin/sign_in.dart';
import 'package:whats_this/screen/profile/user_info.dart';
import 'package:whats_this/service/auth.dart';
import 'package:whats_this/util/constants.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeProvider homeProvider = Get.put(HomeProvider());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Obx(() => IndexedStack(
                index: homeProvider.currentIndex.value,
                children: [
                  UserInfoScreen(),
                  QuestionListScreen(),
                  QuestionDetailScreen(),
                  MyQuestionScreen(),
                  QuestionAddScreen(),
                ],
              )),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.grey,
            currentIndex: homeProvider.menuIndex.value,
            onTap: (value) async {
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
                homeProvider.changeScreenIndex(ADD_QUESTION);
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '情報',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_rounded),
                label: 'リスト',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.question_answer_outlined),
                label: 'マイリスト',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_comment_outlined),
                label: '質問する',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

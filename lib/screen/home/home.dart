import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/screen/question/detail.dart';
import 'package:whats_this/screen/my_question/my_question.dart';
import 'package:whats_this/screen/question/list.dart';
import 'package:whats_this/screen/profile/user_info.dart';
import 'package:whats_this/service/home.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeService homeService = HomeService();
  final HomeProvider homeProvider = Get.put(HomeProvider());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Obx(() => IndexedStack(
                index: homeService.getScreenIndex(),
                children: [
                  UserInfoScreen(),
                  QuestionListScreen(),
                  QuestionDetailScreen(),
                  MyQuestionScreen(),
                ],
              )),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.grey,
            currentIndex: homeService.getMenuIndex(),
            onTap: homeService.onTabScreen,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Info',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_rounded),
                label: 'List',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.question_answer_outlined),
                label: 'My List',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_comment_outlined),
                label: 'Add',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

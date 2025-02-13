import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/provider/question_list.dart';
import 'package:whats_this/screen/add_question.dart';
import 'package:whats_this/screen/comment.dart';
import 'package:whats_this/screen/my_question.dart';
import 'package:whats_this/util/constants.dart';
import 'package:whats_this/widget/contents_card.dart';
import 'package:whats_this/widget/question_list.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeProvider homeProvider = Get.put(HomeProvider());
  final QuestionListProvider questionListProvider = Get.put(QuestionListProvider());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Obx(() => IndexedStack(
                index: homeProvider.currentIndex.value,
                children: [
                  QuestionListScreen(),
                  CommentScreen(),
                  MyQuestionScreen(),
                  AddQuestionScreen(),
                ],
              )),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            selectedItemColor: Colors.amber,
            currentIndex: homeProvider.menuIndex.value,
            onTap: (value) {
              if (value == 0) {
                homeProvider.changeScreenIndex(QUESTION_LIST);
              } else if (value == 1) {
                homeProvider.changeScreenIndex(MY_QUESTION);
              } else if (value == 2) {
                homeProvider.changeScreenIndex(ADD_QUESTION);
              }
            },
            items: [
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

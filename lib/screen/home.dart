import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/screen/add_question.dart';
import 'package:whats_this/screen/comment.dart';
import 'package:whats_this/screen/my_question.dart';
import 'package:whats_this/widget/contents_card.dart';

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
                  ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          homeProvider.changeIndex(1);
                        },
                        child: const ContentsCardWidget(),
                      );
                    },
                  ),
                  CommentScreen(),
                  MyQuestionScreen(),
                  AddQuestionScreen(),
                ],
              )),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: homeProvider.menuIndex.value,
            onTap: (value) {
              homeProvider.changeMenuIndex(value);
              if (value == 0) {
                homeProvider.changeIndex(0);
              } else if (value == 1) {
                homeProvider.changeIndex(2);
              } else if (value == 2) {
                homeProvider.changeIndex(3);
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.question_answer_outlined),
                label: 'Question',
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

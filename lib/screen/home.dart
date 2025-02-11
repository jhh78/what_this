import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/screen/add_question.dart';
import 'package:whats_this/screen/comment.dart';
import 'package:whats_this/screen/my_question.dart';
import 'package:whats_this/widget/contents_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  final HomeProvider homeProvider = Get.put(HomeProvider());

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // 포커스가 들어올 때 실행할 기능
        log('홈 화면에 포커스가 들어왔습니다.');
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Focus(
            focusNode: _focusNode,
            child: Obx(() => IndexedStack(
                  index: widget.homeProvider.currentIndex.value,
                  children: [
                    ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            widget.homeProvider.changeIndex(1);
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
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            selectedItemColor: Colors.amber,
            currentIndex: widget.homeProvider.menuIndex.value,
            onTap: (value) {
              widget.homeProvider.changeMenuIndex(value);
              if (value == 0) {
                widget.homeProvider.changeIndex(0);
              } else if (value == 1) {
                widget.homeProvider.changeIndex(2);
              } else if (value == 2) {
                widget.homeProvider.changeIndex(3);
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

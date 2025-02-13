import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/provider/my_question.dart';
import 'package:whats_this/util/constants.dart';

class MyQuestionScreen extends StatelessWidget {
  MyQuestionScreen({super.key});
  final HomeProvider homeProvider = Get.put(HomeProvider());
  final MyQuestionProvider myQuestionProvider = Get.put(MyQuestionProvider());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Question',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                homeProvider.changeScreenIndex(QUESTION_DETAIL);
              },
              // child: const ContentsCardWidget(),
              child: Container(),
            );
          },
        ),
      ),
    );
  }
}

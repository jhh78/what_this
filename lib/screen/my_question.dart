import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/widget/contents_card.dart';

class MyQuestionScreen extends StatelessWidget {
  MyQuestionScreen({super.key});
  final HomeProvider homeProvider = Get.put(HomeProvider());

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
        child: Center(
          child: ListView.builder(
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
        ),
      ),
    );
  }
}

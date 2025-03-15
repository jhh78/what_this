import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/screen/question/detail.dart';
import 'package:whats_this/screen/my_question/my_question.dart';
import 'package:whats_this/screen/question/list.dart';
import 'package:whats_this/screen/profile/user_info.dart';
import 'package:whats_this/screen/tutorial.dart';
import 'package:whats_this/service/home.dart';
import 'package:whats_this/service/vender/hive.dart';
import 'package:whats_this/util/constants.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeService homeService = HomeService();
  final HomeProvider homeProvider = Get.put(HomeProvider());
  final UserProvider userProvider = Get.put(UserProvider());

  Widget renderBottomNavigationBar() {
    if (userProvider.isDeleted.value) {
      return SizedBox.shrink();
    }

    return BottomNavigationBar(
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
    );
  }

  Future<Widget> renderHomeContents() async {
    final isFirst = await HiveService.getBoxValue(USER_TUTORIAL);
    if (isFirst == null) {
      return TutorialScreen();
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Obx(
              () => IndexedStack(
                index: homeService.getScreenIndex(),
                children: [
                  UserInfoScreen(),
                  QuestionListScreen(),
                  QuestionDetailScreen(),
                  MyQuestionScreen(),
                ],
              ),
            ),
            Positioned.fill(
              child: Obx(
                () => userProvider.isUpdated.value
                    ? Container(
                        color: Colors.black.withAlpha(200),
                        child: Center(
                          child: const CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => renderBottomNavigationBar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: FutureBuilder(
          future: renderHomeContents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return snapshot.data!;
          }),
    );
  }
}

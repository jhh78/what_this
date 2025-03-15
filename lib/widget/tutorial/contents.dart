import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/screen/home/home.dart';
import 'package:whats_this/service/vender/hive.dart';
import 'package:whats_this/util/constants.dart';

class TutorialContents extends StatelessWidget {
  const TutorialContents({
    super.key,
    required this.color,
    required this.title,
    required this.description,
    required this.isLastPage,
  });

  final Color color;
  final String title;
  final String description;
  final bool isLastPage;

  Future<void> handleNextPage() async {
    await HiveService.putBoxValue(USER_TUTORIAL, true);
    Get.offAll(() => HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 8, // 카드의 그림자 깊이
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // 카드의 둥근 모서리
        ),
        color: color, // 카드 배경색 설정
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9, // 화면 높이의 90%를 차지
          width: MediaQuery.of(context).size.width * 0.9, // 화면 너비의 90%를 차지
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (isLastPage) ...[
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: handleNextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('スタート'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

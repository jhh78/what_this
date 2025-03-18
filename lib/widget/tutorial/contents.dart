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

  Future<void> _handleNextPage() async {
    await HiveService.putBoxValue(USER_TUTORIAL, true);
    Get.offAll(() => HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: color,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTitle(context),
                const SizedBox(height: 16),
                _buildDescription(),
                if (isLastPage) _buildStartButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    return Text(
      description,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: ElevatedButton(
        onPressed: _handleNextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: const Text('スタート'),
      ),
    );
  }
}

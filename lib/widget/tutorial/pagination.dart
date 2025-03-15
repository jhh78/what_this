import 'package:flutter/material.dart';

class TutorialPagination extends StatelessWidget {
  const TutorialPagination({
    super.key,
    required this.currentPage,
    required this.tutorialDataLength,
  });

  final int currentPage;
  final int tutorialDataLength;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height / 5, // 페이지 네비게이션의 Y축 위치
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          tutorialDataLength,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: currentPage == index ? 16 : 12, // 현재 페이지는 더 크게 표시
            height: currentPage == index ? 16 : 12,
            decoration: BoxDecoration(
              color: currentPage == index
                  ? Colors.primaries[index % Colors.primaries.length] // 컬러풀한 색상
                  : Colors.grey, // 비활성화된 페이지는 회색
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

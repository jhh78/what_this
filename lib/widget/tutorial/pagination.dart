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
      bottom: MediaQuery.of(context).size.height / 7, // 페이지 네비게이션의 Y축 위치
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          tutorialDataLength,
          (index) => _buildIndicator(index),
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    final bool isActive = currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 16 : 12, // 현재 페이지는 더 크게 표시
      height: isActive ? 16 : 12,
      decoration: BoxDecoration(
        color: isActive
            ? Colors.primaries[index % Colors.primaries.length] // 활성화된 페이지는 컬러풀한 색상
            : Colors.grey, // 비활성화된 페이지는 회색
        shape: BoxShape.circle,
      ),
    );
  }
}

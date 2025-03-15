import 'package:flutter/material.dart';
import 'package:whats_this/widget/tutorial/contents.dart';
import 'package:whats_this/widget/tutorial/pagination.dart';

final List<Map<String, dynamic>> _tutorialData = [
  {
    'title': 'アプリ紹介 🧐✨',
    'description': '「愚かな質問なんて存在しない！」と言ったことがありますよね？\n\n'
        '日常生活で気になるけれど、検索するのはちょっと...ということ、ここで自由に質問してください！\n\n'
        'このアプリはあなたのすべての疑問を解決する魔法の空間です！\n\n'
        'もう一人で悩まず、世界の知恵を借りてみましょう！',
    'color': const Color(0xFF1E1E2C), // ダークブルー系
  },
  {
    'title': '使い方 🎯📸',
    'description': '使い方はとても簡単です！\n\n'
        '1. 気になることを質問する。（あなたの好奇心が世界を変えるかも？）\n'
        '2. 回答を待つ。（天才的な回答が来るかも、友達に笑われるかも...😂）\n'
        '3. 必要なら写真も添付！（言葉で説明しにくい場合は写真一枚で！）\n\n'
        '気軽に、負担なく使ってください！ 🎉',
    'color': const Color(0xFF2C2C2C), // ダークグレー系
  },
  {
    'title': '会員情報＆アカウント管理 ⚠️🔑',
    'description': '会員情報は会員ページで修正できます。\n\n'
        '1. ニックネームを変えて過去を消したいなら、今がチャンス！\n'
        '2. 退会するとアカウントは完全に削除されますが、既に投稿した質問は残ります。（インターネットの痕跡は消せない...🥲）\n'
        '3. アカウントを削除すると復元できないので、慎重に決定してください！\n\n'
        '退会は自由ですが、また戻りたくなるかも...? 😉',
    'color': const Color(0xFF1F1F1F), // ダークチャコール系
  },
  {
    'title': '質問を投稿する準備完了！ 🚀🎤',
    'description': 'さあ、舞台はあなたのものです！\n\n'
        '今頭に浮かんだその疑問、すぐに投稿してみましょう！\n\n'
        '「これを聞いてもいいのかな...？」と思ったら？そんな時こそもっと面白い質問です！ 😆\n\n'
        '💡 今すぐ質問しに行こう！ 💡',
    'color': const Color(0xFF242424), // ダークブラック系
  },
];

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _tutorialData.length,
            itemBuilder: (context, index) {
              final data = _tutorialData[index];
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 0.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                  }

                  // 회전 각도를 제한하여 카드가 부채꼴 모양으로 회전하도록 설정
                  double rotationX = value * 3.14 / 6; // X축 회전 (30도)
                  double rotationY = value * 3.14 / 12; // Y축 회전 (15도)
                  double translationZ = value * -500; // Z축 이동 (깊이 효과)

                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // Perspective effect
                      ..rotateX(rotationX) // X축 회전
                      ..rotateY(rotationY) // Y축 회전
                      ..translate(0.0, 0.0, translationZ), // Z축 이동
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: (1 - value.abs()).clamp(0.0, 1.0), // 카드가 점점 사라지도록 설정
                      child: TutorialContents(
                        color: data['color'],
                        title: data['title'],
                        description: data['description'],
                        isLastPage: index == _tutorialData.length - 1,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          TutorialPagination(
            currentPage: _currentPage,
            tutorialDataLength: _tutorialData.length,
          ),
        ],
      ),
    );
  }
}

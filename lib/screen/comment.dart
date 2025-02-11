import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/widget/contents_card.dart';
import 'dart:developer';

class CommentScreen extends StatefulWidget {
  CommentScreen({Key? key}) : super(key: key);
  final HomeProvider homeProvider = Get.put(HomeProvider());

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // 화면이 포커스를 가졌을 때 실행할 기능
        log('CommentScreen에 포커스가 들어왔습니다.');
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.homeProvider.changeIndex(0);
          },
        ),
      ),
      body: Focus(
        focusNode: _focusNode,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ContentsCardWidget(),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(
                          color: Colors.blueAccent.withAlpha(100),
                          width: 2,
                        ),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2016/03/31/19/56/avatar-1295396_1280.png',
                                  ),
                                  radius: 20,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'User $index',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Content text...',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

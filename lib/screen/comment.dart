import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/comment_list.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/util/constants.dart';
import 'package:whats_this/widget/contents_card.dart';

class CommentScreen extends StatelessWidget {
  CommentScreen({super.key});

  final HomeProvider homeProvider = Get.put(HomeProvider());
  final CommentListProvider commentListProvider = Get.put(CommentListProvider());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            homeProvider.changeScreenIndex(QUESTION_LIST);
          },
        ),
      ),
      body: Focus(
        focusNode: commentListProvider.focusNode,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // const ContentsCardWidget(questionModel: ,),
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
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Content text...',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
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

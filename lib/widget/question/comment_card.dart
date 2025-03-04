import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:whats_this/model/comment.dart';
import 'package:whats_this/provider/question/detail.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/widget/atoms/date_area.dart';
import 'package:whats_this/widget/atoms/icon_button.dart';
import 'package:whats_this/widget/atoms/next_page_button.dart';

class CommentCardWidget extends StatelessWidget {
  CommentCardWidget({
    super.key,
    required this.commentModel,
    this.onDelete,
    this.onBlock,
    this.onReport,
    this.onNextPage,
  });

  final CommentModel commentModel;
  final VoidCallback? onNextPage;
  final VoidCallback? onDelete;
  final VoidCallback? onBlock;
  final VoidCallback? onReport;

  final UserProvider userProvider = Get.put(UserProvider());
  final QuestionDetailProvider questionDetailProvider = Get.put(QuestionDetailProvider());

  Widget renderIconButton() {
    if (userProvider.user.value.id == commentModel.user.id) {
      return Row(
        children: [
          if (onDelete != null)
            IconButtonWidget(
              color: Colors.red,
              onPressed: onDelete!,
              icon: Icons.delete_forever_outlined,
            ),
        ],
      );
    }

    return Row(
      children: [
        if (onBlock != null)
          IconButtonWidget(
            color: Colors.red,
            onPressed: onBlock!,
            icon: Icons.block,
          ),
        if (onReport != null)
          IconButtonWidget(
            color: Colors.red,
            onPressed: onReport!,
            icon: Icons.notification_important_outlined,
          ),
      ],
    );
  }

  ImageProvider<Object> getFileImageWidget(CommentModel commentModel) {
    if (commentModel.user.profile.toString().isEmpty) {
      return AssetImage('assets/avatar/default.png');
    }

    final fileUrl =
        "${dotenv.env['POCKET_BASE_FILE_URL']}${commentModel.user.collectionId}/${commentModel.user.id}/${commentModel.user.profile}";
    return NetworkImage(fileUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (commentModel.user.id.isEmpty) {
      return NextPageButtonWidget(
        onTab: () => {
          if (onNextPage != null) {onNextPage!()}
        },
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 30, right: 10),
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
                    backgroundImage: getFileImageWidget(commentModel),
                    radius: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    commentModel.user.username,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                  ),
                  Spacer(),
                  renderIconButton(),
                ],
              ),
              SizedBox(height: 10),
              Text(
                commentModel.comment,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DateAreaWidget(currentTime: commentModel.created),
                  Row(
                    children: [
                      IconButtonWidget(
                        color: Colors.lightBlue,
                        onPressed: () => questionDetailProvider.thumbUpItem(model: commentModel),
                        icon: Icons.thumb_up,
                      ),
                      Text(
                        NumberFormat("#,###").format(commentModel.thumb_up),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                      ),
                      IconButtonWidget(
                        color: Colors.red,
                        onPressed: () => questionDetailProvider.thumbDownItem(model: commentModel),
                        icon: Icons.thumb_down,
                      ),
                      Text(
                        NumberFormat("#,###").format(commentModel.thumb_down),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

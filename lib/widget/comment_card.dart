import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:whats_this/model/comment.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/widget/atoms/icon_button.dart';

class CommentCardWidget extends StatelessWidget {
  CommentCardWidget({
    super.key,
    required this.commentModel,
    this.onDelete,
    this.onBlock,
    this.onReport,
  });

  final CommentModel commentModel;

  final VoidCallback? onDelete;
  final VoidCallback? onBlock;
  final VoidCallback? onReport;

  final UserProvider userProvider = Get.put(UserProvider());

  Future<Widget> renderIconButton() async {
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
                    backgroundImage: getFileImageWidget(commentModel),
                    radius: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'User Name',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      IconButtonWidget(
                        color: Colors.lightBlue,
                        onPressed: () {},
                        icon: Icons.thumb_up,
                      ),
                      Text('100', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black)),
                      IconButtonWidget(
                        color: Colors.red,
                        onPressed: () {},
                        icon: Icons.thumb_down,
                      ),
                      Text('10', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black)),
                      PopupMenuButton<String>(
                        color: Colors.black87,
                        iconColor: Colors.black87,
                        onSelected: (String result) {
                          switch (result) {
                            case 'delete':
                              if (onDelete != null) onDelete!();
                              break;
                            case 'block':
                              if (onBlock != null) onBlock!();
                              break;
                            case 'report':
                              if (onReport != null) onReport!();
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'block',
                            child: Text('Block'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'report',
                            child: Text('Report'),
                          ),
                        ],
                      ),
                    ],
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
  }
}

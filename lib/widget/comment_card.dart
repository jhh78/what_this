import 'package:flutter/material.dart';
import 'package:whats_this/widget/atoms/icon_button.dart';

class CommentCardWidget extends StatelessWidget {
  const CommentCardWidget({
    super.key,
    this.onDelete,
    this.onBlock,
    this.onReport,
  });

  final VoidCallback? onDelete;
  final VoidCallback? onBlock;
  final VoidCallback? onReport;

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
                    backgroundImage: NetworkImage(
                      'https://cdn.pixabay.com/photo/2016/03/31/19/56/avatar-1295396_1280.png',
                    ),
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

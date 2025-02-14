import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:whats_this/model/question.dart';
import 'package:whats_this/widget/atoms/icon_button.dart';

class ContentsCardWidget extends StatelessWidget {
  const ContentsCardWidget({
    super.key,
    required this.questionModel,
    this.onDelete,
    this.onBlock,
    this.onReport,
    this.onEdit,
  });

  final QuestionModel questionModel;
  final VoidCallback? onDelete;
  final VoidCallback? onBlock;
  final VoidCallback? onReport;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.blueAccent.withAlpha(100), width: 2),
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
                    questionModel.key.substring(0, 8),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      if (onDelete != null)
                        IconButtonWidget(
                          color: Colors.red,
                          onPressed: onDelete!,
                          icon: Icons.delete_forever_outlined,
                        ),
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
                      if (onEdit != null)
                        IconButtonWidget(
                          color: Colors.blue,
                          onPressed: onEdit!,
                          icon: Icons.edit_calendar_outlined,
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                questionModel.contents,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
              ),
              SizedBox(height: 10),
              if (questionModel.files.isNotEmpty)
                Column(
                  children: questionModel.files.map((url) {
                    final String imageIrl = "${dotenv.env['POCKET_BASE_FILE_URL']}${questionModel.collectionID}/${questionModel.id}/$url";
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: CachedNetworkImage(
                        imageUrl: imageIrl,
                        // placeholder: (context, url) => Center(child: LinearProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

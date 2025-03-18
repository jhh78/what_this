import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:whats_this/model/question.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/util/util.dart';
import 'package:whats_this/widget/atoms/date_area.dart';
import 'package:whats_this/widget/atoms/icon_button.dart';
import 'package:whats_this/widget/atoms/next_page_button.dart';

class ContentsCardWidget extends StatelessWidget {
  ContentsCardWidget({
    super.key,
    required this.questionModel,
    this.onDelete,
    this.onBlock,
    this.onReport,
    this.nextPage,
  });

  final QuestionModel questionModel;
  final VoidCallback? nextPage;
  final VoidCallback? onDelete;
  final VoidCallback? onBlock;
  final VoidCallback? onReport;

  final UserProvider userProvider = Get.put(UserProvider());

  @override
  Widget build(BuildContext context) {
    return questionModel.id.isEmpty ? _buildNextPageButton() : _buildCard(context);
  }

  Widget _buildNextPageButton() {
    return NextPageButtonWidget(onTab: () => nextPage);
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
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
              _buildHeader(context),
              const SizedBox(height: 10),
              _buildContentText(context),
              DateAreaWidget(currentTime: questionModel.created),
              const SizedBox(height: 10),
              _buildImageArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: _getProfileImage(),
          radius: 20,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getLevel(questionModel.user.exp),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
            ),
            Text(
              questionModel.user.username,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
            ),
          ],
        ),
        const Spacer(),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildContentText(BuildContext context) {
    return Text(
      questionModel.contents,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
    );
  }

  Widget _buildActionButtons() {
    final isCurrentUser = userProvider.user.value.id == questionModel.user.id;

    return Row(
      children: [
        if (isCurrentUser && onDelete != null)
          IconButtonWidget(
            color: Colors.red,
            onPressed: onDelete!,
            icon: Icons.delete_forever_outlined,
          ),
        if (!isCurrentUser && onBlock != null)
          IconButtonWidget(
            color: Colors.red,
            onPressed: onBlock!,
            icon: Icons.block,
          ),
        if (!isCurrentUser && onReport != null)
          IconButtonWidget(
            color: Colors.red,
            onPressed: onReport!,
            icon: Icons.notification_important_outlined,
          ),
      ],
    );
  }

  Widget _buildImageArea() {
    if (questionModel.files.isEmpty) return const SizedBox.shrink();

    final imageUrl = "${dotenv.env['POCKET_BASE_FILE_URL']}${questionModel.collectionID}/${questionModel.id}/${questionModel.files}";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 1.18,
          color: Colors.grey[300],
          child: Center(
            child: Icon(
              Icons.image_search,
              color: Colors.grey[700],
              size: 50,
            ),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  ImageProvider<Object> _getProfileImage() {
    if (questionModel.user.profile.toString().isEmpty) {
      return const AssetImage('assets/avatar/default.png');
    }

    final fileUrl =
        "${dotenv.env['POCKET_BASE_FILE_URL']}${questionModel.user.collectionId}/${questionModel.user.id}/${questionModel.user.profile}";
    return NetworkImage(fileUrl);
  }
}

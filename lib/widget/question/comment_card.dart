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

  @override
  Widget build(BuildContext context) {
    return commentModel.user.id.isEmpty ? _buildNextPageButton() : _buildCommentCard(context);
  }

  Widget _buildNextPageButton() {
    return NextPageButtonWidget(
      onTab: () => onNextPage,
    );
  }

  Widget _buildCommentCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
              _buildHeader(context),
              const SizedBox(height: 10),
              _buildCommentText(context),
              _buildFooter(context),
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
        Text(
          commentModel.user.username,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
        ),
        const Spacer(),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildCommentText(BuildContext context) {
    return Text(
      commentModel.comment,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DateAreaWidget(currentTime: commentModel.created),
        _buildThumbButtons(context),
      ],
    );
  }

  Widget _buildThumbButtons(BuildContext context) {
    return Row(
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
    );
  }

  Widget _buildActionButtons() {
    final isCurrentUser = userProvider.user.value.id == commentModel.user.id;

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

  ImageProvider<Object> _getProfileImage() {
    if (commentModel.user.profile.toString().isEmpty) {
      return const AssetImage('assets/avatar/default.png');
    }

    final fileUrl =
        "${dotenv.env['POCKET_BASE_FILE_URL']}${commentModel.user.collectionId}/${commentModel.user.id}/${commentModel.user.profile}";
    return NetworkImage(fileUrl);
  }
}

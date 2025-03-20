import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/screen/signin/sign_in.dart';
import 'package:whats_this/service/vender/hive.dart';
import 'package:whats_this/util/constants.dart';
import 'package:whats_this/util/styles.dart';
import 'package:whats_this/util/util.dart';
import 'package:whats_this/widget/atoms/action_button.dart';
import 'package:whats_this/widget/atoms/dimple_diadlog.dart';
import 'package:whats_this/widget/atoms/snackber.dart';

class UserInfoScreen extends StatelessWidget {
  UserInfoScreen({super.key});

  final UserProvider userProvider = Get.put(UserProvider());

  ImageProvider<Object> _getProfileImage() {
    try {
      if (userProvider.tempProfileImage.value.path.isNotEmpty) {
        return FileImage(userProvider.tempProfileImage.value);
      } else if (userProvider.user.value.profile.isEmpty) {
        return const AssetImage('assets/avatar/default.png');
      }

      final imagePath = HiveService.getBoxValue(USER_PROFILE_IMAGE);
      if (imagePath != null && imagePath is String && imagePath.isNotEmpty) {
        return FileImage(File(imagePath));
      }

      final fileUrl =
          "${dotenv.env['POCKET_BASE_FILE_URL']}${userProvider.user.value.collectionId}/${userProvider.user.value.id}/${userProvider.user.value.profile}";
      return NetworkImage(fileUrl);
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
      return const AssetImage('assets/avatar/default.png');
    }
  }

  void _handleUserDelete() {
    if (userProvider.isDeleted.value) {
      infoSnackBar(title: '処理中', content: 'ユーザー情報を削除しています。');
      return;
    }

    Get.dialog(
      SimpleDialogWidget(
        title: 'ユーザー退会',
        content: '本当に退会しますか？退会のため認証が必要な場合もあります。',
        okTitle: '退会する',
        okFunction: () async {
          try {
            Get.back();
            userProvider.isDeleted.value = true;
            await userProvider.deleteUser();
            Get.offAll(() => SignInScreen());
          } catch (e) {
            errorSnackBar(title: 'エラー', content: 'ユーザー情報の削除に失敗しました。');
          }
        },
      ),
    );
  }

  Widget _buildProfileSection() {
    return GestureDetector(
      onTap: () => userProvider.pickImage(),
      child: CircleAvatar(
        backgroundImage: _getProfileImage(),
        radius: 120,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: ICON_SIZE_BIG,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        _buildProfileSection(),
        const SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            children: [
              _buildRow('ユーザー名: ', userProvider.user.value.username),
              const SizedBox(height: 40),
              _buildRow('レベル: ', getLevel(userProvider.user.value.exp)),
              const SizedBox(height: 40),
              _buildRow('経験値: ', getNumberFormat(userProvider.user.value.exp)),
              const SizedBox(height: 40),
              ActionButtonWidget(
                noticeTitle: '処理完了',
                noticeContent: 'ユーザー情報が更新されました。',
                buttonText: '更新',
                showNotice: true,
                isUpdated: userProvider.isUpdated.value,
                onPressed: userProvider.updateUser,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(Get.context!).textTheme.titleLarge,
        ),
        Text(
          value,
          style: Theme.of(Get.context!).textTheme.titleLarge,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Obx(() => AppBar(
                title: Text(userProvider.isDeleted.value ? '会員削除中' : '会員情報'),
                centerTitle: true,
                actions: [
                  if (!userProvider.isDeleted.value)
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                      onPressed: _handleUserDelete,
                      iconSize: ICON_SIZE,
                    ),
                ],
              )),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() => userProvider.isLoading.value ? const Center(child: CircularProgressIndicator()) : _buildUserInfo()),
            ),
            Obx(
              () => userProvider.isDeleted.value
                  ? Container(
                      color: Colors.black.withAlpha(200),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

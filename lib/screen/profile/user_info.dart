import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/screen/signin/sign_in.dart';
import 'package:whats_this/service/vender/camera.dart';
import 'package:whats_this/service/vender/hive.dart';
import 'package:whats_this/util/constants.dart';
import 'package:whats_this/util/permission.dart';
import 'package:whats_this/util/styles.dart';
import 'package:whats_this/util/util.dart';
import 'package:whats_this/widget/atoms/action_button.dart';

class UserInfoScreen extends StatelessWidget {
  UserInfoScreen({super.key});
  final UserProvider userProvider = Get.put(UserProvider());
  final CameraService cameraService = CameraService();

  ImageProvider<Object> getFileImageWidget() {
    try {
      if (userProvider.tempProfileImage.value.path.isNotEmpty) {
        return FileImage(userProvider.tempProfileImage.value);
      } else if (userProvider.user.value.profile.isEmpty) {
        return AssetImage('assets/avatar/default.png');
      }

      final dynamic imagePath = HiveService.getBoxValue(USER_PROFILE_IMAGE);
      log('User Profile ImagePath: $imagePath');
      if (imagePath != null && imagePath is String && imagePath.isNotEmpty) {
        return FileImage(File(imagePath));
      }

      final fileUrl =
          "${dotenv.env['POCKET_BASE_FILE_URL']}${userProvider.user.value.collectionId}/${userProvider.user.value.id}/${userProvider.user.value.profile}";
      return NetworkImage(fileUrl);
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
      return AssetImage('assets/avatar/default.png');
    }
  }

  void handleUserDelete() {
    Get.dialog(
      AlertDialog(
        title: Text('ユーザー退会'),
        content: Text('本当に退会しますか？退会のため認証が必要な場合もあります。'),
        actions: [
          ActionButtonWidget(
              buttonText: '退会する',
              isUpdated: false,
              onPressed: () async {
                await userProvider.deleteUser();
                Get.offAll(() => SignInScreen());
              }),
        ],
      ),
    );
  }

  Widget renderUserInfoContents(BuildContext context) {
    if (userProvider.isLoading.value) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => checkCameraPermission(
                acceptFunc: () => userProvider.pickImage(),
              ),
              child: CircleAvatar(
                backgroundImage: getFileImageWidget(),
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
            ),
          ),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              children: [
                renderRowWidget('ユーザー名: ', userProvider.user.value.username),
                const SizedBox(height: 40),
                renderRowWidget('レベル: ', getLevel(userProvider.user.value.exp)),
                const SizedBox(height: 40),
                renderRowWidget('経験値: ', getNumberFormat(userProvider.user.value.exp)),
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
      ),
    );
  }

  Row renderRowWidget(String title, String value) {
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
        appBar: AppBar(
          title: Text('会員情報', style: Theme.of(context).textTheme.headlineMedium),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(Icons.remove_circle_outline_rounded),
                onPressed: handleUserDelete,
                iconSize: ICON_SIZE,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() => renderUserInfoContents(context)),
        ),
      ),
    );
  }
}

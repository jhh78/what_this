import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/service/camera.dart';
import 'package:whats_this/util/styles.dart';
import 'package:whats_this/util/util.dart';

class UserInfoScreen extends StatelessWidget {
  UserInfoScreen({super.key});
  final UserProvider userProvider = Get.put(UserProvider());
  final CameraService cameraService = CameraService();

  ImageProvider<Object> getFileImageWidget() {
    if (userProvider.tempProfileImage.value.path.isNotEmpty) {
      return FileImage(userProvider.tempProfileImage.value);
    } else if (userProvider.user.value.profile == null) {
      return AssetImage('assets/avatar/default.png');
    }

    final fileUrl =
        "${dotenv.env['POCKET_BASE_FILE_URL']}${userProvider.user.value.collectionId}/${userProvider.user.value.id}/${userProvider.user.value.profile}";
    return NetworkImage(fileUrl);
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
          GestureDetector(
              onTap: () => userProvider.pickImage(),
              child: CircleAvatar(
                radius: 120,
                backgroundImage: getFileImageWidget(),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: ICON_SIZE,
                  ),
                ),
              )),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              children: [
                renderRowWidget('レベル: ', getLevel(userProvider.user.value.exp)),
                const SizedBox(height: 32),
                renderRowWidget('経験値: ', getNumberFormat(userProvider.user.value.exp)),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(48), // Set the height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  onPressed: () async {
                    await userProvider.updateUser();
                    Get.snackbar(
                      '処理完了',
                      'ユーザー情報が更新されました。',
                      snackPosition: SnackPosition.BOTTOM,
                      margin: EdgeInsets.all(16),
                    );
                  },
                  child: userProvider.isLoading.value
                      ? CircularProgressIndicator()
                      : Text(
                          '更新',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() => renderUserInfoContents(context)),
        ),
      ),
    );
  }
}

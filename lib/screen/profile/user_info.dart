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
import 'package:whats_this/widget/atoms/dimple_diadlog.dart';
import 'package:whats_this/widget/atoms/simple_button.dart';
import 'package:whats_this/widget/atoms/snackber.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final UserProvider userProvider = Get.put(UserProvider());
  bool isDeleted = false;
  bool isLoading = false;

  // 프로필 이미지 가져오기
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

  // 사용자 삭제 처리
  void _handleUserDelete() {
    Get.dialog(
      SimpleDialogWidget(
        title: 'ユーザー退会',
        content: '本当に退会しますか？退会のため認証が必要な場合もあります。',
        okTitle: '退会する',
        okFunction: () async {
          try {
            Get.back();
            setState(() => isDeleted = true);
            await userProvider.deleteUser();
            Get.offAll(() => SignInScreen());
          } catch (e) {
            errorSnackBar(title: 'エラー', content: 'ユーザー情報の削除に失敗しました。');
          } finally {
            setState(() => isDeleted = false);
          }
        },
      ),
    );
  }

  // 프로필 섹션
  Widget _buildProfileSection() {
    return GestureDetector(
      onTap: () => userProvider.pickImage(),
      child: Obx(() {
        final imageProvider = _getProfileImage(); // ImageProvider<Object> 반환
        return CircleAvatar(
          backgroundImage: imageProvider,
          radius: 120,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: ICON_SIZE_BIG,
            ),
          ),
        );
      }),
    );
  }

  // 사용자 정보 섹션
  Widget _buildUserInfo() {
    return Column(
      children: [
        _buildProfileSection(),
        const SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            children: [
              Obx(() => _buildRow('ユーザー名: ', userProvider.user.value.username)),
              const SizedBox(height: 40),
              Obx(() => _buildRow('レベル: ', getLevel(userProvider.user.value.exp))),
              const SizedBox(height: 40),
              Obx(() => _buildRow('経験値: ', getNumberFormat(userProvider.user.value.exp))),
              const SizedBox(height: 40),
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: SimpleButtonWidget(
                        onClick: _handleUpdateUser,
                        title: "更新",
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  // 사용자 정보 갱신 처리
  Future<void> _handleUpdateUser() async {
    setState(() => isLoading = true);
    await userProvider.updateUser();
    setState(() => isLoading = false);
    successSnackBar(title: "処理完了", content: "ユーザー情報を更新しました。");
  }

  // 행(Row) 생성
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

  // AppBar 생성
  Widget _buildAppBar() {
    return AppBar(
      title: Text(isDeleted ? '会員削除中' : '会員情報'),
      centerTitle: true,
      actions: [
        if (!isDeleted)
          IconButton(
            icon: const Icon(Icons.remove_circle_outline_rounded),
            onPressed: _handleUserDelete,
            iconSize: ICON_SIZE,
          ),
      ],
    );
  }

  // 로딩 오버레이
  Widget _buildLoadingOverlay() {
    return isDeleted
        ? Container(
            color: Colors.black.withAlpha(200),
            child: const Center(child: CircularProgressIndicator()),
          )
        : const SizedBox.shrink();
  }

  // Body 생성
  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildUserInfo(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: _buildAppBar(),
        ),
        body: Stack(
          children: [
            _buildBody(),
            _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/system.dart';
import 'package:whats_this/service/camera.dart';
import 'package:whats_this/util/constants.dart';

class UserProvider extends GetxService {
  RxInt exp = 0.obs;
  Rx<String> profileImage = ''.obs;
  Rx<File> tempProfileImage = File('').obs;
  RxBool isLoading = false.obs;

  final tableName = 'user';
  String collectionID = '';
  String userId = '';
  final CameraService cameraService = CameraService();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final Box<dynamic> box = await Hive.openBox(SYSTEM_BOX);
    final SystemConfigModel config = box.get(SYSTEM_CONFIG);

    if (config.userID.isEmpty) {
      return;
    }

    isLoading.value = true;
    final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);
    final record = await pb.collection(tableName).getOne(config.userID);

    exp.value = record.get('exp');
    profileImage.value = record.get('profile');
    collectionID = record.collectionId;
    userId = record.get("id");
    tempProfileImage.value = File('');

    isLoading.value = false;
  }

  Future<void> createUser() async {
    // 회원등록
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);

    final passwd = user.metadata.hashCode.toString();
    final key = user.uid;
    final emailVisibility = user.emailVerified;

    final body = <String, dynamic>{
      "emailVisibility": emailVisibility,
      "password": passwd,
      "passwordConfirm": passwd,
      "key": key,
    };

    final record = await pb.collection(tableName).create(body: body);

    Box box = await Hive.openBox(SYSTEM_BOX);
    SystemConfigModel config = box.get(SYSTEM_CONFIG);
    config.isInit = true;
    config.userID = record.id;

    box.put(SYSTEM_CONFIG, config);
    await box.close();
  }

  Future<void> updateUser() async {
    Box box = await Hive.openBox(SYSTEM_BOX);
    SystemConfigModel config = box.get(SYSTEM_CONFIG);

    final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);

    final body = <String, dynamic>{
      "exp": exp.value,
    };

    final List<http.MultipartFile> multipartImages = [];

    if (tempProfileImage.value.path.isNotEmpty) {
      final compressedImage = await cameraService.compressImage(tempProfileImage.value, 640);
      multipartImages.add(await http.MultipartFile.fromPath('profile', compressedImage.path));
    }

    await pb.collection(tableName).update(config.userID, body: body, files: multipartImages);
  }
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/system.dart';
import 'package:whats_this/model/user.dart';
import 'package:whats_this/service/camera.dart';
import 'package:whats_this/util/constants.dart';

class UserProvider extends GetxService {
  Rx<UserModel> user = UserModel.emptyModel().obs;
  Rx<File> tempProfileImage = File('').obs;
  RxBool isLoading = false.obs;

  final tableName = 'user';
  final CameraService cameraService = CameraService();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> pickImage() async {
    final File? image = await cameraService.pickImageFromCamera();

    if (image == null) {
      return;
    }

    tempProfileImage.value = image;
  }

  Future<void> fetchUserData() async {
    Box box = await Hive.openBox(SYSTEM_BOX);
    final SystemConfigModel config = box.get(SYSTEM_CONFIG);

    final userID = config.userId;

    if (userID.isEmpty) {
      return;
    }

    isLoading.value = true;
    final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);
    final record = await pb.collection(tableName).getOne(userID);
    user.value = UserModel.fromRecordModel(record);
    tempProfileImage.value = File('');
    isLoading.value = false;
  }

  Future<void> createUser() async {
    // 회원등록
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return;
    }

    final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);

    final passwd = firebaseUser.metadata.hashCode.toString();
    final key = firebaseUser.uid;
    final emailVisibility = firebaseUser.emailVerified;

    final body = <String, dynamic>{
      "emailVisibility": emailVisibility,
      "password": passwd,
      "passwordConfirm": passwd,
      "key": key,
    };

    final record = await pb.collection(tableName).create(body: body);
    user.value = UserModel.fromRecordModel(record);

    Box box = await Hive.openBox(SYSTEM_BOX);
    SystemConfigModel config = box.get(SYSTEM_CONFIG);
    config.isInit = true;
    config.userId = record.id;
    box.put(SYSTEM_CONFIG, config);
  }

  Future<void> updateUser() async {
    final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);

    final body = <String, dynamic>{
      "exp": user.value.exp,
    };
    final List<http.MultipartFile> multipartImages = await cameraService.convertImageToMultipartFile(
      key: 'profile',
      image: tempProfileImage.value,
      size: 640,
    );

    await pb.collection(tableName).update(user.value.id, body: body, files: multipartImages);
  }

  Future<void> addPoint() async {
    user.value.exp += ADD_POINT;

    final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);
    final body = <String, dynamic>{
      "exp": user.value.exp,
    };

    await pb.collection(tableName).update(user.value.id, body: body);
  }
}

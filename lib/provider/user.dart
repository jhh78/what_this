import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/user.dart';
import 'package:whats_this/service/vender/auth.dart';
import 'package:whats_this/service/vender/camera.dart';
import 'package:whats_this/service/vender/hive.dart';
import 'package:whats_this/util/constants.dart';

class UserProvider extends GetxService {
  Rx<UserModel> user = UserModel.emptyModel().obs;
  Rx<File> tempProfileImage = File('').obs;
  RxBool isLoading = false.obs;
  RxBool isUpdated = false.obs;
  RxBool isDeleted = false.obs;

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
    final userID = await HiveService.getBoxValue(USER_ID);
    if (userID == null) {
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
    // 회원조회
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return;
    }

    final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);

    final auth = await pb.collection(tableName).getList(
          sort: '-created',
          filter: 'key="${firebaseUser.uid}"',
        );

    if (auth.items.isNotEmpty) {
      user.value = UserModel.fromRecordModel(auth.items.first);
    } else {
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
    }

    await HiveService.putBoxValue(IS_FIRST_INSTALL, true);
    await HiveService.putBoxValue(USER_ID, user.value.id);
  }

  Future<void> updateUser() async {
    isUpdated.value = true;
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
    await saveImageLocally(tempProfileImage.value); // 이미지 로컬 저장
    isUpdated.value = false;
  }

  Future<void> addPoint() async {
    user.value.exp += ADD_POINT;

    final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);
    final body = <String, dynamic>{
      "exp": user.value.exp,
    };

    await pb.collection(tableName).update(user.value.id, body: body);
  }

  Future<void> saveImageLocally(File image) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_profile_image.png';

      if (!await image.exists()) {
        log('Image file does not exist');
        return;
      }

      final localImage = File('$path/$fileName');

      // 이미지 파일을 로컬에 저장
      await localImage.writeAsBytes(await image.readAsBytes());
      await HiveService.putBoxValue(USER_PROFILE_IMAGE, '$path/$fileName');

      log('Image saved to imagePath : $path/$fileName');
    } catch (e) {
      log('Error saving image: $e');
    }
  }

  Future<void> deleteUser() async {
    try {
      isDeleted.value = true;
      await AuthService.deleteUser();
      await HiveService.clearBox();
    } catch (e) {
      rethrow;
    } finally {
      isDeleted.value = false;
    }
  }
}

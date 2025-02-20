import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/system.dart';
import 'package:whats_this/util/constants.dart';

class UserProvider extends GetxService {
  RxInt exp = 0.obs;
  RxString profileImage = ''.obs;

  final tableName = 'user';

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  Future<void> getUserData() async {
    final Box<dynamic> box = await Hive.openBox(SYSTEM_BOX);
    final SystemConfigModel config = box.get(SYSTEM_CONFIG);

    if (config.userID.isEmpty) {
      return;
    }

    final pb = PocketBase(dotenv.env['POCKET_BASE_URL']!);
    final record = await pb.collection(tableName).getOne(config.userID);

    exp.value = record.get('exp');
    profileImage.value = record.get('profileImage');

    log('User data: $record $exp $profileImage');
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
}

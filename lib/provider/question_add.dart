import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/system.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/service/camera.dart';
import 'package:whats_this/util/constants.dart';

class QuestionAddProvider extends GetxService {
  Rx<File> image = File("").obs;

  final TextEditingController textController = TextEditingController();
  final CameraService cameraService = CameraService();
  final UserProvider userProvider = Get.put(UserProvider());

  void init() {
    clearImage();
    textController.clear();
  }

  Future<void> pickImage() async {
    final File? image = await cameraService.pickImageFromCamera();

    if (image == null) {
      return;
    }

    this.image.value = image;
  }

  void clearImage() {
    image.value = File("");
  }

  Future<void> uploadQuestion() async {
    final String questionText = textController.text;

    final pbUrl = dotenv.env['POCKET_BASE_URL'].toString();
    final pb = PocketBase(pbUrl);

    // 이미지 업로드
    final List<http.MultipartFile> multipartImages = await cameraService.convertImageToMultipartFile(
      key: 'files',
      image: image.value,
      size: 800,
    );

    await pb.collection('questions').create(
      body: {
        "user": userProvider.user.value.id,
        "contents": questionText,
      },
      files: multipartImages,
    );

    init();
  }
}

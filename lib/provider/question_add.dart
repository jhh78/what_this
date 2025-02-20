import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/service/camera.dart';

class QuestionAddProvider extends GetxService {
  RxList<File> images = <File>[].obs;

  final TextEditingController textController = TextEditingController();
  final CameraService cameraService = CameraService();

  void init() {
    images.clear();
    textController.clear();
  }

  Future<void> uploadQuestion() async {
    final String questionText = textController.text;
    final User? user = FirebaseAuth.instance.currentUser;
    final String uid = user!.uid;

    final pbUrl = dotenv.env['POCKET_BASE_URL'].toString();
    final pb = PocketBase(pbUrl);

    // 이미지 업로드
    final List<http.MultipartFile> multipartImages = [];
    for (File image in images) {
      final File compressedImage = await cameraService.compressImage(image, 800);
      multipartImages.add(await http.MultipartFile.fromPath('files', compressedImage.path));
    }

    await pb.collection('questions').create(
      body: {
        "key": uid,
        "contents": questionText,
      },
      files: multipartImages,
    );

    init();
  }
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

class QuestionAddProvider extends GetxService {
  RxList<File> images = <File>[].obs;

  final TextEditingController textController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  void init() {
    images.clear();
    textController.clear();
  }

  Future<File> compressImage(File file) async {
    final img.Image? image = img.decodeImage(await file.readAsBytes());
    if (image == null) {
      throw Exception('画像の読み込みに失敗しました。');
    }

    final img.Image resizedImage = img.copyResize(image, width: 800); // 너비를 800으로 조정
    final File compressedFile = File(file.path)..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 90)); // 품질을 80으로 설정하여 압축
    return compressedFile;
  }

  Future<void> pickImageFromCamera() async {
    if (images.isNotEmpty) {
      Get.snackbar('イメージ登録', 'イメージ登録は1つまでです。');
      return;
    }

    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      images.add(File(image.path));
      return;
    }
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
      final File compressedImage = await compressImage(image);
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

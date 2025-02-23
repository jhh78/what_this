import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/system.dart';
import 'package:whats_this/provider/focus_manager.dart';
import 'package:whats_this/provider/user.dart';
import 'package:whats_this/service/camera.dart';
import 'package:whats_this/util/constants.dart';

class QuestionAddProvider extends GetxService {
  Rx<File> image = File("").obs;

  final TextEditingController textController = TextEditingController();
  final CameraService cameraService = CameraService();
  final UserProvider userProvider = Get.put(UserProvider());
  final FocusManagerProvider focusManagerProvider = Get.put(FocusManagerProvider());

  @override
  void onInit() {
    super.onInit();

    focusManagerProvider.addQuestionFocusNode.addListener(() {
      if (focusManagerProvider.addQuestionFocusNode.hasFocus) {
        log("?????????????????????????????????????????? > addQuestionFocusNode");
        init();
      }
    });
  }

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

  Future<void> addQuestion() async {
    final String questionText = textController.text;
    Box box = await Hive.openBox(SYSTEM_BOX);
    final SystemConfigModel config = box.get(SYSTEM_CONFIG);

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
        "user": config.userId,
        "contents": questionText,
      },
      files: multipartImages,
    );

    init();
  }
}

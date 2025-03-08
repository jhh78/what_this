import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/service/vender/hive.dart';
import 'package:http/http.dart' as http;
import 'package:whats_this/util/constants.dart';

import '../provider/home.dart';
import '../provider/user.dart';

class QuestionService {
  final HomeProvider homeProvider = Get.put(HomeProvider());
  final UserProvider userProvider = Get.put(UserProvider());

  Future<void> addQuestion({required textController, required cameraService, required image}) async {
    final String questionText = textController.text;
    final userId = HiveService.getBoxValue(USER_ID);

    final pbUrl = dotenv.env['POCKET_BASE_URL'].toString();
    final pb = PocketBase(pbUrl);

    // 이미지 업로드
    final List<http.MultipartFile> multipartImages = await cameraService.convertImageToMultipartFile(
      key: 'files',
      image: image,
      size: 1024,
    );

    await pb.collection('questions').create(
      body: {
        "user": userId,
        "contents": questionText,
      },
      files: multipartImages,
    );

    await userProvider.addPoint();
    homeProvider.init();
  }
}

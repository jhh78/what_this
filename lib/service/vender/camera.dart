import 'dart:io';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whats_this/widget/atoms/dimple_diadlog.dart';

class CameraService {
  final ImagePicker picker = ImagePicker();

  Future<File> compressImage(File file, int size) async {
    final img.Image? image = img.decodeImage(await file.readAsBytes());
    if (image == null) {
      throw Exception('画像の読み込みに失敗しました。');
    }

    final img.Image resizedImage = img.copyResize(image, width: size);
    final File compressedFile = File(file.path)..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 90)); // 품질을 80으로 설정하여 압축
    return compressedFile;
  }

  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        return File(image.path);
      }

      return null;
    } catch (err) {
      Get.dialog(
        SimpleDialogWidget(
            title: 'カメラの権限が必要です',
            content: 'このアプリでは、プロフィール写真の変更や質問登録のためにカメラの権限が必要です。カメラの権限を許可してください。',
            okTitle: '許可する',
            okFunction: () {
              openAppSettings();
              Get.back();
            }),
      );
      return null;
    }
  }

  Future<List<http.MultipartFile>> convertImageToMultipartFile({required String key, required File image, required int size}) async {
    final List<http.MultipartFile> multipartImages = [];

    if (image.path.isEmpty) {
      return multipartImages;
    }

    final File compressedImage = await compressImage(image, size);
    multipartImages.add(await http.MultipartFile.fromPath(key, compressedImage.path));

    return multipartImages;
  }
}

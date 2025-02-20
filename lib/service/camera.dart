import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

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
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return File(image.path);
    }

    return null;
  }
}

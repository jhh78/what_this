import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whats_this/widget/atoms/draw_painter/draw_painter.dart';
import 'package:image/image.dart' as img;
import 'package:exif/exif.dart';

class DrawPaintService {
  Future<File> fixImageOrientation(File imageFile) async {
    // 이미지 파일을 읽음
    final bytes = await imageFile.readAsBytes();
    final originalImage = img.decodeImage(bytes);

    if (originalImage == null) {
      throw Exception('이미지를 디코딩할 수 없습니다.');
    }

    // EXIF 데이터를 읽어 이미지의 방향을 확인
    final Map<String, IfdTag> exifData = await readExifFromBytes(bytes);
    final orientation = exifData['Image Orientation']?.printable;

    img.Image fixedImage;

    // EXIF Orientation 값에 따라 이미지를 회전
    switch (orientation) {
      case 'Top-left': // 회전 필요 없음
        fixedImage = originalImage;
        break;
      case 'Top-right': // 좌우 반전
        fixedImage = img.flipHorizontal(originalImage);
        break;
      case 'Bottom-right': // 180도 회전
        fixedImage = img.copyRotate(originalImage, angle: 180); // 수정된 부분
        break;
      case 'Bottom-left': // 상하 반전
        fixedImage = img.flipVertical(originalImage);
        break;
      case 'Left-top': // 반시계 방향으로 90도 회전
        fixedImage = img.copyRotate(originalImage, angle: 90);
        break;
      case 'Right-top': // 시계 방향으로 90도 회전
        fixedImage = img.copyRotate(originalImage, angle: -90);
        break;
      case 'Right-bottom': // 시계 방향으로 270도 회전
        fixedImage = img.copyRotate(originalImage, angle: -270);
        break;
      case 'Left-bottom': // 반시계 방향으로 270도 회전
        fixedImage = img.copyRotate(originalImage, angle: 270);
        break;
      default: // 알 수 없는 Orientation 값
        fixedImage = originalImage;
        break;
    }

    // 수정된 이미지를 파일로 저장
    final fixedBytes = img.encodeJpg(fixedImage);
    final fixedFile = await imageFile.writeAsBytes(fixedBytes);

    return fixedFile;
  }

  Future<File> saveToCache({
    required BuildContext context,
    required List<Map<String, dynamic>> points,
    required Offset? eraserPosition,
    required bool isEraserMode,
    required double eraserSize,
  }) async {
    // 화면 크기를 가져옴
    final size = MediaQuery.of(context).size;

    // 1. PictureRecorder와 Canvas 생성
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size.width, size.height));

    // 2. 배경색 설정
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    // 3. 현재 그려진 점들을 캔버스에 다시 그림
    DrawPainterWidget(points, eraserPosition, isEraserMode, eraserSize).paint(canvas, size);

    // 4. Picture를 Image로 변환
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );

    // 5. Image를 PNG로 변환
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    // 6. 캐시에 저장
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'drawn_image_$timestamp.png';
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(pngBytes);

    log('이미지 저장 완료: $filePath');

    // 7. EXIF 데이터를 기반으로 이미지 회전 처리
    final fixedFile = await fixImageOrientation(file);

    // 8. 회전 처리된 이미지를 다시 캐시에 저장
    final fixedFileName = 'drawn_image_fixed_$timestamp.png';
    final fixedFilePath = '${directory.path}/$fixedFileName';
    final finalFile = File(fixedFilePath);
    await finalFile.writeAsBytes(await fixedFile.readAsBytes());

    log('이미지 저장 완료 (회전 처리 후): $fixedFilePath');

    return finalFile;
  }
}

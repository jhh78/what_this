import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/provider/home.dart';
import 'package:whats_this/util/styles.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];
  final HomeProvider homeProvider = Get.put(HomeProvider());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // 포커스가 사라질 때 키보드를 내림
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromCamera() async {
    if (_images.length >= 3) {
      Get.snackbar('이미지는 최대 3개까지만 추가할 수 있습니다.', '이미지는 최대 3개까지만 추가할 수 있습니다.');
      return;
    }

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
    }
  }

  Future<File> _compressImage(File file) async {
    final img.Image? image = img.decodeImage(await file.readAsBytes());
    if (image == null) {
      throw Exception('이미지를 디코딩할 수 없습니다.');
    }

    final img.Image resizedImage = img.copyResize(image, width: 800); // 너비를 800으로 조정
    final File compressedFile = File(file.path)..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 90)); // 품질을 80으로 설정하여 압축
    return compressedFile;
  }

  Future<void> _uploadQuestion() async {
    if (mounted) {
      FocusScope.of(context).unfocus();
    }

    final String questionText = _textController.text;
    if (questionText.isEmpty) {
      Get.snackbar('글이나 사진을 추가해주세요.', '글이나 사진을 추가해주세요.');
      return;
    }

    final User? user = FirebaseAuth.instance.currentUser;
    final String uid = user!.uid;

    final pbUrl = dotenv.env['POCKET_BASE_URL'].toString();
    final pb = PocketBase(pbUrl);

    // 이미지 업로드
    final List<http.MultipartFile> images = [];
    for (File image in _images) {
      final File compressedImage = await _compressImage(image);
      images.add(await http.MultipartFile.fromPath('files', compressedImage.path));
    }

    await pb.collection('questions').create(
      body: {
        "key": uid,
        "contents": questionText,
      },
      files: images,
    );

    setState(() {
      _textController.clear();
      _images.clear();
    });

    Get.snackbar('업로드 완료', '업로드 완료');
    homeProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: _pickImageFromCamera,
                    icon: Icon(
                      Icons.camera,
                      size: ICON_SIZE,
                    )),
                IconButton(
                    onPressed: _uploadQuestion,
                    icon: Icon(
                      Icons.create_new_folder_outlined,
                      size: ICON_SIZE,
                    )),
              ],
            ),
            TextField(
              keyboardType: TextInputType.text,
              controller: _textController,
              focusNode: _focusNode,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter your question here...',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Image.file(
                      _images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.remove_circle_outline_rounded, color: Colors.red, size: ICON_SIZE),
                        onPressed: () {
                          setState(() {
                            _images.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

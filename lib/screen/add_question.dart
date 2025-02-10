import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _pickImageFromCamera,
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // 화면을 터치하면 키보드를 내림
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Enter your question here...',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Image.file(
                        _images[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (mounted) {
            FocusScope.of(context).unfocus();
          }
          _uploadQuestion();
        },
        child: Icon(Icons.create_new_folder_outlined),
      ),
    );
  }
}

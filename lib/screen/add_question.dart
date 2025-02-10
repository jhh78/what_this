import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController _titleController = TextEditingController(); // 타이틀 컨트롤러 추가
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
    _titleController.dispose(); // 타이틀 컨트롤러 해제
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromCamera() async {
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
    final String titleText = _titleController.text; // 타이틀 텍스트 추가
    if (questionText.isEmpty && _images.isEmpty) {
      // 글과 사진이 모두 비어있으면 업로드하지 않음
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('글이나 사진을 추가해주세요.')),
      );
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

    // 질문 업로드
    final record = await pb.collection('questions').create(
      body: {
        "key": uid,
        "contents": questionText,
        "title": titleText, // 타이틀 추가
      },
      files: images,
    );

    // 업로드 완료 후 초기화
    setState(() {
      _textController.clear();
      _titleController.clear(); // 타이틀 초기화
      _images.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('업로드 완료')),
    );
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
                  controller: _titleController, // 타이틀 컨트롤러 연결
                  decoration: InputDecoration(
                    hintText: 'Enter your title here...',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                TextField(
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
                ElevatedButton(
                  onPressed: _uploadQuestion,
                  child: Text('작성'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

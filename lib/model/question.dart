import 'package:pocketbase/pocketbase.dart';

class QuestionModel {
  String collectionID;
  String id;
  String key;
  String contents;
  List<String> files;
  String createdAt;
  String updatedAt;

  QuestionModel({
    required this.collectionID,
    required this.id,
    required this.key,
    required this.contents,
    required this.files,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuestionModel.fromRecordModel(RecordModel response) {
    return QuestionModel(
      collectionID: response.get('collectionId'),
      id: response.id,
      key: response.get('key'),
      contents: response.get('contents'),
      files: response.get('files'),
      createdAt: response.get('createdAt'),
      updatedAt: response.get('updatedAt'),
    );
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      collectionID: json['collectionID'],
      id: json['id'],
      key: json['key'],
      contents: json['contents'],
      files: json['files'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'contents': contents,
      'files': files,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

import 'package:pocketbase/pocketbase.dart';
import 'package:whats_this/model/user.dart';
import 'package:whats_this/util/util.dart';

class QuestionModel {
  String collectionID;
  String id;
  UserModel user;
  String contents;
  String files;
  String created;
  String updated;

  QuestionModel({
    required this.collectionID,
    required this.id,
    required this.user,
    required this.contents,
    required this.files,
    required this.created,
    required this.updated,
  });

  factory QuestionModel.emptyModel() {
    return QuestionModel(
      collectionID: '',
      id: '',
      user: UserModel.emptyModel(),
      contents: '',
      files: '',
      created: '',
      updated: '',
    );
  }

  factory QuestionModel.fromRecordModel(RecordModel response) {
    return QuestionModel(
      collectionID: response.collectionId,
      id: response.id,
      user: UserModel.fromJson(response.get('expand')['user']),
      contents: response.get('contents'),
      files: response.get('files'),
      created: response.get('created'),
      updated: response.get('updated'),
    );
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      collectionID: json['collectionID'],
      id: json['id'],
      user: json['user'] ? UserModel.fromJson(json['user']) : UserModel.emptyModel(),
      contents: json['contents'],
      files: json['files'],
      created: json['created'],
      updated: json['updated'],
    );
  }

  void showData() => showLog({
        'collectionID': collectionID,
        'id': id,
        'user': user.toString(),
        'contents': contents,
        'files': files,
        'created': created,
        'updated': updated,
      }, runtimeType);
}

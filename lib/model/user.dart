import 'package:pocketbase/pocketbase.dart';

class UserModel {
  String collectionId;
  String id;
  String username;
  String key;
  String profile;
  int exp;
  String created;
  String updated;

  UserModel({
    required this.collectionId,
    required this.id,
    required this.username,
    required this.key,
    required this.profile,
    required this.exp,
    required this.created,
    required this.updated,
  });

  factory UserModel.emptyModel() {
    return UserModel(
      collectionId: '',
      id: '',
      username: '',
      key: '',
      profile: '',
      exp: 0,
      created: '',
      updated: '',
    );
  }

  factory UserModel.fromRecordModel(RecordModel response) {
    return UserModel(
      collectionId: response.get('collectionId'),
      id: response.id,
      username: response.get('username'),
      key: response.get('key'),
      profile: response.get('profile') ?? '',
      exp: response.get('exp'),
      created: response.get('created'),
      updated: response.get('updated'),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      collectionId: json['collectionId'],
      id: json['id'],
      username: json['username'],
      key: json['key'],
      profile: json['profile'] ?? '',
      exp: json['exp'],
      created: json['created'],
      updated: json['updated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collectionId': collectionId,
      'id': id,
      'username': username,
      'key': key,
      'profile': profile,
      'exp': exp,
      'created': created,
      'updated': updated,
    };
  }
}

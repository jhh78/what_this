import 'package:pocketbase/pocketbase.dart';

class UserModel {
  String collectionID;
  String id;
  String username;
  String email;
  String password;
  String key;
  String profile;
  int exp;
  String createdAt;
  String updatedAt;

  UserModel({
    required this.collectionID,
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.key,
    required this.profile,
    required this.exp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.emptyModel() {
    return UserModel(
      collectionID: '',
      id: '',
      username: '',
      email: '',
      password: '',
      key: '',
      profile: '',
      exp: 0,
      createdAt: '',
      updatedAt: '',
    );
  }

  factory UserModel.fromRecordModel(RecordModel response) {
    return UserModel(
      collectionID: response.get('collectionId'),
      id: response.id,
      username: response.get('username'),
      email: response.get('email'),
      password: response.get('password'),
      key: response.get('key'),
      profile: response.get('profile'),
      exp: response.get('exp'),
      createdAt: response.get('createdAt'),
      updatedAt: response.get('updatedAt'),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      collectionID: json['collectionID'],
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      key: json['key'],
      profile: json['profile'],
      exp: json['exp'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collectionID': collectionID,
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'key': key,
      'profile': profile,
      'exp': exp,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

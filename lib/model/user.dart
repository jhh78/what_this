import 'dart:developer';

import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

class UserModel {
  String collectionId;
  String id;
  String username;
  String email;
  String key;
  String? profile;
  int exp;
  String createdAt;
  String updatedAt;

  UserModel({
    required this.collectionId,
    required this.id,
    required this.username,
    required this.email,
    required this.key,
    required this.profile,
    required this.exp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.emptyModel() {
    return UserModel(
      collectionId: '',
      id: '',
      username: '',
      email: '',
      key: '',
      profile: null,
      exp: 0,
      createdAt: '',
      updatedAt: '',
    );
  }

  factory UserModel.fromRecordModel(RecordModel response) {
    return UserModel(
      collectionId: response.get('collectionId'),
      id: response.id,
      username: response.get('username'),
      email: response.get('email'),
      key: response.get('key'),
      profile: response.get('profile').toString().isEmpty ? null : response.get('profile'),
      exp: response.get('exp'),
      createdAt: response.get('createdAt'),
      updatedAt: response.get('updatedAt'),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    log("UserModel.fromJson ??????????????????? $json");
    return UserModel(
      collectionId: json['collectionId'],
      id: json['id'],
      username: json['username'],
      email: json['email'],
      key: json['key'],
      profile: json['profile'].toString().isEmpty ? null : json['profile'],
      exp: json['exp'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collectionId': collectionId,
      'id': id,
      'username': username,
      'email': email,
      'key': key,
      'profile': profile,
      'exp': exp,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

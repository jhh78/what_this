import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:whats_this/model/system.dart';
import 'package:whats_this/util/constants.dart';

class AuthService {
  // 유저생성
  static void createUser(String email, String passwd) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: passwd,
      );

      // 이메일 확인 메일 보내기
      await credential.user?.sendEmailVerification();

      log("createUser >>>>>> ${credential.user.toString()}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // 이메일 로그인
  static void doEmailLogin(String email, String passwd) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: passwd,
      );

      log("doLogin >>>>>> ${credential.user?.metadata.toString()}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
    }
  }

  // 구글 로그인
  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // 아이폰에서만 작동
  // 애플 로그인
  static Future<UserCredential> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  static bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  static String? getUserUID() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static Future<void> checkInitialized() async {
    Box box = await Hive.openBox(SYSTEM_BOX);
    final SystemConfigModel config = box.get(SYSTEM_CONFIG, defaultValue: SystemConfigModel());

    if (!config.isInit) {
      box.put(SYSTEM_CONFIG, config);
      await signOut();
    }

    config.showData();
  }

  static Future<User?> checkUserStatus() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await currentUser.reload();
        if (currentUser.metadata.creationTime == null) {
          throw FirebaseAuthException(code: 'user-disabled');
        }
      } catch (error) {
        if (error is FirebaseAuthException && error.code == 'user-disabled') {
          log('The user account has been disabled by an administrator.');
          await FirebaseAuth.instance.signOut();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Get.isSnackbarOpen) {
              Get.back();
            }
            Get.snackbar(
              'Error',
              'The user account has been disabled by an administrator.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              margin: EdgeInsets.all(10),
            );
          });
        } else {
          log('Error reloading user: $error');
          await FirebaseAuth.instance.signOut();
        }
      }
    }
    return FirebaseAuth.instance.currentUser;
  }
}

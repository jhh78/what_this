import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:upgrader/upgrader.dart';
import 'package:whats_this/model/system.dart';
import 'package:whats_this/screen/home.dart';
import 'package:whats_this/screen/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whats_this/service/auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (kDebugMode) {
    await Upgrader.clearSavedSettings();
  }

  await Hive.initFlutter();
  Hive.registerAdapter(SystemConfigModelAdapter());
  await AuthService.checkInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    // 사용자가 삭제되었는지 확인하고 로그아웃
    if (currentUser != null) {
      currentUser.reload().then((_) {
        if (currentUser?.metadata.creationTime == null) {
          throw Exception('User has been deleted');
        }
      }).catchError((error) {
        FirebaseAuth.instance.signOut();
        currentUser = null;
        if (error is FirebaseAuthException && error.code == 'user-disabled') {
          Get.snackbar('Error', 'The user account has been disabled by an administrator.',
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white, margin: EdgeInsets.all(10));
        } else {
          log('Error reloading user: $error');
        }

        Get.offAll(() => SignInScreen());
      });
    }

    log("Main Screen :::: ${currentUser.toString()}");
    return GetMaterialApp(
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)), // 텍스트 스케일 팩터 고정
          child: child!,
        );
      },
      home: UpgradeAlert(
        dialogStyle: UpgradeDialogStyle.cupertino,
        child: currentUser != null ? HomeScreen() : SignInScreen(),
      ),
    );
  }
}

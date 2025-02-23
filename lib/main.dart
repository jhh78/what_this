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
import 'package:whats_this/screen/home/home.dart';
import 'package:whats_this/screen/signin/sign_in.dart';
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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: AuthService.checkUserStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          final User? currentUser = snapshot.data;
          log("Main Screen >>>>>> ${currentUser.toString()}");

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
                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
              );
            },
            home: UpgradeAlert(
              dialogStyle: UpgradeDialogStyle.cupertino,
              child: currentUser != null ? HomeScreen() : SignInScreen(),
            ),
          );
        }
      },
    );
  }
}

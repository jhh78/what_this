import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:upgrader/upgrader.dart';
import 'package:whats_this/screen/home/home.dart';
import 'package:whats_this/screen/signin/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whats_this/service/vender/auth.dart';
import 'firebase_options.dart';
import 'service/vender/hive.dart';

// TODO:: 디플로이 준비

// TODO:: 사진업로드가 완료되면 로컬에 저장하고 불러오도록 하기
// TODO:: 유저 데이터 패치할때 사진 데이터는 생략하여 트래픽줄이기

// TODO:: 댓글, 질문 삭제, 블럭시 에니메이션 추가
// TODO:: 글 작성시 엔트리 포인트 조절하기
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
  await HiveService.init();
  await AuthService.checkInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    HiveService.closeBox();
    super.dispose();
  }

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

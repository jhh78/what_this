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

  // 사용자 인증 상태 확인
  final currentUser = await AuthService.checkUserStatus();

  runApp(MyApp(currentUser: currentUser));
}

// TODO: 프로바이더에 들어가있는 서비스 로직 분리하기
// TODO: 테스트 코드 작성하기
// TODO: 리펙토링 하기
class MyApp extends StatelessWidget {
  final User? currentUser;

  const MyApp({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: kDebugMode,
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
        child: currentUser == null ? SignInScreen() : HomeScreen(),
      ),
    );
  }
}

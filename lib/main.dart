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

  runApp(MyApp());
}

// TODO ::: 각 페이지에 대한 리펙토링 시도하기
// TODO ::: 애플 권한 요청창 안나온다.
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

  Future<Widget> renderNextScreen(User? currentUser) async {
    if (currentUser == null) {
      return SignInScreen();
    }

    return HomeScreen();
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
              child: FutureBuilder<Widget>(
                future: renderNextScreen(snapshot.data),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return snapshot.data!;
                },
              ),
            ),
          );
        }
      },
    );
  }
}

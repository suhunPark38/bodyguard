import 'package:bodyguard/providers/diet_provider.dart';
import 'package:bodyguard/providers/today_health_data_provider.dart';
import 'package:bodyguard/providers/shopping_provider.dart';
import 'package:bodyguard/providers/user_info_provider.dart';
import 'package:bodyguard/screens/search_page/search_page.dart';
import 'package:bodyguard/widgets/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'utils/notification.dart';
import 'screens/home_page/my_home_page.dart';
import 'providers/activity_provider.dart';
import 'services/activity_service.dart'; // ActivityProvider import 추가

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Firebase 초기화
  initializeDateFormatting().then((_) => runApp(MyApp()));
  FlutterLocalNotification.init(); // 로컬 알림 초기화
  FlutterLocalNotification.requestNotificationPermission(); //로컬 알림 권한
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => TodayHealthDataProvider()),
          ChangeNotifierProvider(create: (context) => ShoppingProvider()),
          ChangeNotifierProvider(create: (_) => DietProvider()),
          ChangeNotifierProvider(create: (_) => ActivityProvider()),
          ChangeNotifierProvider(create: (context) => UserInfoProvider()),
        ],
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true, //false로 수정시 material2
            fontFamily: "Pretendard",
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              brightness: Brightness.light,
              surface: Colors.white,
            ),
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            fontFamily: "Pretendard",
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              surface: Colors.black,
            ),
          ),
          themeMode: ThemeMode.system,
          //사용자 기기의 설정에 따른 다크 모드 삭제예정
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ko', 'KR'),
          ],
          home: Scaffold(
             body: AuthenticationWrapper(),
          ),
        ));
  }
}




//main실행 후 실행시키는 첫 위젯
class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticationWrapper();
  }
}
//자동 로그인을 위한 클래스
//만약 사용자가 로그아웃을 하면 첫 로그인 페이지로 다시 돌아감
//앱이 종료 후 실행해도 자동 로그인 가능
class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print('Connection State: ${snapshot.connectionState}');
        print('Has data: ${snapshot.hasData}');
        print('Data: ${snapshot.data}');
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const MyHomePage();
          }
          return const Login();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

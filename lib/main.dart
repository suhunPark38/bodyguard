import 'package:bodyguard/providers/diet_provider.dart';
import 'package:bodyguard/providers/health_data_provider.dart';
import 'package:bodyguard/providers/today_health_data_provider.dart';
import 'package:bodyguard/providers/shopping_provider.dart';
import 'package:bodyguard/utils/health_util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:health/health.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'utils/notification.dart';
import 'screens/home_page/my_home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );// Firebase 초기화

  // health connect 사용 설정
  Health().configure(useHealthConnectIfAvailable: true);

  // google health connect 연동을 위한 권한 확인 && app 설치 여부 확인
  HealthUtil().authorize();
  HealthUtil().installHealthConnect();

  initializeDateFormatting().then((_) => runApp(
    const MyApp()
  ));


  FlutterLocalNotification.init(); // 로컬 알림 초기화
  FlutterLocalNotification.requestNotificationPermission(); //로컬 알림 권한
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TodayHealthDataProvider()),
          ChangeNotifierProvider(create: (context) => ShoppingProvider()),
          ChangeNotifierProvider(create: (_) => DietProvider()),
          ChangeNotifierProvider(create: (_) => HealthDataProvider()),
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
          home: const MyHomePage(),
        )
    );
  }
}



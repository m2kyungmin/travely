import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'config/theme.dart';
import 'config/constants.dart';
import 'providers/test_provider.dart';
import 'services/ad_service.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/test_screen.dart';
import 'screens/result_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase 초기화 오류: $e');
    // Firebase 초기화 실패해도 앱은 계속 실행 (오프라인 모드)
  }

  // AdMob 초기화
  try {
    await AdService.initialize();
  } catch (e) {
    debugPrint('AdMob 초기화 오류: $e');
    // 광고 초기화 실패해도 앱은 계속 실행
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TestProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        // 에러 위젯 커스터마이징 (디버깅용)
        builder: (context, child) {
          // 에러 발생 시 빨간 배경으로 표시
          ErrorWidget.builder = (FlutterErrorDetails details) {
            debugPrint('🚨 Flutter 에러 발생: ${details.exception}');
            debugPrint('스택: ${details.stack}');
            return Scaffold(
              backgroundColor: Colors.red.shade100,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('에러가 발생했습니다', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('${details.exception}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                        },
                        child: const Text('홈으로 돌아가기'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          };
          return child ?? const SizedBox.shrink();
        },
        // 라우팅 설정
        // 웹에서 URL 해시 라우팅을 무시하고 항상 스플래시 화면부터 시작
        initialRoute: '/',
        // 초기 라우트 생성자: 웹에서 URL 해시를 무시하고 항상 스플래시 화면으로
        onGenerateInitialRoutes: (String initialRouteName) {
          return [
            MaterialPageRoute(
              builder: (_) => const SplashScreen(),
              settings: const RouteSettings(name: '/'),
            ),
          ];
        },
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/test': (context) => const TestScreen(),
          '/loading': (context) {
            // LoadingScreen은 동적 데이터가 필요하므로 직접 생성하지 않음
            // TestScreen에서 직접 네비게이션
            return const HomeScreen();
          },
        },
        // 커스텀 라우트 생성자 (동적 파라미터가 필요한 화면용)
        onGenerateRoute: (settings) {
          // ResultScreen은 동적 파라미터가 필요하므로 여기서 처리
          if (settings.name == '/result') {
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null) {
              return MaterialPageRoute(
                builder: (_) => ResultScreen(
                  result: args['result'],
                  travelType: args['travelType'],
                ),
              );
            }
          }
          return null;
        },
        // 404 에러 처리
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
                    const SizedBox(height: 16),
                    const Text('페이지를 찾을 수 없습니다.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home',
                          (route) => false,
                        );
                      },
                      child: const Text('홈으로 돌아가기'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

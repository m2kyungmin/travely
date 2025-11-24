import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../config/theme.dart';
import '../config/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 웹에서 URL 해시 라우팅 무시: 현재 라우트를 확인하고 홈으로 리셋
    if (kIsWeb) {
      // 웹에서는 URL 해시를 무시하고 항상 홈으로 이동
      // 기존 라우트 스택을 모두 제거하고 홈으로 이동
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/home',
            (route) => false,
          );
        }
      });
    }

    // 2초 후 홈 화면으로 이동 (웹이 아닌 경우 또는 추가 보장)
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // 웹이 아닌 경우에만 pushReplacementNamed 사용
      // 웹인 경우 이미 위에서 처리했으므로 중복 방지
      if (!kIsWeb) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // 웹인 경우에도 확실하게 홈으로 이동 (이미 이동했을 수 있지만 보장)
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/home',
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고 이미지 영역
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: AppTheme.borderRadiusXLarge,
                boxShadow: AppTheme.buttonShadow,
              ),
              child: const Icon(
                Icons.flight_takeoff,
                size: 60,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppConstants.appName,
              style: AppTheme.heading1.copyWith(
                color: AppTheme.primaryColor,
                fontSize: 36,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppConstants.appTagline,
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}


import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/test_result.dart';
import '../services/firebase_service.dart';
import '../services/test_calculator.dart';
import '../services/ad_service.dart';
import '../config/constants.dart';
import '../config/theme.dart';

class LoadingScreen extends StatefulWidget {
  final List<Question> questions;
  final List<String> answers;

  const LoadingScreen({
    super.key,
    required this.questions,
    required this.answers,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseService _firebaseService = FirebaseService();
  final TestCalculator _calculator = TestCalculator();

  Timer? _textTimer;
  int _currentTextIndex = 0;
  bool _hasError = false;
  String? _errorMessage;

  // 변경되는 서브 텍스트 리스트
  final List<String> _subTexts = [
    '여행 리듬을 파악하는 중...',
    '선호하는 여행 스타일 분석 중...',
    '완벽한 여행지를 찾는 중...',
    '거의 다 됐어요!',
  ];

  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startTextRotation();
    _processResult();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  void _startTextRotation() {
    _textTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTextIndex = (_currentTextIndex + 1) % _subTexts.length;
        });
      }
    });
  }

  Future<void> _processResult() async {
    try {
      // 최소 3초 대기 (UX를 위해)
      final minWaitFuture = Future.delayed(const Duration(seconds: 3));

      // 모든 답변을 calculator에 추가
      for (int i = 0; i < widget.answers.length; i++) {
        if (widget.answers[i].isNotEmpty) {
          _calculator.addAnswer(i, widget.answers[i]);
        }
      }

      // 결과 계산
      final typeCode = _calculator.calculateResult();
      final scoreBreakdown = _calculator.getScoreBreakdown();

      final result = TestResult(
        rhythmScore: scoreBreakdown[AppConstants.axisRhythm] ?? {},
        energyScore: scoreBreakdown[AppConstants.axisEnergy] ?? {},
        budgetScore: scoreBreakdown[AppConstants.axisBudget] ?? {},
        conceptScore: scoreBreakdown[AppConstants.axisConcept] ?? {},
        finalType: typeCode,
        completedAt: DateTime.now(),
      );

      // Firestore에 통계 저장 (비동기, 에러 무시)
      _firebaseService.saveTestResult(typeCode).catchError((e) {
        debugPrint('통계 저장 오류: $e');
      });

      // 로컬에 저장
      await _firebaseService.saveLastResult(result);

      // 유형 정보 가져오기
      debugPrint('결과 유형 코드: ${result.finalType}');
      final travelType = await _firebaseService.getTravelType(result.finalType);
      debugPrint('가져온 유형 정보: ${travelType?.code ?? "null"}');
      
      if (travelType == null) {
        debugPrint('⚠️ 유형 정보를 가져오지 못했습니다. 유형 코드: ${result.finalType}');
        debugPrint('Firestore의 types 컬렉션에 해당 유형이 있는지 확인하세요.');
      }

      // 최소 대기 시간 확보
      await minWaitFuture;

      // 전면 광고 표시 여부 확인 (3회마다 1회)
      final shouldShowAd = await AdService().shouldShowInterstitialAd();

      if (mounted) {
        if (shouldShowAd) {
          // 전면 광고 표시
          AdService().loadInterstitialAd(
            onAdDismissed: () {
              // 광고 닫힌 후 결과 화면으로 이동
              if (mounted) {
                Navigator.of(context).pushReplacementNamed(
                  '/result',
                  arguments: {
                    'result': result,
                    'travelType': travelType,
                  },
                );
              }
            },
            onAdFailedToLoad: (_) {
              // 광고 로드 실패 시 바로 결과 화면으로 이동
              if (mounted) {
                Navigator.of(context).pushReplacementNamed(
                  '/result',
                  arguments: {
                    'result': result,
                    'travelType': travelType,
                  },
                );
              }
            },
          );
        } else {
          // 광고 표시 안 함, 바로 결과 화면으로 이동
          Navigator.of(context).pushReplacementNamed(
            '/result',
            arguments: {
              'result': result,
              'travelType': travelType,
            },
          );
        }
      }
    } catch (e) {
      debugPrint('결과 처리 오류: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = '결과를 불러오는 중 오류가 발생했습니다.\n다시 시도해주세요.';
        });
      }
    }
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _currentTextIndex = 0;
    });
    _processResult();
  }

  @override
  void dispose() {
    _textTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              AppTheme.backgroundColor,
              AppTheme.primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: _hasError ? _buildErrorWidget() : _buildLoadingWidget(),
          ),
        ),
      ),
    );
  }

  /// 로딩 위젯
  Widget _buildLoadingWidget() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 커스텀 로딩 애니메이션 (비행기 아이콘 회전)
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.flight_takeoff,
                    size: 60,
                    color: AppTheme.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 48),
          // 메인 텍스트
          Text(
            '당신의 여행 성향을\n분석하고 있어요...',
            textAlign: TextAlign.center,
            style: AppTheme.heading2.copyWith(
              fontSize: 24,
              color: AppTheme.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          // 변경되는 서브 텍스트
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              _subTexts[_currentTextIndex],
              key: ValueKey(_currentTextIndex),
              textAlign: TextAlign.center,
              style: AppTheme.bodyMedium.copyWith(
                fontSize: 16,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 48),
          // 프로그레스 인디케이터
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }

  /// 에러 위젯
  Widget _buildErrorWidget() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: AppTheme.errorColor),
          const SizedBox(height: 24),
          Text(
            '오류가 발생했습니다',
            style: AppTheme.heading3.copyWith(color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? '알 수 없는 오류가 발생했습니다.',
            textAlign: TextAlign.center,
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _retry,
            icon: const Icon(Icons.refresh),
            label: const Text('다시 시도'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: AppTheme.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.borderRadiusMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

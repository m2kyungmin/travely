import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../providers/test_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadLastResult();
  }

  void _initAnimations() {
    // 페이드인 애니메이션
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // 펄스 애니메이션 (버튼용)
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);
    _animationController.forward();
  }

  void _loadLastResult() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TestProvider>();
      provider.loadLastResult();
    });
  }

  void _startTest() {
    // 테스트 초기화
    final provider = context.read<TestProvider>();
    provider.resetTest();
    
    Navigator.of(context).pushNamed('/test').then((_) {
      // 테스트 완료 후 결과가 있을 수 있으므로 다시 로드
      provider.loadLastResult();
    });
  }

  void _viewLastResult() async {
    final provider = context.read<TestProvider>();
    final lastResult = provider.lastResult;
    if (lastResult != null) {
      // 유형 정보 로드
      await provider.loadTravelType(lastResult.finalType);
      
      Navigator.of(context).pushNamed(
        '/result',
        arguments: {
          'result': lastResult,
          'travelType': provider.currentTravelType,
        },
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // 상단 영역 (40%)
              Expanded(
                flex: 4,
                child: _buildTopSection(),
              ),
              // 중앙 영역 (30%)
              Expanded(
                flex: 3,
                child: _buildMiddleSection(),
              ),
              // 하단 영역 (30%)
              Expanded(
                flex: 3,
                child: _buildBottomSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 상단 영역: 로고, 타이틀, 일러스트
  Widget _buildTopSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 로고/아이콘
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
          // 앱 타이틀
          Text(
            AppConstants.appName,
            style: AppTheme.heading1.copyWith(
              color: AppTheme.primaryColor,
              fontSize: 40,
            ),
          ),
          const SizedBox(height: 8),
          // 서브 타이틀
          Text(
            '나만의 여행 성향을 찾아보세요',
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.textSecondary,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  /// 중앙 영역: 설명 텍스트
  Widget _buildMiddleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: AppTheme.borderRadiusLarge,
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              children: [
                Text(
                  '16개 질문으로 알아보는\n나의 여행 MBTI',
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyMedium.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '소요시간: 약 2분',
                      style: AppTheme.bodySmall.copyWith(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 하단 영역: 버튼들
  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 테스트 시작 버튼 (펄스 애니메이션)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: child,
              );
            },
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _startTest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: AppTheme.white,
                  elevation: 4,
                  shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.borderRadiusMedium,
                  ),
                ),
                child: Text(
                  '테스트 시작하기',
                  style: AppTheme.buttonLarge,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 이전 결과 보기 버튼
          Consumer<TestProvider>(
            builder: (context, provider, child) {
              final hasLastResult = provider.lastResult != null;
              
              if (!hasLastResult) {
                return const SizedBox.shrink();
              }

              return TextButton(
                onPressed: _viewLastResult,
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 18,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '이전 결과 보기',
                      style: AppTheme.buttonMedium.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

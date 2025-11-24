import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/test_provider.dart';
import 'loading_screen.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TestProvider>();
      if (!provider.hasQuestions) {
        provider.loadQuestions().then((_) {
          // 질문 로드 후 첫 페이지로 이동
          if (mounted && _pageController.hasClients) {
            _pageController.jumpToPage(0);
          }
        });
      } else {
        // 이미 질문이 있으면 현재 인덱스로 이동
        if (mounted && _pageController.hasClients) {
          _pageController.jumpToPage(provider.currentQuestionIndex);
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectAnswer(String answer) {
    final provider = context.read<TestProvider>();
    
    // 답변 저장
    provider.selectAnswer(answer);

    // 마지막 질문이면 로딩 화면으로 이동
    if (provider.currentQuestionIndex == provider.questions.length - 1) {
      _completeTest();
    } else {
      // 0.3초 딜레이 후 다음 질문으로
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _pageController.hasClients) {
          provider.nextQuestion();
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _previousQuestion() {
    final provider = context.read<TestProvider>();
    if (provider.currentQuestionIndex > 0) {
      provider.previousQuestion();
      if (_pageController.hasClients) {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _completeTest() {
    final provider = context.read<TestProvider>();
    final questions = provider.questions;
    final answers = provider.answers;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LoadingScreen(
          questions: questions,
          answers: answers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: Consumer<TestProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!provider.hasQuestions) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
                  const SizedBox(height: 16),
                  Text(
                    '질문을 불러올 수 없습니다.',
                    style: AppTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => provider.loadQuestions(),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // 진행률 바
              _buildProgressBar(provider),
              // 질문 영역
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.questions.length,
                  itemBuilder: (context, index) {
                    return _buildQuestionPage(provider, index);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 앱바 구성
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.white,
      elevation: 0,
      leading: Consumer<TestProvider>(
        builder: (context, provider, child) {
          if (provider.currentQuestionIndex > 0) {
            return IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
              onPressed: _previousQuestion,
            );
          } else {
            return IconButton(
              icon: const Icon(Icons.close, color: AppTheme.textPrimary),
              onPressed: () => Navigator.of(context).pop(),
            );
          }
        },
      ),
      title: Consumer<TestProvider>(
        builder: (context, provider, child) {
          return Text(
            '${provider.currentQuestionIndex + 1}/${provider.questions.length}',
            style: AppTheme.heading3.copyWith(
              fontSize: 18,
              color: AppTheme.textPrimary,
            ),
          );
        },
      ),
      centerTitle: true,
    );
  }

  /// 진행률 바
  Widget _buildProgressBar(TestProvider provider) {
    return Container(
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: LinearProgressIndicator(
        value: provider.progress,
        backgroundColor: Colors.grey.shade200,
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        minHeight: 4,
      ),
    );
  }

  /// 질문 페이지 구성
  Widget _buildQuestionPage(TestProvider provider, int index) {
    final question = provider.questions[index];
    final currentAnswer = provider.answers[index];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      child: Padding(
        key: ValueKey(index),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 질문 번호
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: AppTheme.borderRadiusSmall,
              ),
              child: Text(
                '질문 ${index + 1}',
                style: AppTheme.caption.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // 질문 텍스트
            Text(
              question.text,
              textAlign: TextAlign.center,
              style: AppTheme.heading2.copyWith(
                fontSize: 26,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            // 선택지 A
            _buildAnswerButton(
              text: question.optionA,
              answer: 'A',
              isSelected: currentAnswer == 'A',
              onTap: () => _selectAnswer('A'),
            ),
            const SizedBox(height: 16),
            // 선택지 B
            _buildAnswerButton(
              text: question.optionB,
              answer: 'B',
              isSelected: currentAnswer == 'B',
              onTap: () => _selectAnswer('B'),
            ),
          ],
        ),
      ),
    );
  }

  /// 선택지 버튼 구성
  Widget _buildAnswerButton({
    required String text,
    required String answer,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.borderRadiusMedium,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : AppTheme.white,
            borderRadius: AppTheme.borderRadiusMedium,
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryColor
                  : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: isSelected
                ? AppTheme.buttonShadow
                : AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              // 선택 표시 원
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppTheme.white
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.white
                        : AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: AppTheme.primaryColor,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              // 선택지 텍스트
              Expanded(
                child: Text(
                  text,
                  style: AppTheme.bodyMedium.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppTheme.white
                        : AppTheme.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import '../models/question.dart';
import '../models/travel_type.dart';
import '../models/test_result.dart';
import '../services/firebase_service.dart';
import '../services/test_calculator.dart';
import '../config/constants.dart';

class TestProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final TestCalculator _calculator = TestCalculator();

  // 상태
  List<Question> _questions = [];
  List<String> _answers = [];
  int _currentQuestionIndex = 0;
  bool _isLoading = false;
  TestResult? _currentResult;
  TravelType? _currentTravelType;
  TestResult? _lastResult;

  // Getters
  List<Question> get questions => _questions;
  List<String> get answers => _answers;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isLoading => _isLoading;
  TestResult? get currentResult => _currentResult;
  TravelType? get currentTravelType => _currentTravelType;
  TestResult? get lastResult => _lastResult;

  bool get hasQuestions => _questions.isNotEmpty;
  bool get isTestComplete =>
      _answers.length == _questions.length &&
      _answers.every((answer) => answer.isNotEmpty);
  double get progress => _questions.isEmpty
      ? 0.0
      : (_currentQuestionIndex + 1) / _questions.length;
  Question? get currentQuestion => _currentQuestionIndex < _questions.length
      ? _questions[_currentQuestionIndex]
      : null;

  // 질문 목록 로드
  Future<void> loadQuestions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _questions = await _firebaseService.getQuestions();

      // Firestore에 데이터가 없으면 빈 리스트
      if (_questions.isEmpty) {
        debugPrint('질문 데이터가 없습니다. Firestore에 데이터를 추가해주세요.');
      }

      _answers = List.filled(_questions.length, '');
      _currentQuestionIndex = 0;
    } catch (e) {
      debugPrint('질문 로드 오류: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 답변 선택
  void selectAnswer(String answer) {
    if (_currentQuestionIndex < _answers.length) {
      _answers[_currentQuestionIndex] = answer;
      // TestCalculator에도 답변 추가
      _calculator.addAnswer(_currentQuestionIndex, answer);
      notifyListeners();
    }
  }

  // 다음 질문으로 이동
  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  // 이전 질문으로 이동
  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  // 특정 질문으로 이동
  void goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  // 테스트 초기화
  void resetTest() {
    _answers = List.filled(_questions.length, '');
    _currentQuestionIndex = 0;
    _currentResult = null;
    _currentTravelType = null;
    _calculator.reset();
    notifyListeners();
  }

  // 테스트 결과 계산
  Future<TestResult> calculateResult() async {
    if (!isTestComplete) {
      throw Exception('모든 질문에 답변하지 않았습니다.');
    }

    // TestCalculator에서 최종 유형 코드 계산
    final typeCode = _calculator.calculateResult();

    // 점수 상세 정보 가져오기
    final scoreBreakdown = _calculator.getScoreBreakdown();

    final result = TestResult(
      rhythmScore: scoreBreakdown[AppConstants.axisRhythm] ?? {},
      energyScore: scoreBreakdown[AppConstants.axisEnergy] ?? {},
      budgetScore: scoreBreakdown[AppConstants.axisBudget] ?? {},
      conceptScore: scoreBreakdown[AppConstants.axisConcept] ?? {},
      finalType: typeCode,
      completedAt: DateTime.now(),
    );

    _currentResult = result;

    // Firestore에 통계 저장
    await _firebaseService.saveTestResult(typeCode);

    // 로컬에 저장
    await _firebaseService.saveLastResult(result);

    // 유형 정보 로드
    await loadTravelType(typeCode);

    notifyListeners();
    return result;
  }

  // 유형 정보 로드
  Future<void> loadTravelType(String typeCode) async {
    try {
      _currentTravelType = await _firebaseService.getTravelType(typeCode);
      notifyListeners();
    } catch (e) {
      debugPrint('유형 정보 로드 오류: $e');
    }
  }

  // 마지막 결과 로드
  Future<void> loadLastResult() async {
    try {
      _lastResult = await _firebaseService.getLastResult();
      notifyListeners();
    } catch (e) {
      debugPrint('마지막 결과 로드 오류: $e');
    }
  }
}

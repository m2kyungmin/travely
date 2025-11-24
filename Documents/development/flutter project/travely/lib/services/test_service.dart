import '../models/question.dart';
import '../models/travel_type.dart';
import '../models/test_result.dart';
import '../services/firebase_service.dart';
import '../services/test_calculator.dart';
import '../config/constants.dart';

/// 테스트 서비스 (레거시 - firebase_service.dart 사용 권장)
@Deprecated('firebase_service.dart와 test_calculator.dart를 직접 사용하세요')
class TestService {
  final FirebaseService _firebaseService = FirebaseService();

  // 질문 목록 가져오기
  Future<List<Question>> getQuestions() async {
    return await _firebaseService.getQuestions();
  }

  // 테스트 결과 계산 및 저장
  Future<TestResult> calculateAndSaveResult(
    List<Question> questions,
    List<String> answers,
  ) async {
    final calculator = TestCalculator();

    // 모든 답변을 calculator에 추가
    for (int i = 0; i < answers.length; i++) {
      if (answers[i].isNotEmpty) {
        calculator.addAnswer(i, answers[i]);
      }
    }

    // 유형 계산
    final typeCode = calculator.calculateResult();

    // 점수 계산
    final scoreBreakdown = calculator.getScoreBreakdown();

    // 결과 생성
    final result = TestResult(
      rhythmScore: scoreBreakdown[AppConstants.axisRhythm] ?? {},
      energyScore: scoreBreakdown[AppConstants.axisEnergy] ?? {},
      budgetScore: scoreBreakdown[AppConstants.axisBudget] ?? {},
      conceptScore: scoreBreakdown[AppConstants.axisConcept] ?? {},
      finalType: typeCode,
      completedAt: DateTime.now(),
    );

    // 로컬 저장
    await _firebaseService.saveLastResult(result);

    // Firestore 통계 저장
    await _firebaseService.saveTestResult(typeCode);

    return result;
  }

  // 유형 정보 가져오기
  Future<TravelType?> getTravelType(String typeCode) async {
    return await _firebaseService.getTravelType(typeCode);
  }

  // 마지막 결과 가져오기
  Future<TestResult?> getLastResult() async {
    return await _firebaseService.getLastResult();
  }
}

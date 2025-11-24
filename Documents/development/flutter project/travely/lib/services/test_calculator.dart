import 'package:flutter/foundation.dart';
import '../config/constants.dart';

/// 여행 MBTI 테스트 점수 계산 서비스
/// ChangeNotifier를 상속하여 Provider와 함께 사용 가능
class TestCalculator extends ChangeNotifier {
  // 축별 문항 인덱스 매핑 (0부터 시작)
  static const List<int> _rhythmQuestionIndices = [0, 1, 9, 10, 13]; // Q1, Q2, Q10, Q11, Q14
  static const List<int> _energyQuestionIndices = [2, 3, 8, 12, 15]; // Q3, Q4, Q9, Q13, Q16
  static const List<int> _budgetQuestionIndices = [4, 5, 6, 7, 14]; // Q5, Q6, Q7, Q8, Q15
  static const List<int> _conceptQuestionIndices = [11]; // Q12

  // 답변 저장 (인덱스: 답변)
  final Map<int, String> _answers = {};

  // 각 축별 점수
  Map<String, int> _rhythmScore = {
    AppConstants.scoreSpontaneous: 0,
    AppConstants.scorePlanner: 0,
  };
  Map<String, int> _energyScore = {
    AppConstants.scoreActive: 0,
    AppConstants.scoreRest: 0,
  };
  Map<String, int> _budgetScore = {
    AppConstants.scoreBudget: 0,
    AppConstants.scoreLuxury: 0,
  };
  Map<String, int> _conceptScore = {
    AppConstants.scoreNature: 0,
    AppConstants.scoreCity: 0,
  };

  // Getters
  Map<int, String> get answers => Map.unmodifiable(_answers);
  Map<String, int> get rhythmScore => Map.unmodifiable(_rhythmScore);
  Map<String, int> get energyScore => Map.unmodifiable(_energyScore);
  Map<String, int> get budgetScore => Map.unmodifiable(_budgetScore);
  Map<String, int> get conceptScore => Map.unmodifiable(_conceptScore);

  /// 답변 추가
  /// [questionIndex] 질문 인덱스 (0부터 시작)
  /// [answer] 답변 ('A' 또는 'B')
  void addAnswer(int questionIndex, String answer) {
    if (questionIndex < 0 || questionIndex >= AppConstants.totalQuestions) {
      throw ArgumentError('질문 인덱스는 0부터 ${AppConstants.totalQuestions - 1} 사이여야 합니다.');
    }

    if (answer != 'A' && answer != 'B') {
      throw ArgumentError('답변은 "A" 또는 "B"여야 합니다.');
    }

    // 기존 답변이 있으면 해당 점수에서 제거
    if (_answers.containsKey(questionIndex)) {
      _removeAnswerFromScore(questionIndex, _answers[questionIndex]!);
    }

    // 새 답변 저장
    _answers[questionIndex] = answer;

    // 점수에 반영
    _addAnswerToScore(questionIndex, answer);

    notifyListeners();
  }

  /// 답변을 점수에 추가
  void _addAnswerToScore(int questionIndex, String answer) {
    // rhythm 축
    if (_rhythmQuestionIndices.contains(questionIndex)) {
      if (answer == 'A') {
        _rhythmScore[AppConstants.scoreSpontaneous] =
            (_rhythmScore[AppConstants.scoreSpontaneous] ?? 0) + 1;
      } else {
        _rhythmScore[AppConstants.scorePlanner] =
            (_rhythmScore[AppConstants.scorePlanner] ?? 0) + 1;
      }
    }
    // energy 축
    else if (_energyQuestionIndices.contains(questionIndex)) {
      if (answer == 'A') {
        _energyScore[AppConstants.scoreActive] =
            (_energyScore[AppConstants.scoreActive] ?? 0) + 1;
      } else {
        _energyScore[AppConstants.scoreRest] =
            (_energyScore[AppConstants.scoreRest] ?? 0) + 1;
      }
    }
    // budget 축
    else if (_budgetQuestionIndices.contains(questionIndex)) {
      if (answer == 'A') {
        _budgetScore[AppConstants.scoreBudget] =
            (_budgetScore[AppConstants.scoreBudget] ?? 0) + 1;
      } else {
        _budgetScore[AppConstants.scoreLuxury] =
            (_budgetScore[AppConstants.scoreLuxury] ?? 0) + 1;
      }
    }
    // concept 축
    else if (_conceptQuestionIndices.contains(questionIndex)) {
      if (answer == 'A') {
        _conceptScore[AppConstants.scoreNature] =
            (_conceptScore[AppConstants.scoreNature] ?? 0) + 1;
      } else {
        _conceptScore[AppConstants.scoreCity] =
            (_conceptScore[AppConstants.scoreCity] ?? 0) + 1;
      }
    }
  }

  /// 답변을 점수에서 제거
  void _removeAnswerFromScore(int questionIndex, String answer) {
    // rhythm 축
    if (_rhythmQuestionIndices.contains(questionIndex)) {
      if (answer == 'A') {
        _rhythmScore[AppConstants.scoreSpontaneous] =
            (_rhythmScore[AppConstants.scoreSpontaneous] ?? 0) - 1;
      } else {
        _rhythmScore[AppConstants.scorePlanner] =
            (_rhythmScore[AppConstants.scorePlanner] ?? 0) - 1;
      }
    }
    // energy 축
    else if (_energyQuestionIndices.contains(questionIndex)) {
      if (answer == 'A') {
        _energyScore[AppConstants.scoreActive] =
            (_energyScore[AppConstants.scoreActive] ?? 0) - 1;
      } else {
        _energyScore[AppConstants.scoreRest] =
            (_energyScore[AppConstants.scoreRest] ?? 0) - 1;
      }
    }
    // budget 축
    else if (_budgetQuestionIndices.contains(questionIndex)) {
      if (answer == 'A') {
        _budgetScore[AppConstants.scoreBudget] =
            (_budgetScore[AppConstants.scoreBudget] ?? 0) - 1;
      } else {
        _budgetScore[AppConstants.scoreLuxury] =
            (_budgetScore[AppConstants.scoreLuxury] ?? 0) - 1;
      }
    }
    // concept 축
    else if (_conceptQuestionIndices.contains(questionIndex)) {
      if (answer == 'A') {
        _conceptScore[AppConstants.scoreNature] =
            (_conceptScore[AppConstants.scoreNature] ?? 0) - 1;
      } else {
        _conceptScore[AppConstants.scoreCity] =
            (_conceptScore[AppConstants.scoreCity] ?? 0) - 1;
      }
    }
  }

  /// 최종 유형 코드 계산 및 반환
  /// 반환값: 유형 코드 (예: "SABN")
  String calculateResult() {
    // rhythm: S vs P
    final rhythmType = _rhythmScore[AppConstants.scoreSpontaneous]! >=
            _rhythmScore[AppConstants.scorePlanner]!
        ? AppConstants.scoreSpontaneous
        : AppConstants.scorePlanner;

    // energy: A vs R
    final energyType = _energyScore[AppConstants.scoreActive]! >=
            _energyScore[AppConstants.scoreRest]!
        ? AppConstants.scoreActive
        : AppConstants.scoreRest;

    // budget: B vs L
    final budgetType = _budgetScore[AppConstants.scoreBudget]! >=
            _budgetScore[AppConstants.scoreLuxury]!
        ? AppConstants.scoreBudget
        : AppConstants.scoreLuxury;

    // concept: N vs C
    final conceptType = _conceptScore[AppConstants.scoreNature]! >=
            _conceptScore[AppConstants.scoreCity]!
        ? AppConstants.scoreNature
        : AppConstants.scoreCity;

    // 최종 유형 코드 생성
    return '$rhythmType$energyType$budgetType$conceptType';
  }

  /// 각 축별 점수 상세 반환
  /// 반환값: Map<축이름, Map<성향코드, 점수>>
  Map<String, Map<String, int>> getScoreBreakdown() {
    return {
      AppConstants.axisRhythm: Map.from(_rhythmScore),
      AppConstants.axisEnergy: Map.from(_energyScore),
      AppConstants.axisBudget: Map.from(_budgetScore),
      AppConstants.axisConcept: Map.from(_conceptScore),
    };
  }

  /// 테스트 초기화
  void reset() {
    _answers.clear();
    _rhythmScore = {
      AppConstants.scoreSpontaneous: 0,
      AppConstants.scorePlanner: 0,
    };
    _energyScore = {
      AppConstants.scoreActive: 0,
      AppConstants.scoreRest: 0,
    };
    _budgetScore = {
      AppConstants.scoreBudget: 0,
      AppConstants.scoreLuxury: 0,
    };
    _conceptScore = {
      AppConstants.scoreNature: 0,
      AppConstants.scoreCity: 0,
    };
    notifyListeners();
  }

  /// 모든 질문에 답변했는지 확인
  bool get isComplete {
    return _answers.length == AppConstants.totalQuestions;
  }

  /// 진행률 (0.0 ~ 1.0)
  double get progress {
    return _answers.length / AppConstants.totalQuestions;
  }

  /// 특정 질문에 답변했는지 확인
  bool hasAnswer(int questionIndex) {
    return _answers.containsKey(questionIndex);
  }

  /// 특정 질문의 답변 가져오기
  String? getAnswer(int questionIndex) {
    return _answers[questionIndex];
  }
}

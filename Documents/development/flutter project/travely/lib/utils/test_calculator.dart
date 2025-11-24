import '../models/question.dart';

class TestCalculator {
  // 각 축별로 A/B 선택 횟수를 집계하여 최종 유형 결정
  // 이 메서드는 사용하지 않음 (calculateTypeFromQuestions 사용)
  // @deprecated
  static String calculateType(List<Map<String, String>> answers) {
    // 이 메서드는 사용하지 않으므로 기본값 반환
    return 'SABN';
  }

  // Question 리스트와 답변 리스트를 받아서 최종 유형 계산
  static String calculateTypeFromQuestions(
    List<Question> questions,
    List<String> answers, // 'A' 또는 'B'
  ) {
    if (questions.length != answers.length) {
      throw Exception('질문과 답변의 개수가 일치하지 않습니다.');
    }

    // 각 축별 점수 집계
    Map<String, Map<String, int>> axisScores = {
      'rhythm': {'S': 0, 'P': 0},
      'energy': {'A': 0, 'R': 0},
      'budget': {'B': 0, 'L': 0},
      'concept': {'N': 0, 'C': 0},
    };

    // 각 질문의 답변을 해당 축에 반영
    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final answer = answers[i];
      
      if (answer == 'A') {
        axisScores[question.axis]![question.scoreA] =
            (axisScores[question.axis]![question.scoreA] ?? 0) + 1;
      } else if (answer == 'B') {
        axisScores[question.axis]![question.scoreB] =
            (axisScores[question.axis]![question.scoreB] ?? 0) + 1;
      }
    }

    // 각 축별로 더 많은 점수를 받은 성향 선택
    // 동점일 경우 A 우선
    String rhythm = axisScores['rhythm']!['S']! >= axisScores['rhythm']!['P']! ? 'S' : 'P';
    String energy = axisScores['energy']!['A']! >= axisScores['energy']!['R']! ? 'A' : 'R';
    String budget = axisScores['budget']!['B']! >= axisScores['budget']!['L']! ? 'B' : 'L';
    String concept = axisScores['concept']!['N']! >= axisScores['concept']!['C']! ? 'N' : 'C';

    // 최종 유형 코드 생성 (예: SABN)
    return '$rhythm$energy$budget$concept';
  }

  // 점수 맵 반환 (결과 화면에서 사용)
  static Map<String, int> getScores(
    List<Question> questions,
    List<String> answers,
  ) {
    Map<String, int> scores = {
      'S': 0, 'P': 0,
      'A': 0, 'R': 0,
      'B': 0, 'L': 0,
      'N': 0, 'C': 0,
    };

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final answer = answers[i];
      
      if (answer == 'A') {
        scores[question.scoreA] = (scores[question.scoreA] ?? 0) + 1;
      } else if (answer == 'B') {
        scores[question.scoreB] = (scores[question.scoreB] ?? 0) + 1;
      }
    }

    return scores;
  }
}


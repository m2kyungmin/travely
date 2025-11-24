import 'package:cloud_firestore/cloud_firestore.dart';

class TestResult {
  final Map<String, int> rhythmScore; // {"S": 3, "P": 2}
  final Map<String, int> energyScore; // {"A": 4, "R": 1}
  final Map<String, int> budgetScore; // {"B": 2, "L": 3}
  final Map<String, int> conceptScore; // {"N": 3, "C": 2}
  final String finalType; // 예: "SABN"
  final DateTime completedAt;

  TestResult({
    required this.rhythmScore,
    required this.energyScore,
    required this.budgetScore,
    required this.conceptScore,
    required this.finalType,
    DateTime? completedAt,
  }) : completedAt = completedAt ?? DateTime.now();

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'rhythmScore': rhythmScore,
      'energyScore': energyScore,
      'budgetScore': budgetScore,
      'conceptScore': conceptScore,
      'finalType': finalType,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      rhythmScore: Map<String, int>.from(json['rhythmScore'] ?? {}),
      energyScore: Map<String, int>.from(json['energyScore'] ?? {}),
      budgetScore: Map<String, int>.from(json['budgetScore'] ?? {}),
      conceptScore: Map<String, int>.from(json['conceptScore'] ?? {}),
      finalType: json['finalType'] ?? '',
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : DateTime.now(),
    );
  }

  // Firestore 연동
  factory TestResult.fromFirestore(Map<String, dynamic> data) {
    return TestResult(
      rhythmScore: Map<String, int>.from(data['rhythmScore'] ?? {}),
      energyScore: Map<String, int>.from(data['energyScore'] ?? {}),
      budgetScore: Map<String, int>.from(data['budgetScore'] ?? {}),
      conceptScore: Map<String, int>.from(data['conceptScore'] ?? {}),
      finalType: data['finalType'] ?? '',
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'rhythmScore': rhythmScore,
      'energyScore': energyScore,
      'budgetScore': budgetScore,
      'conceptScore': conceptScore,
      'finalType': finalType,
      'completedAt': Timestamp.fromDate(completedAt),
    };
  }

  // 편의 메서드: 전체 점수 맵 가져오기
  Map<String, int> getAllScores() {
    return {
      ...rhythmScore,
      ...energyScore,
      ...budgetScore,
      ...conceptScore,
    };
  }

  // 편의 메서드: 특정 축의 점수 가져오기
  Map<String, int> getAxisScore(String axis) {
    switch (axis) {
      case 'rhythm':
        return rhythmScore;
      case 'energy':
        return energyScore;
      case 'budget':
        return budgetScore;
      case 'concept':
        return conceptScore;
      default:
        return {};
    }
  }
}

class Question {
  final String id;
  final int order;
  final String text;
  final String optionA;
  final String optionB;
  final String axis; // 'rhythm', 'energy', 'budget', 'concept'
  final String scoreA; // 'S', 'A', 'B', 'N'
  final String scoreB; // 'P', 'R', 'L', 'C'

  Question({
    required this.id,
    required this.order,
    required this.text,
    required this.optionA,
    required this.optionB,
    required this.axis,
    required this.scoreA,
    required this.scoreB,
  });

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order': order,
      'text': text,
      'optionA': optionA,
      'optionB': optionB,
      'axis': axis,
      'scoreA': scoreA,
      'scoreB': scoreB,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      order: json['order'] ?? 0,
      text: json['text'] ?? '',
      optionA: json['optionA'] ?? '',
      optionB: json['optionB'] ?? '',
      axis: json['axis'] ?? '',
      scoreA: json['scoreA'] ?? '',
      scoreB: json['scoreB'] ?? '',
    );
  }

  // Firestore 연동
  factory Question.fromFirestore(Map<String, dynamic> data, String id) {
    return Question(
      id: id,
      order: data['order'] ?? 0,
      text: data['text'] ?? '',
      optionA: data['optionA'] ?? '',
      optionB: data['optionB'] ?? '',
      axis: data['axis'] ?? '',
      scoreA: data['scoreA'] ?? '',
      scoreB: data['scoreB'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'order': order,
      'text': text,
      'optionA': optionA,
      'optionB': optionB,
      'axis': axis,
      'scoreA': scoreA,
      'scoreB': scoreB,
    };
  }
}

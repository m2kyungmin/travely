import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question.dart';
import '../models/travel_type.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 질문 목록 가져오기
  Future<List<Question>> getQuestions() async {
    try {
      final snapshot = await _firestore
          .collection('questions')
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => Question.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('질문 가져오기 오류: $e');
      return [];
    }
  }

  // 특정 유형 정보 가져오기
  Future<TravelType?> getTravelType(String typeCode) async {
    try {
      final doc = await _firestore
          .collection('types')
          .doc(typeCode)
          .get();

      if (!doc.exists) {
        return null;
      }

      return TravelType.fromFirestore(doc.data()!);
    } catch (e) {
      print('유형 정보 가져오기 오류: $e');
      return null;
    }
  }

  // 테스트 결과 통계 저장
  Future<void> saveTestResult(String typeCode) async {
    try {
      final today = DateTime.now();
      final dateStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      
      final docRef = _firestore
          .collection('results')
          .doc('${dateStr}_$typeCode');

      await docRef.set({
        'date': dateStr,
        'typeCode': typeCode,
        'count': FieldValue.increment(1),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('결과 저장 오류: $e');
    }
  }
}


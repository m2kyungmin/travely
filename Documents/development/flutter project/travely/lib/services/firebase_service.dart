import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import '../models/travel_type.dart';
import '../models/test_result.dart';
import '../config/constants.dart';

/// Firebase Firestore 연동 서비스 (싱글톤 패턴)
class FirebaseService {
  // 싱글톤 인스턴스
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 캐시 키
  static const String _cacheQuestionsKey = 'cached_questions';
  static const String _cacheTypesKey = 'cached_types';
  static const String _cacheTypesTimestampKey = 'cached_types_timestamp';
  static const String _lastResultKey = AppConstants.lastResultKey;

  // 메모리 캐시
  List<TravelType>? _cachedTypes;
  List<Question>? _cachedQuestions;

  /// SharedPreferences 인스턴스 가져오기 (지연 초기화)
  Future<SharedPreferences> get _preferences async {
    return await SharedPreferences.getInstance();
  }

  /// 질문 목록 가져오기
  /// order 순으로 정렬하여 반환
  /// 네트워크 오류 시 로컬 캐시 사용
  Future<List<Question>> getQuestions() async {
    try {
      // Firestore에서 가져오기
      final snapshot = await _firestore
          .collection(AppConstants.questionsCollection)
          .orderBy('order')
          .get();

      final questions = snapshot.docs
          .map((doc) => Question.fromFirestore(doc.data(), doc.id))
          .toList();

      // 메모리 캐시 업데이트
      _cachedQuestions = questions;

      // 로컬 캐시 저장
      await _saveQuestionsToCache(questions);

      debugPrint('질문 ${questions.length}개를 Firestore에서 가져왔습니다.');
      return questions;
    } catch (e) {
      debugPrint('질문 가져오기 오류: $e');
      
      // 메모리 캐시 확인
      if (_cachedQuestions != null && _cachedQuestions!.isNotEmpty) {
        debugPrint('메모리 캐시에서 질문을 반환합니다.');
        return _cachedQuestions!;
      }

      // 로컬 캐시 확인
      final cachedQuestions = await _loadQuestionsFromCache();
      if (cachedQuestions.isNotEmpty) {
        debugPrint('로컬 캐시에서 질문 ${cachedQuestions.length}개를 반환합니다.');
        return cachedQuestions;
      }

      debugPrint('캐시된 질문이 없습니다.');
      return [];
    }
  }

  /// 특정 유형 정보 가져오기
  /// [code] 유형 코드 (예: "SABN")
  Future<TravelType?> getTravelType(String code) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.typesCollection)
          .doc(code)
          .get();

      if (!doc.exists) {
        debugPrint('유형 $code가 존재하지 않습니다.');
        return null;
      }

      final data = doc.data()!;
      final type = TravelType.fromFirestore(data);
      
      // 데이터 검증 및 로그
      if (type.name.isEmpty || type.name.toLowerCase().contains('placeholder')) {
        debugPrint('⚠️ 유형 $code의 name이 비어있거나 placeholder입니다: "${type.name}"');
      }
      if (type.description.isEmpty || type.description.toLowerCase().contains('placeholder')) {
        debugPrint('⚠️ 유형 $code의 description이 비어있거나 placeholder입니다.');
      }
      if (type.traits.isEmpty) {
        debugPrint('⚠️ 유형 $code의 traits가 비어있습니다.');
      }
      
      // destinations 데이터 검증
      debugPrint('유형 $code를 Firestore에서 가져왔습니다. name: "${type.name}", traits: ${type.traits.length}개, destinations: ${type.destinations.length}개');
      for (int i = 0; i < type.destinations.length; i++) {
        final dest = type.destinations[i];
        debugPrint('  🗺️ 여행지 ${i + 1}: ${dest.name}, imageUrl: "${dest.imageUrl}", isEmpty: ${dest.imageUrl.isEmpty}');
        if (dest.imageUrl.isEmpty) {
          debugPrint('    ⚠️ imageUrl이 비어있습니다!');
        }
      }
      
      return type;
    } catch (e) {
      debugPrint('유형 정보 가져오기 오류: $e');
      
      // 메모리 캐시에서 찾기
      if (_cachedTypes != null) {
        try {
          final cachedType = _cachedTypes!.firstWhere(
            (type) => type.code == code,
          );
          debugPrint('메모리 캐시에서 유형 $code를 반환합니다.');
          return cachedType;
        } catch (_) {
          // 찾지 못함
        }
      }

      // 로컬 캐시에서 찾기
      final cachedTypes = await _loadTypesFromCache();
      try {
        final cachedType = cachedTypes.firstWhere(
          (type) => type.code == code,
        );
        debugPrint('로컬 캐시에서 유형 $code를 반환합니다.');
        return cachedType;
      } catch (_) {
        // 찾지 못함
      }

      return null;
    }
  }

  /// 모든 유형 정보 가져오기 (캐싱용)
  /// 메모리 캐시가 있으면 즉시 반환
  /// 없으면 Firestore에서 가져와서 캐시에 저장
  Future<List<TravelType>> getAllTypes() async {
    // 메모리 캐시 확인
    if (_cachedTypes != null && _cachedTypes!.isNotEmpty) {
      debugPrint('메모리 캐시에서 유형 ${_cachedTypes!.length}개를 반환합니다.');
      return _cachedTypes!;
    }

    try {
      // Firestore에서 가져오기
      final snapshot = await _firestore
          .collection(AppConstants.typesCollection)
          .get();

      final types = snapshot.docs
          .map((doc) => TravelType.fromFirestore(doc.data()))
          .toList();

      // 메모리 캐시 업데이트
      _cachedTypes = types;

      // 로컬 캐시 저장
      await _saveTypesToCache(types);

      debugPrint('유형 ${types.length}개를 Firestore에서 가져왔습니다.');
      return types;
    } catch (e) {
      debugPrint('유형 목록 가져오기 오류: $e');
      
      // 로컬 캐시 확인
      final cachedTypes = await _loadTypesFromCache();
      if (cachedTypes.isNotEmpty) {
        debugPrint('로컬 캐시에서 유형 ${cachedTypes.length}개를 반환합니다.');
        // 메모리 캐시에도 저장
        _cachedTypes = cachedTypes;
        return cachedTypes;
      }

      debugPrint('캐시된 유형이 없습니다.');
      return [];
    }
  }

  /// 테스트 결과 통계 저장
  /// statistics 컬렉션에 날짜별 유형 카운트 증가
  /// [typeCode] 유형 코드 (예: "SABN")
  Future<void> saveTestResult(String typeCode) async {
    try {
      final today = DateTime.now();
      final dateStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      // statistics 컬렉션에 저장
      final docRef = _firestore
          .collection('statistics')
          .doc('${dateStr}_$typeCode');

      await docRef.set({
        'date': dateStr,
        'typeCode': typeCode,
        'count': FieldValue.increment(1),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('통계 저장 완료: $dateStr - $typeCode');
    } catch (e) {
      debugPrint('결과 저장 오류: $e');
      // 통계 저장 실패는 앱 동작에 영향을 주지 않도록 예외를 던지지 않음
    }
  }

  /// 마지막 테스트 결과 저장 (로컬)
  Future<void> saveLastResult(TestResult result) async {
    try {
      final prefs = await _preferences;
      await prefs.setString(
        _lastResultKey,
        jsonEncode(result.toJson()),
      );
      debugPrint('마지막 결과를 로컬에 저장했습니다.');
    } catch (e) {
      debugPrint('결과 저장 오류: $e');
    }
  }

  /// 마지막 테스트 결과 가져오기 (로컬)
  Future<TestResult?> getLastResult() async {
    try {
      final prefs = await _preferences;
      final resultJson = prefs.getString(_lastResultKey);

      if (resultJson == null) {
        return null;
      }

      return TestResult.fromJson(jsonDecode(resultJson));
    } catch (e) {
      debugPrint('결과 가져오기 오류: $e');
      return null;
    }
  }

  /// 마지막 테스트 결과 삭제
  Future<void> clearLastResult() async {
    try {
      final prefs = await _preferences;
      await prefs.remove(_lastResultKey);
      debugPrint('마지막 결과를 삭제했습니다.');
    } catch (e) {
      debugPrint('결과 삭제 오류: $e');
    }
  }

  /// 캐시 초기화
  Future<void> clearCache() async {
    try {
      final prefs = await _preferences;
      await prefs.remove(_cacheQuestionsKey);
      await prefs.remove(_cacheTypesKey);
      await prefs.remove(_cacheTypesTimestampKey);
      _cachedQuestions = null;
      _cachedTypes = null;
      debugPrint('캐시를 초기화했습니다.');
    } catch (e) {
      debugPrint('캐시 초기화 오류: $e');
    }
  }

  // ========== Private 메서드 ==========

  /// 질문을 로컬 캐시에 저장
  Future<void> _saveQuestionsToCache(List<Question> questions) async {
    try {
      final prefs = await _preferences;
      final jsonList = questions.map((q) => q.toJson()).toList();
      await prefs.setString(_cacheQuestionsKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('질문 캐시 저장 오류: $e');
    }
  }

  /// 로컬 캐시에서 질문 로드
  Future<List<Question>> _loadQuestionsFromCache() async {
    try {
      final prefs = await _preferences;
      final jsonStr = prefs.getString(_cacheQuestionsKey);
      if (jsonStr == null) return [];

      final jsonList = jsonDecode(jsonStr) as List<dynamic>;
      return jsonList
          .map((json) => Question.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('질문 캐시 로드 오류: $e');
      return [];
    }
  }

  /// 유형을 로컬 캐시에 저장
  Future<void> _saveTypesToCache(List<TravelType> types) async {
    try {
      final prefs = await _preferences;
      final jsonList = types.map((t) => t.toJson()).toList();
      await prefs.setString(_cacheTypesKey, jsonEncode(jsonList));
      await prefs.setInt(
        _cacheTypesTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      debugPrint('유형 캐시 저장 오류: $e');
    }
  }

  /// 로컬 캐시에서 유형 로드
  Future<List<TravelType>> _loadTypesFromCache() async {
    try {
      final prefs = await _preferences;
      final jsonStr = prefs.getString(_cacheTypesKey);
      if (jsonStr == null) return [];

      final jsonList = jsonDecode(jsonStr) as List<dynamic>;
      return jsonList
          .map((json) => TravelType.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('유형 캐시 로드 오류: $e');
      return [];
    }
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/test_result.dart';

class StorageService {
  static const String _keyLastResult = 'last_test_result';

  // 마지막 테스트 결과 저장
  Future<void> saveLastResult(TestResult result) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyLastResult, jsonEncode(result.toJson()));
    } catch (e) {
      print('결과 저장 오류: $e');
    }
  }

  // 마지막 테스트 결과 가져오기
  Future<TestResult?> getLastResult() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final resultJson = prefs.getString(_keyLastResult);
      
      if (resultJson == null) {
        return null;
      }

      return TestResult.fromJson(jsonDecode(resultJson));
    } catch (e) {
      print('결과 가져오기 오류: $e');
      return null;
    }
  }

  // 마지막 테스트 결과 삭제
  Future<void> clearLastResult() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyLastResult);
    } catch (e) {
      print('결과 삭제 오류: $e');
    }
  }
}


import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/test_result.dart';
import '../models/travel_type.dart';

// 웹이 아닐 때만 import (조건부 import)
import 'dart:io' if (dart.library.html) 'share_service_web_stub.dart' as io;
import 'package:path_provider/path_provider.dart'
    if (dart.library.html) 'path_provider_stub.dart'
    as path_provider;
import 'package:image_gallery_saver/image_gallery_saver.dart'
    if (dart.library.html) 'image_gallery_saver_stub.dart'
    as gallery_saver;

// 웹에서 사용할 html import (웹일 때만)
import 'dart:html' if (dart.library.io) 'html_stub.dart' as html;
import 'dart:typed_data';

/// SNS 공유 서비스
class ShareService {
  /// 기본 공유 텍스트 생성
  String generateShareText(TestResult result, TravelType? travelType) {
    final type = travelType;
    final typeName = type?.name ?? '${result.finalType} 유형';
    final oneLineDesc = type != null && type.description.isNotEmpty
        ? _getOneLineDescription(type.description)
        : '나만의 여행 성향을 알아보세요!';

    // 앱 링크 (실제 배포 시 앱스토어/플레이스토어 링크로 교체)
    final appLink = 'https://travely.app'; // 또는 실제 앱 링크

    return '''나의 여행 MBTI 결과!

${result.finalType} $typeName

"$oneLineDesc"

나도 테스트 해보기 -> $appLink

#여행MBTI #트래블리 #여행테스트''';
  }

  /// 텍스트 공유
  Future<void> shareText(TestResult result, TravelType? travelType) async {
    final text = generateShareText(result, travelType);

    try {
      await Share.share(text, subject: '나만의 여행 MBTI 결과');
    } catch (e) {
      debugPrint('텍스트 공유 오류: $e');
      rethrow;
    }
  }

  /// ScreenshotController를 사용한 이미지 캡처 (더 간단한 방법)
  /// [controller] ScreenshotController (dynamic으로 받아 웹 호환성 확보)
  /// [result] 테스트 결과
  /// [travelType] 여행 유형 정보
  /// 웹과 모바일 모두에서 이미지 공유 시도
  Future<void> shareResultImageWithController(
    dynamic controller,
    TestResult result,
    TravelType? travelType,
  ) async {
    try {
      // 이미지 캡처
      final image = await controller.capture();

      if (image == null) {
        throw Exception('이미지 캡처 실패');
      }

      if (kIsWeb) {
        // 웹: 이미지 공유 시도 (일부 브라우저에서만 지원)
        try {
          await Share.shareXFiles(
            [
              XFile.fromData(
                image,
                mimeType: 'image/png',
                name:
                    'travely_result_${result.finalType}_${DateTime.now().millisecondsSinceEpoch}.png',
              ),
            ],
            text: generateShareText(result, travelType),
            subject: '나만의 여행 MBTI 결과',
          );
        } catch (e) {
          debugPrint('웹 이미지 공유 오류: $e');
          // 웹에서 이미지 공유 실패 시 텍스트 공유로 폴백
          await shareText(result, travelType);
        }
      } else {
        // 모바일: 파일로 저장하고 공유
        // ignore: avoid_web_libraries_in_flutter
        final directory = await path_provider.getTemporaryDirectory();
        // ignore: avoid_web_libraries_in_flutter
        final file = io.File(
          '${directory.path}/travely_result_${DateTime.now().millisecondsSinceEpoch}.png',
        );
        await file.writeAsBytes(image);

        // 이미지와 함께 공유
        await Share.shareXFiles(
          [XFile(file.path)],
          text: generateShareText(result, travelType),
          subject: '나만의 여행 MBTI 결과',
        );
      }
    } catch (e) {
      debugPrint('이미지 공유 오류: $e');
      // 이미지 공유 실패 시 텍스트 공유로 폴백
      await shareText(result, travelType);
    }
  }

  /// 갤러리에 이미지 저장
  /// [controller] ScreenshotController
  /// [result] 테스트 결과
  /// [travelType] 여행 유형 정보
  /// 모바일: image_gallery_saver 사용
  /// 웹: 다운로드 기능 사용
  Future<bool> saveToGallery(
    dynamic controller,
    TestResult result,
    TravelType? travelType,
  ) async {
    try {
      // 이미지 캡처
      final image = await controller.capture();

      if (image == null) {
        throw Exception('이미지 캡처 실패');
      }

      if (kIsWeb) {
        // 웹: 다운로드 기능
        return await _downloadImageWeb(image, result);
      } else {
        // 모바일: 갤러리에 저장
        return await _saveImageToGallery(image);
      }
    } catch (e) {
      debugPrint('갤러리 저장 오류: $e');
      rethrow;
    }
  }

  /// 웹에서 이미지 다운로드
  Future<bool> _downloadImageWeb(
    Uint8List imageBytes,
    TestResult result,
  ) async {
    if (!kIsWeb) {
      return false;
    }

    try {
      // ignore: avoid_web_libraries_in_flutter
      final blob = html.Blob([imageBytes], 'image/png');
      final url = html.Url.createObjectUrlFromBlob(blob);

      // ignore: avoid_web_libraries_in_flutter
      final anchor = html.AnchorElement(href: url);
      anchor.setAttribute(
        'download',
        'travely_result_${result.finalType}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      anchor.click();

      // ignore: avoid_web_libraries_in_flutter
      html.Url.revokeObjectUrl(url);

      return true;
    } catch (e) {
      debugPrint('웹 다운로드 오류: $e');
      return false;
    }
  }

  /// 모바일에서 갤러리에 이미지 저장
  Future<bool> _saveImageToGallery(Uint8List imageBytes) async {
    try {
      // ignore: avoid_web_libraries_in_flutter
      final result = await gallery_saver.ImageGallerySaver.saveImage(
        imageBytes,
        quality: 100,
        name: 'travely_result_${DateTime.now().millisecondsSinceEpoch}',
      );

      // 다양한 반환 형식 지원 (버전별 호환성)
      if (result is Map) {
        // isSuccess 필드 확인
        if (result.containsKey('isSuccess')) {
          return result['isSuccess'] == true;
        }
        // status 필드 확인
        if (result.containsKey('status')) {
          return result['status'] == 'success';
        }
        // filePath가 있으면 성공으로 간주
        if (result.containsKey('filePath') && result['filePath'] != null) {
          return true;
        }
      }

      // result가 null이 아니면 성공으로 간주
      return result != null;
    } catch (e) {
      debugPrint('갤러리 저장 오류: $e');
      return false;
    }
  }

  /// 카카오톡 공유 (URL 스킴 방식)
  /// 웹/모바일 모두에서 카카오톡 앱이 설치되어 있으면 앱으로 공유
  /// 앱이 없으면 웹은 클립보드 복사, 네이티브는 기본 공유로 폴백
  Future<void> shareToKakaoTalk(
    TestResult result,
    TravelType? travelType,
  ) async {
    try {
      final type = travelType;
      final typeName = type?.name ?? '${result.finalType} 유형';
      final oneLineDesc = type != null && type.description.isNotEmpty
          ? _getOneLineDescription(type.description)
          : '나만의 여행 성향을 알아보세요!';

      // 공유할 텍스트
      final shareTextContent =
          '나의 여행 MBTI 결과!\n\n${result.finalType} $typeName\n\n"$oneLineDesc"\n\n나도 테스트 해보기 -> https://travely-mbti.web.app\n\n#여행MBTI #트래블리 #여행테스트';

      // 공유할 링크
      final shareUrl = 'https://travely-mbti.web.app';

      // 웹/모바일 구분 없이 URL 스킴 생성
      final kakaoScheme = Uri.parse(
        'kakaotalk://sendurl?url=${Uri.encodeComponent(shareUrl)}&text=${Uri.encodeComponent(shareTextContent)}',
      );

      // URL 스킴으로 카카오톡 앱 열기 시도
      try {
        final canLaunch = await canLaunchUrl(kakaoScheme);

        if (canLaunch) {
          // 앱이 설치되어 있으면 앱으로 공유
          await launchUrl(kakaoScheme, mode: LaunchMode.externalApplication);
          debugPrint('카카오톡 앱으로 공유를 시작합니다.');
          return;
        }
      } catch (e) {
        debugPrint('URL 스킴 확인 오류: $e');
      }

      // 앱이 없거나 오류 발생 시 폴백 처리
      if (kIsWeb) {
        // 웹: 클립보드에 복사
        await _copyToClipboardWeb('$shareTextContent\n$shareUrl');
        debugPrint('카카오톡 앱이 설치되어 있지 않습니다. 클립보드에 복사되었습니다.');
      } else {
        // 네이티브: 기본 공유로 폴백
        debugPrint('카카오톡 앱이 설치되어 있지 않습니다. 기본 공유로 전환합니다.');
        await shareText(result, travelType);
      }
    } catch (e) {
      debugPrint('카카오톡 공유 오류: $e');
      // 오류 발생 시 기본 공유로 폴백
      await shareText(result, travelType);
    }
  }

  /// 웹에서 클립보드에 텍스트 복사
  Future<void> _copyToClipboardWeb(String text) async {
    if (!kIsWeb) {
      return;
    }

    try {
      // ignore: avoid_web_libraries_in_flutter
      await html.window.navigator.clipboard?.writeText(text);
      debugPrint('클립보드에 복사되었습니다.');
    } catch (e) {
      debugPrint('클립보드 복사 오류: $e');
      rethrow;
    }
  }

  /// 인스타그램 공유 (이미지 공유)
  /// 인스타그램 Stories로 이미지 공유 (모바일만 지원)
  Future<void> shareToInstagram(
    dynamic controller,
    TestResult result,
    TravelType? travelType,
  ) async {
    if (kIsWeb) {
      // 웹에서는 인스타그램 공유 불가, 기본 공유로 폴백
      debugPrint('웹에서는 인스타그램 공유를 지원하지 않습니다.');
      await shareText(result, travelType);
      return;
    }

    try {
      // 이미지 캡처
      final image = await controller.capture();

      if (image == null) {
        throw Exception('이미지 캡처 실패');
      }

      // 임시 파일로 저장
      // ignore: avoid_web_libraries_in_flutter
      final directory = await path_provider.getTemporaryDirectory();
      // ignore: avoid_web_libraries_in_flutter
      final file = io.File(
        '${directory.path}/travely_result_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(image);

      // 인스타그램 공유는 share_plus를 사용하는 것이 더 안정적
      // share_plus로 이미지 공유 시 인스타그램이 선택지에 나타남
      await Share.shareXFiles(
        [XFile(file.path)],
        text: generateShareText(result, travelType),
        subject: '나만의 여행 MBTI 결과',
      );

      // 참고: 인스타그램 URL 스킴 방식은 플랫폼별로 다르고 불안정할 수 있음
      // iOS: instagram://library?LocalIdentifier=...
      // Android: content://media/external/images/media/...
      // 따라서 share_plus를 사용하는 것이 더 나음
    } catch (e) {
      debugPrint('인스타그램 공유 오류: $e');
      // 오류 발생 시 기본 이미지 공유로 폴백
      await shareResultImageWithController(controller, result, travelType);
    }
  }

  // ========== Private 메서드 ==========

  /// 한줄 설명 추출
  String _getOneLineDescription(String description) {
    // 첫 문장만 추출 (마침표 기준)
    final sentences = description.split('.');
    if (sentences.isNotEmpty && sentences[0].trim().isNotEmpty) {
      return sentences[0].trim();
    }
    // 문장이 없으면 길이 제한
    return description.length > 50
        ? '${description.substring(0, 50)}...'
        : description;
  }
}

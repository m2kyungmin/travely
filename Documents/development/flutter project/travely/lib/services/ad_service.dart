import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';

/// Google AdMob 광고 서비스
class AdService {
  static const String _testCountKey = 'test_completion_count';
  static const int _interstitialAdInterval = 3; // 3회마다 1회 표시

  // 플랫폼별 광고 단위 ID 가져오기
  static String get _bannerAdUnitId {
    if (kIsWeb) {
      return AppConstants.bannerAdUnitIdAndroid; // 웹에서는 기본값 사용
    }
    // 웹이 아닐 때만 Platform 사용
    try {
      // ignore: avoid_web_libraries_in_flutter
      if (identical(0, 0.0)) {
        // Android/iOS 구분은 빌드 타임에 처리
        return AppConstants.bannerAdUnitIdAndroid;
      }
    } catch (_) {}
    return AppConstants.bannerAdUnitIdAndroid; // 기본값
  }

  static String get _interstitialAdUnitId {
    if (kIsWeb) {
      return AppConstants.interstitialAdUnitIdAndroid; // 웹에서는 기본값 사용
    }
    try {
      // ignore: avoid_web_libraries_in_flutter
      if (identical(0, 0.0)) {
        return AppConstants.interstitialAdUnitIdAndroid;
      }
    } catch (_) {}
    return AppConstants.interstitialAdUnitIdAndroid; // 기본값
  }

  /// 광고 SDK 초기화 (main.dart에서 호출)
  /// 웹에서는 AdMob이 지원되지 않으므로 건너뜀
  static Future<void> initialize() async {
    if (kIsWeb) {
      debugPrint('AdMob은 웹에서 지원되지 않습니다. 초기화를 건너뜁니다.');
      return;
    }
    try {
      await MobileAds.instance.initialize();
      debugPrint('AdMob SDK 초기화 완료');
    } catch (e) {
      debugPrint('AdMob 초기화 오류: $e');
      rethrow;
    }
  }

  /// 배너 광고 로드
  /// [onAdLoaded] 광고 로드 성공 콜백
  /// [onAdFailedToLoad] 광고 로드 실패 콜백
  /// 웹에서는 null 반환
  BannerAd? loadBannerAd({
    AdSize adSize = AdSize.banner,
    required void Function(Ad) onAdLoaded,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    if (kIsWeb) {
      // 웹에서는 광고를 로드하지 않음
      return null;
    }

    final bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdOpened: (Ad ad) {
          debugPrint('배너 광고 열림');
        },
        onAdClosed: (Ad ad) {
          debugPrint('배너 광고 닫힘');
        },
      ),
    );

    bannerAd.load();
    return bannerAd;
  }

  /// 전면 광고 로드 및 표시
  /// [onAdDismissed] 광고 닫힘 콜백
  /// [onAdFailedToLoad] 광고 로드 실패 콜백
  /// 웹에서는 바로 onAdDismissed 호출
  void loadInterstitialAd({
    required void Function() onAdDismissed,
    required void Function(LoadAdError) onAdFailedToLoad,
  }) {
    if (kIsWeb) {
      // 웹에서는 광고를 표시하지 않고 바로 콜백 호출
      debugPrint('웹에서는 전면 광고를 표시하지 않습니다.');
      onAdDismissed();
      return;
    }

    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              debugPrint('전면 광고 닫힘');
              ad.dispose();
              onAdDismissed();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              debugPrint('전면 광고 표시 실패: ${error.message}');
              ad.dispose();
              // 표시 실패 시 바로 콜백 호출
              onAdDismissed();
            },
            onAdShowedFullScreenContent: (InterstitialAd ad) {
              debugPrint('전면 광고 표시됨');
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('전면 광고 로드 실패: ${error.message}');
          onAdFailedToLoad(error);
        },
      ),
    );
  }

  /// 전면 광고 표시 여부 확인 (3회마다 1회)
  /// 반환값: 표시해야 하면 true
  /// 웹에서는 항상 false 반환
  Future<bool> shouldShowInterstitialAd() async {
    if (kIsWeb) {
      // 웹에서는 광고를 표시하지 않음
      return false;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final count = prefs.getInt(_testCountKey) ?? 0;
      final newCount = count + 1;

      await prefs.setInt(_testCountKey, newCount);

      // 3회마다 1회 표시
      return newCount % _interstitialAdInterval == 0;
    } catch (e) {
      debugPrint('전면 광고 카운터 확인 오류: $e');
      return false;
    }
  }

  /// 테스트 완료 횟수 초기화 (선택적)
  Future<void> resetTestCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_testCountKey);
    } catch (e) {
      debugPrint('테스트 카운터 초기화 오류: $e');
    }
  }
}

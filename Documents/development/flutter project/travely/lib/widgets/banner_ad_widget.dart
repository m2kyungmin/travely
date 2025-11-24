import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';

/// 재사용 가능한 배너 광고 위젯
class BannerAdWidget extends StatefulWidget {
  final AdSize adSize;

  const BannerAdWidget({
    super.key,
    this.adSize = AdSize.banner,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdReady = false;

  @override
  void initState() {
    super.initState();
    // 웹에서는 광고를 로드하지 않음
    if (!kIsWeb) {
      _loadAd();
    }
  }

  void _loadAd() {
    _bannerAd = AdService().loadBannerAd(
      adSize: widget.adSize,
      onAdLoaded: (_) {
        if (mounted) {
          setState(() {
            _isAdReady = true;
          });
        }
      },
      onAdFailedToLoad: (_, error) {
        debugPrint('배너 광고 로드 실패: ${error.message}');
        // 광고 로드 실패 시 빈 공간으로 처리 (위젯 숨김)
        if (mounted) {
          setState(() {
            _isAdReady = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 웹에서는 광고를 표시하지 않음
    if (kIsWeb) {
      return const SizedBox.shrink();
    }

    // 광고가 로드되지 않았으면 빈 공간 반환 (높이 0)
    if (!_isAdReady || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      color: Colors.grey.shade100, // 광고 배경색
      child: AdWidget(ad: _bannerAd!),
    );
  }
}


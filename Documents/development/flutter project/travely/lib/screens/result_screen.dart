import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/test_result.dart';
import '../models/travel_type.dart';
import '../config/theme.dart';
import '../services/share_service.dart';
import '../providers/test_provider.dart';
import '../widgets/destination_card.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/share_result_card.dart';

// 웹이 아닐 때만 screenshot 패키지 import
import 'screenshot_stub.dart'
    if (dart.library.io) 'package:screenshot/screenshot.dart'
    as screenshot_pkg;

class ResultScreen extends StatefulWidget {
  final TestResult result;
  final TravelType? travelType;

  const ResultScreen({super.key, required this.result, this.travelType});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ShareService _shareService = ShareService();
  // 웹에서는 ScreenshotController를 사용하지 않음
  dynamic _screenshotController;

  @override
  void initState() {
    super.initState();
    // 웹과 모바일 모두 ScreenshotController 생성
    _screenshotController = screenshot_pkg.ScreenshotController();
  }

  /// 결과 공유 (이미지 공유)
  Future<void> _shareResult() async {
    try {
      if (_screenshotController == null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('이미지를 준비할 수 없습니다.')));
        }
        return;
      }

      await _shareService.shareResultImageWithController(
        _screenshotController as screenshot_pkg.ScreenshotController,
        widget.result,
        widget.travelType,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('공유 중 오류가 발생했습니다.')));
      }
    }
  }

  Future<void> _openAffiliateLink(String url) async {
    if (url.isEmpty) return;

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('링크 열기 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('링크를 열 수 없습니다.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ResultScreen build 호출됨');
    debugPrint('  - result.finalType: ${widget.result.finalType}');
    debugPrint('  - travelType: ${widget.travelType?.code ?? "null"}');

    final type = widget.travelType;

    // travelType이 null이면 에러 메시지 표시
    if (type == null) {
      debugPrint('⚠️ travelType이 null입니다. 에러 화면 표시');
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.errorColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '유형 정보를 불러올 수 없습니다',
                    style: AppTheme.heading2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '유형 코드: ${widget.result.finalType}',
                    style: AppTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/home', (route) => false);
                    },
                    child: const Text('홈으로 돌아가기'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    debugPrint('✅ ResultScreen 정상 렌더링 시작');

    // 최소한의 테스트 UI 먼저 렌더링
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 상단 결과 카드 (간단한 버전으로 시작)
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: AppTheme.borderRadiusXLarge,
                            boxShadow: AppTheme.buttonShadow,
                          ),
                          child: Column(
                            children: [
                              // 유형 코드
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.white.withOpacity(0.3),
                                  borderRadius: AppTheme.borderRadiusSmall,
                                ),
                                child: Text(
                                  widget.result.finalType,
                                  style: AppTheme.caption.copyWith(
                                    color: AppTheme.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // 캐릭터 이미지
                              if (type.imageUrl.isNotEmpty)
                                ClipRRect(
                                  borderRadius: AppTheme.borderRadiusLarge,
                                  child: CachedNetworkImage(
                                    imageUrl: type.imageUrl,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      width: 150,
                                      height: 150,
                                      color: AppTheme.white.withOpacity(0.1),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: AppTheme.white,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) {
                                      debugPrint(
                                        '❌ 타입 이미지 로드 실패: $url, 에러: $error',
                                      );
                                      return Container(
                                        width: 150,
                                        height: 150,
                                        color: AppTheme.white.withOpacity(0.1),
                                        child: const Icon(
                                          Icons.flight_takeoff,
                                          size: 60,
                                          color: AppTheme.white,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              else
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: AppTheme.white.withOpacity(0.1),
                                    borderRadius: AppTheme.borderRadiusLarge,
                                  ),
                                  child: const Icon(
                                    Icons.flight_takeoff,
                                    size: 60,
                                    color: AppTheme.white,
                                  ),
                                ),
                              const SizedBox(height: 16),
                              // 유형 이름
                              Text(
                                type.name,
                                style: AppTheme.heading2.copyWith(
                                  color: AppTheme.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              // 간단한 설명
                              Text(
                                type.description.isNotEmpty
                                    ? (type.description.length > 100
                                          ? '${type.description.substring(0, 100)}...'
                                          : type.description)
                                    : '설명 없음',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.white,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // 성향 분석 섹션 (간단한 버전)
                        Builder(
                          builder: (context) {
                            debugPrint(
                              '성향 분석 섹션 빌드 시작, traits 개수: ${type.traits.length}',
                            );
                            if (type.traits.isEmpty) {
                              debugPrint('⚠️ traits가 비어있습니다');
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('당신의 여행 성향', style: AppTheme.heading3),
                                  const SizedBox(height: 16),
                                  // 리듬
                                  if (type.traits.containsKey('rhythm'))
                                    _buildTraitItem(
                                      '🎯 여행 리듬',
                                      type.traits['rhythm']!,
                                    ),
                                  // 에너지
                                  if (type.traits.containsKey('energy'))
                                    _buildTraitItem(
                                      '⚡ 여행 에너지',
                                      type.traits['energy']!,
                                    ),
                                  // 예산
                                  if (type.traits.containsKey('budget'))
                                    _buildTraitItem(
                                      '💰 여행 예산',
                                      type.traits['budget']!,
                                    ),
                                  // 컨셉
                                  if (type.traits.containsKey('concept'))
                                    _buildTraitItem(
                                      '🌍 여행 컨셉',
                                      type.traits['concept']!,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        // 추천 여행지 섹션 (간단한 버전)
                        Builder(
                          builder: (context) {
                            debugPrint(
                              '여행지 섹션 빌드 시작, destinations 개수: ${type.destinations.length}',
                            );
                            if (type.destinations.isEmpty) {
                              debugPrint('⚠️ destinations가 비어있습니다');
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '이런 여행지는 어때요?',
                                    style: AppTheme.heading3,
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 320,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: type.destinations.length,
                                      itemBuilder: (context, index) {
                                        final dest = type.destinations[index];
                                        debugPrint(
                                          '📍 여행지 ${index + 1}: ${dest.name}, imageUrl: "${dest.imageUrl}", isEmpty: ${dest.imageUrl.isEmpty}',
                                        );
                                        return DestinationCard(
                                          destination: dest,
                                          onTap: dest.affiliateLink.isNotEmpty
                                              ? () {
                                                  launchUrl(
                                                    Uri.parse(
                                                      dest.affiliateLink,
                                                    ),
                                                  );
                                                }
                                              : null,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        // 하단 버튼 영역
                        Builder(
                          builder: (context) {
                            debugPrint('버튼 영역 빌드 시작');
                            try {
                              final buttons = _buildActionButtons();
                              debugPrint('버튼 영역 빌드 완료');
                              return buttons;
                            } catch (e, stackTrace) {
                              debugPrint('❌ _buildActionButtons 에러: $e');
                              debugPrint('스택: $stackTrace');
                              return Container(
                                padding: const EdgeInsets.all(16),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pushNamedAndRemoveUntil(
                                      '/home',
                                      (route) => false,
                                    );
                                  },
                                  child: const Text('홈으로 돌아가기'),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                    // 공유용 결과 카드 (화면 밖으로 이동, 이미지 캡처용)
                    if (_screenshotController != null)
                      Positioned(
                        left: -2000,
                        top: -2000,
                        child: SizedBox(
                          width: 1080,
                          height: 1080,
                          child: Builder(
                            builder: (context) {
                              try {
                                return screenshot_pkg.Screenshot(
                                  controller:
                                      _screenshotController
                                          as screenshot_pkg.ScreenshotController,
                                  child: ShareResultCard(
                                    result: widget.result,
                                    travelType: type,
                                  ),
                                );
                              } catch (e) {
                                debugPrint('❌ Screenshot 위젯 에러: $e');
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // 광고 배너
            Builder(
              builder: (context) {
                try {
                  return const BannerAdWidget();
                } catch (e) {
                  debugPrint('❌ BannerAdWidget 에러: $e');
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 상단 결과 카드
  Widget _buildResultCard(TravelType? type) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: AppTheme.borderRadiusXLarge,
        boxShadow: AppTheme.buttonShadow,
      ),
      child: Stack(
        children: [
          // 공유 버튼 (우측 상단)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.share, color: AppTheme.white),
              onPressed: _shareResult,
            ),
          ),
          Column(
            children: [
              // 유형 코드
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.white.withOpacity(0.3),
                  borderRadius: AppTheme.borderRadiusSmall,
                ),
                child: Text(
                  widget.result.finalType,
                  style: AppTheme.caption.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 캐릭터 이미지
              type?.imageUrl != null && type!.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: AppTheme.borderRadiusLarge,
                      child: CachedNetworkImage(
                        imageUrl: type.imageUrl,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 150,
                          height: 150,
                          color: AppTheme.white.withOpacity(0.1),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          debugPrint('이미지 로딩 실패: $url, 오류: $error');
                          return Container(
                            width: 150,
                            height: 150,
                            color: AppTheme.white.withOpacity(0.2),
                            child: const Icon(
                              Icons.flight_takeoff,
                              size: 60,
                              color: AppTheme.white,
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppTheme.white.withOpacity(0.2),
                        borderRadius: AppTheme.borderRadiusLarge,
                      ),
                      child: const Icon(
                        Icons.flight_takeoff,
                        size: 60,
                        color: AppTheme.white,
                      ),
                    ),
              const SizedBox(height: 16),
              // 유형 이름
              Text(
                type?.name ?? '${widget.result.finalType} 유형',
                style: AppTheme.heading2.copyWith(
                  color: AppTheme.white,
                  fontSize: 26,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 성향 분석 섹션
  Widget _buildTraitsSection(TravelType type) {
    final traitIcons = {
      'rhythm': '🎯',
      'energy': '⚡',
      'budget': '💰',
      'concept': '🌍',
    };

    final traitNames = {
      'rhythm': '여행 리듬',
      'energy': '여행 에너지',
      'budget': '여행 예산',
      'concept': '여행 컨셉',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('나의 여행 성향', style: AppTheme.heading3),
          const SizedBox(height: 16),
          ...traitNames.entries.map((entry) {
            final axis = entry.key;
            final name = entry.value;
            final icon = traitIcons[axis] ?? '✨';
            var trait = type.traits[axis] ?? '';

            // Placeholder 텍스트 제거 및 기본값 설정
            if (trait.isEmpty || trait.toLowerCase().contains('placeholder')) {
              trait = '데이터를 불러오는 중입니다...';
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTraitCard(icon, name, trait),
            );
          }),
        ],
      ),
    );
  }

  /// 성향 카드
  Widget _buildTraitCard(String icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: AppTheme.borderRadiusMedium,
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 상세 설명 섹션
  Widget _buildDescriptionSection(TravelType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('당신의 여행 스타일', style: AppTheme.heading3),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: AppTheme.borderRadiusMedium,
              boxShadow: AppTheme.cardShadow,
            ),
            child: Text(
              type.description,
              style: AppTheme.bodyMedium.copyWith(
                height: 1.6,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 추천 여행지 섹션
  Widget _buildDestinationsSection(TravelType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('이런 여행지는 어때요?', style: AppTheme.heading3),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: type.destinations.length,
            itemBuilder: (context, index) {
              final destination = type.destinations[index];
              return DestinationCard(
                destination: destination,
                onTap: destination.affiliateLink.isNotEmpty
                    ? () => _openAffiliateLink(destination.affiliateLink)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  /// 갤러리에 저장
  Future<void> _saveToGallery() async {
    if (_screenshotController == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('이미지 저장에 실패했습니다.')));
      }
      return;
    }

    try {
      final success = await _shareService.saveToGallery(
        _screenshotController as screenshot_pkg.ScreenshotController,
        widget.result,
        widget.travelType,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? (kIsWeb ? '이미지가 다운로드되었습니다!' : '갤러리에 저장되었습니다!')
                  : '저장에 실패했습니다.',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('갤러리 저장 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('저장 중 오류가 발생했습니다.')));
      }
    }
  }

  /// 성향 아이템 빌드
  Widget _buildTraitItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: AppTheme.borderRadiusMedium,
          boxShadow: AppTheme.buttonShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTheme.heading3.copyWith(fontSize: 18)),
            const SizedBox(height: 8),
            Text(description, style: AppTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  /// 하단 버튼 영역
  Widget _buildActionButtons() {
    debugPrint('_buildActionButtons 호출됨');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 결과 공유하기 버튼
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _shareResult,
              icon: const Icon(Icons.share),
              label: const Text('결과 공유하기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: AppTheme.white,
                shape: RoundedRectangleBorder(
                  borderRadius: AppTheme.borderRadiusMedium,
                ),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 갤러리에 저장 버튼
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                debugPrint('저장 버튼 클릭됨');
                _saveToGallery();
              },
              icon: Icon(kIsWeb ? Icons.download : Icons.save_alt),
              label: Text(kIsWeb ? '이미지 다운로드' : '갤러리에 저장'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
                foregroundColor: AppTheme.white,
                shape: RoundedRectangleBorder(
                  borderRadius: AppTheme.borderRadiusMedium,
                ),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 다시 테스트하기 버튼
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: () {
                // 테스트 초기화
                final provider = context.read<TestProvider>();
                provider.resetTest();

                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/test', (route) => route.isFirst);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: const BorderSide(color: AppTheme.primaryColor, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: AppTheme.borderRadiusMedium,
                ),
              ),
              child: const Text('다시 테스트하기'),
            ),
          ),
        ],
      ),
    );
  }
}

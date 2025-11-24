import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/test_result.dart';
import '../models/travel_type.dart';
import '../config/theme.dart';
import '../config/constants.dart';

/// 공유용 결과 카드 위젯 (이미지 캡처용)
class ShareResultCard extends StatelessWidget {
  final TestResult result;
  final TravelType? travelType;

  const ShareResultCard({super.key, required this.result, this.travelType});

  @override
  Widget build(BuildContext context) {
    final type = travelType;

    // 공유용 카드는 인스타그램 스토리 비율 (1080x1920, 9:16)
    return Container(
      width: 1080,
      height: 1920,
      decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
      child: Stack(
        children: [
          // 배경 그라데이션 오버레이 (선택적)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.black.withOpacity(0.1), Colors.transparent],
                ),
              ),
            ),
          ),
          // 메인 컨텐츠
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 앱 로고 (상단)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.flight_takeoff,
                      size: 36,
                      color: AppTheme.white.withOpacity(0.8),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppConstants.appName,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // 유형 코드 배지
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    result.finalType,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                // 캐릭터 이미지
                if (type?.imageUrl != null && type!.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: CachedNetworkImage(
                      imageUrl: type.imageUrl,
                      width: 280,
                      height: 280,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          _buildPlaceholderImage(),
                    ),
                  )
                else
                  _buildPlaceholderImage(),
                const SizedBox(height: 35),
                // 유형 이름
                Text(
                  type?.name ?? '${result.finalType} 유형',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // 한줄 설명
                if (type != null && type.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      _getOneLineDescription(type.description),
                      style: TextStyle(
                        fontSize: 28,
                        color: AppTheme.white.withOpacity(0.95),
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const SizedBox(height: 30),
                // 4가지 성향 아이콘
                if (type != null) _buildTraitsRow(type),
                const SizedBox(height: 30),
                // 추천 여행지 섹션
                if (type != null && type.destinations.isNotEmpty)
                  _buildDestinationsRow(type),
                const SizedBox(height: 30),
                // 앱 로고 워터마크 (하단)
                Text(
                  '${AppConstants.appName}에서 나만의 여행 성향을 알아보세요!',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppTheme.white.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(40),
      ),
      child: const Icon(Icons.flight_takeoff, size: 110, color: AppTheme.white),
    );
  }

  Widget _buildTraitsRow(TravelType type) {
    final traitIcons = {
      'rhythm': '🎯',
      'energy': '⚡',
      'budget': '💰',
      'concept': '🌍',
    };

    final traitNames = {
      'rhythm': '리듬',
      'energy': '에너지',
      'budget': '예산',
      'concept': '컨셉',
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: traitNames.entries.map((entry) {
        final axis = entry.key;
        final name = entry.value;
        final icon = traitIcons[axis] ?? '✨';

        return Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.white.withOpacity(0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDestinationsRow(TravelType type) {
    // 상위 3개 여행지만 선택
    final destinations = type.destinations.take(3).toList();

    if (destinations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: destinations.map((destination) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  // 여행지 이미지 썸네일
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: destination.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: destination.imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: AppTheme.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.place,
                                color: AppTheme.white,
                                size: 35,
                              ),
                            ),
                          )
                        : Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: AppTheme.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.place,
                              color: AppTheme.white,
                              size: 35,
                            ),
                          ),
                  ),
                  const SizedBox(height: 6),
                  // 여행지 이름
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Text(
                      destination.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.white.withOpacity(0.95),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getOneLineDescription(String description) {
    // 첫 문장만 추출 (마침표 기준)
    final sentences = description.split('.');
    if (sentences.isNotEmpty && sentences[0].trim().isNotEmpty) {
      return '${sentences[0].trim()}.';
    }
    return description.length > 50
        ? '${description.substring(0, 50)}...'
        : description;
  }
}

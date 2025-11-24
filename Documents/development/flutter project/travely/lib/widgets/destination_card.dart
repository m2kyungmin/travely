import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:cached_network_image/cached_network_image.dart';
import '../models/travel_type.dart';
import '../config/theme.dart';

/// 추천 여행지 카드 위젯 (가로 스크롤용)
class DestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback? onTap;

  const DestinationCard({
    super.key,
    required this.destination,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 디버그: imageUrl 값 확인
    debugPrint('🖼️ DestinationCard 빌드: ${destination.name}, imageUrl: "${destination.imageUrl}", isEmpty: ${destination.imageUrl.isEmpty}');
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: AppTheme.borderRadiusLarge,
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 영역
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: destination.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: destination.imageUrl,
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        debugPrint('⏳ 이미지 로딩 중: $url');
                        return Container(
                          width: double.infinity,
                          height: 160,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        debugPrint('❌ 이미지 로드 실패: $url, 에러: $error');
                        return Container(
                          width: double.infinity,
                          height: 160,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: double.infinity,
                      height: 160,
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      child: const Icon(
                        Icons.place,
                        size: 60,
                        color: AppTheme.primaryColor,
                      ),
                    ),
            ),
            // 내용 영역
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      style: AppTheme.heading3.copyWith(
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      destination.description,
                      style: AppTheme.bodySmall.copyWith(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    if (onTap != null)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: onTap,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                            side: const BorderSide(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          child: const Text('여행지 보기'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


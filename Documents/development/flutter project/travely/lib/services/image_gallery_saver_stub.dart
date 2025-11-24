// 웹 빌드를 위한 스텁 파일
// image_gallery_saver는 웹에서 지원되지 않음

class ImageGallerySaver {
  static Future<Map<String, dynamic>> saveImage(
    List<int> imageBytes, {
    int? quality,
    String? name,
  }) async {
    throw UnsupportedError('웹에서는 image_gallery_saver를 사용할 수 없습니다.');
  }
}


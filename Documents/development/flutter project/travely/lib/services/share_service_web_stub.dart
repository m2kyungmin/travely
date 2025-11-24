// 웹 빌드를 위한 스텁 파일
// dart:io의 File을 대체

class File {
  final String path;
  File(this.path);
  
  Future<File> writeAsBytes(List<int> bytes) async {
    throw UnsupportedError('웹에서는 파일 쓰기를 지원하지 않습니다.');
  }
}

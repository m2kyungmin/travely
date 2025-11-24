// 웹 빌드를 위한 스텁 파일
// path_provider는 웹에서 지원되지 않음

class Directory {
  final String path;
  Directory(this.path);
}

Future<Directory> getTemporaryDirectory() async {
  throw UnsupportedError('웹에서는 getTemporaryDirectory를 사용할 수 없습니다.');
}


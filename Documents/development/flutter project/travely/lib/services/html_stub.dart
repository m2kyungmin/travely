// 모바일 빌드를 위한 스텁 파일
// dart:html은 웹에서만 사용 가능

class Blob {
  Blob(List<dynamic> data, String mimeType);
}

class Url {
  static String createObjectUrlFromBlob(Blob blob) => '';
  static void revokeObjectUrl(String url) {}
}

class AnchorElement {
  String? href;
  AnchorElement({this.href});
  void setAttribute(String name, String value) {}
  void click() {}
}


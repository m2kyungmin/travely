// 웹 빌드를 위한 스텁 파일
// 실제 screenshot 패키지는 웹에서 지원되지 않음
// 웹에서는 RenderRepaintBoundary를 사용하여 이미지 캡처

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ScreenshotController {
  final GlobalKey _globalKey = GlobalKey();

  GlobalKey get key => _globalKey;

  Future<Uint8List?> capture() async {
    try {
      final RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List? pngBytes = byteData?.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      return null;
    }
  }
}

class Screenshot extends StatelessWidget {
  final ScreenshotController controller;
  final Widget child;

  const Screenshot({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: controller.key,
      child: child,
    );
  }
}


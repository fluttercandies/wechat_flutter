import 'package:get/get.dart';
import 'package:wechat_flutter/video/pages/video_sigle/logic.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class VideoSingleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoSingleLogic());
  }
}

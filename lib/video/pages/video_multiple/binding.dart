import 'package:get/get.dart';
import 'package:wechat_flutter/video/pages/video_multiple/logic.dart';

class VideoMultipleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoMultipleLogic());
  }
}

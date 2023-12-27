import 'package:get/get.dart';
import 'package:wechat_flutter/video/pages/audio_multiple/logic.dart';

class AudioMultipleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AudioMultipleLogic());
  }
}

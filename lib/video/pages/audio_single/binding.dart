import 'package:get/get.dart';
import 'package:wechat_flutter/video/pages/audio_single/logic.dart';

class AudioSingleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AudioSingleLogic(null, false, 1, null, null, null));
  }
}

import 'package:get/get.dart';
import 'package:wechat_flutter/video/pages/accept/logic.dart';

class AcceptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AcceptLogic());
  }
}

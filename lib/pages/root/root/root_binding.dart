import 'package:get/get.dart';

import 'root_logic.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RootLogic());
  }
}

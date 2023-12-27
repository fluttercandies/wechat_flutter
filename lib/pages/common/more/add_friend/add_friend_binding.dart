import 'package:get/get.dart';

import 'add_friend_logic.dart';

class AddFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddFriendLogic());
  }
}

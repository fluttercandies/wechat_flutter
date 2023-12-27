
import '../../../tools/wechat_flutter.dart';

class RootLogic extends GetxController {

  ifBrokenNetwork() async {
    final ifNetWork = await SharedUtil.instance!.getBoolean(Keys.brokenNetwork);
    if (ifNetWork) {
      /// 监测网络变化
      subscription.onConnectivityChanged
          .listen((ConnectivityResult result) async {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          await SharedUtil.instance!.saveBoolean(Keys.brokenNetwork, false);
        }
      });
    } else {
      return;
    }
  }

}

import 'package:wechat_flutter/config/keys.dart';
import 'package:wechat_flutter/tools/data/store.dart';

export 'package:wechat_flutter/tools/data/notice.dart';
export 'package:wechat_flutter/tools/data/store.dart';

class WeChatActions {
  static String msg() => 'msg';

  static String groupName() => 'groupName';

  static String voiceImg() => 'voiceImg';

  static String user() => 'user';
}

class Data {
  static String msg() => Store(WeChatActions.msg()).value ?? '';

  static String user() => Store(WeChatActions.user()).value ?? '';

  static String voiceImg() => Store(WeChatActions.voiceImg()).value ?? '';

  static Future initData() async {
    getStoreValue(Keys.account).then((data) {
      Store(WeChatActions.user()).value = data;
    });
  }

  static Future clearData() async {
    Store(WeChatActions.user()).value = "";
  }
}

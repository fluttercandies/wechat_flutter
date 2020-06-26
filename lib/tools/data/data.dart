import 'package:wechat_flutter/tools/data/store.dart';
export 'package:wechat_flutter/tools/data/store.dart';
export 'package:wechat_flutter/tools/data/notice.dart';

class WeChatActions {
  static String msg() => 'msg';

  static String groupName() => 'groupName';

  static String voiceImg() => 'voiceImg';
}

class Data {
  static String msg() => Store(WeChatActions.msg()).value = '';

  static String voiceImg() => Store(WeChatActions.voiceImg()).value = '';
}

import 'package:dim_example/tools/data/store.dart';
export 'package:dim_example/tools/data/store.dart';
export 'package:dim_example/tools/data/notice.dart';

class WeChatActions {
  static String msg() => 'msg';

  static String voiceImg() => 'voiceImg';
}

class Data {
  static String msg() => Store(WeChatActions.msg()).value = '';

  static String voiceImg() => Store(WeChatActions.voiceImg()).value = '';
}

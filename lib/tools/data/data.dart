import 'package:dim_example/tools/data/store.dart';
export 'package:dim_example/tools/data/store.dart';
export 'package:dim_example/tools/data/notice.dart';

class WeChatActions {
  static String imgMsg() => 'imgMsg';

  static String voiceImg() => 'voiceImg';
}

class Data {
  static String imgMsg() => Store(WeChatActions.imgMsg()).value = '';

  static String voiceImg() => Store(WeChatActions.voiceImg()).value = '';
}

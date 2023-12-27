import 'package:wechat_flutter/tools/commom/check.dart';

class ImResponseTipUtil {
  /// 使用返回代码拿到提示结果
  static String getInfoOResultCode(int? code, [String? desc]) {
    print("ImResponseTipUtil::getInfoOResultCode::$code");
    if (code == 30001) {
      return "对方已经是好友了";
    } else if (code == 30014) {
      return "对方的好友数已达系统上限";
    } else if (code == 30539) {
      return "等待对方通过好友申请";
    } else if (code == 10015) {
      return "群组不存在或已经被解散。";
    }  else if (code == 30010) {
      return "自己的好友数已达系统上限。";
    } else if (code == 10013) {
      return "你已经是群成员啦。";
    } else {
      if (strNoEmpty(desc)) {
        return desc!;
      }
      return "出现错误";
    }
  }
}

class ImResponseTipUtil {
  /// 使用返回代码拿到提示结果
  static String getInfoOResultCode(int code) {
    print("ImResponseTipUtil::getInfoOResultCode::$code");
    if (code == 30001) {
      return "对方已经是好友了";
    } else if (code == 30014) {
      return "对方的好友数已达系统上限";
    } else if (code == 30539) {
      return "等待对方通过好友申请";
    } else if (code == 10015) {
      return "群组不存在或已经被解散。";
    } else if (code == 10013) {
      return "你已经是群成员啦。";
    } else if (code == -1) {
      return "不能申请添加自己为好友";
    } else {
      return "出现错误";
    }
  }
}

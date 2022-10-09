class ImResponseTipUtil {
  /// 使用返回代码拿到提示结果
  static String getInfoOResultCode(int code) {
    print("ImResponseTipUtil::getInfoOResultCode::$code");
    if (code == 30001) {
      return "对方已经是好友了";
    } else if (code == 30014) {
      return "对方的好友数已达系统上限";
    } else if (code == -1) {
      return "不能申请添加自己为好友";
    } else {
      return "出现错误";
    }
  }
}

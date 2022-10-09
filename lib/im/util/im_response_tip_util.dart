class ImResponseTipUtil {
  /// 使用返回代码拿到提示结果
  static String getInfoOResultCode(int code) {
    if (code == 30001) {
      return "对方已经是好友了";
    } else {
      return "出现错误";
    }
  }
}

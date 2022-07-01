class AppConfig {
  /// 应用名字
  static String appName = "微信";

  /// 模拟封面
  static String mockCover =
      "http://img1.gtimg.com/cul/pics/hv1/23/243/1470/95648738.jpg";

  static String logoImg = "images/main/home_logo.webp";

  /// 【IM】是否允许添加自己为好友
  static bool isArrowAddSelf = false;

  /// 腾讯云IM AppId
  static int IMSdkAppID = 1400250651;

  /// 腾讯云IM 签名
  static String ImSdkSign =
      "4236133554a57c8fa7ae748534177e97cac28b0750f57ca2edbb974a17a14544";

  // 注册是否需要邀请码
  static bool needInviteCode = true;

  /// 未注册用户的状态代码
  static int noRegisterCode = 411;

  /// 微信登录授权登录码过期
  static int wxLoginCodeOverdue = 420;

  /// 倒计时秒
  static int countdownSecond = 60;
}

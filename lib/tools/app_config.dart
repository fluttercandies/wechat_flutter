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
  static int IMSdkAppID = 1400597090;

  /// 腾讯云IM 签名
  static String ImSdkSign =
      "0dba8e0d933e3bb73e1a8c7befc4730cdadcc3a5733f126f5487b013ea373aaa";

  // 注册是否需要邀请码
  static bool needInviteCode = true;

  /// 未注册用户的状态代码
  static int noRegisterCode = 411;

  /// 微信登录授权登录码过期
  static int wxLoginCodeOverdue = 420;

  /// 倒计时秒
  static int countdownSecond = 60;

  /// 会话列表[conversation]一页获取数量
  static var cvsPageCount = 30;

  /// 微信团队用户id
  static String wxTeamUserId = "166";
}

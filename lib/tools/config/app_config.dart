import 'package:wechat_flutter/tools/wechat_flutter.dart';

class AppConfig {
  /// 应用名字
  static String appName = "微信";

  /// 模拟封面
  static String mockCover = defIcon;

  static String logoImg = "assets/images/wechat/in/default_nor_avatar.png";

  static String defPic = logoImg;

  /// 【IM】是否允许添加自己为好友
  static bool isArrowAddSelf = false;

  // /// 腾讯云IM AppId
  // static int IMSdkAppID = 1400597090;
  //
  // /// 腾讯云IM 签名
  // static String ImSdkSign =
  //     "0dba8e0d933e3bb73e1a8c7befc4730cdadcc3a5733f126f5487b013ea373aaa";

  /// 腾讯云IM AppId
  static int IMSdkAppID = 1400250651;

  /// 腾讯云IM 签名
  static String ImSdkSign =
      "4236133554a57c8fa7ae748534177e97cac28b0750f57ca2edbb974a17a14544";

  static int sdkAppId = IMSdkAppID;

  /// 模拟房间id
  static int mockCallRoomId = 888888;

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

  /// 键盘高度
  static double keyboardHeight = 300;

  /// 微信团队用户id
  static String wxTeamUserId = "166";

  /// 是否生产环境
  static bool inProduction = const bool.fromEnvironment("dart.vm.product");

  static String get mockPw {
    if (inProduction) {
      return "";
    }
    return "a1111111";
  }

  static String get mockPhone {
    if (inProduction) {
      return "";
    }
    if (Platform.isAndroid) {
      return "13244766725";
    } else {
      return "18826987045";
    }
  }
}

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:wechat_flutter/im/info_handle.dart';
import 'package:wechat_flutter/provider/loginc/global_loginc.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class GlobalModel extends ChangeNotifier {
  BuildContext? context;

  ///app的名字
  String appName = '微信flutter';

  /// 用户信息
  String account = '';
  String nickName = 'nickName';
  String avatar = '';
  int gender = 0;

  ///当前语言
  List<String> currentLanguageCode = ['zh', 'CN'];
  String currentLanguage = '中文';
  Locale? currentLocale;

  ///是否进入登录页
  bool goToLogin = true;

  late GlobalLogic logic;

  GlobalModel() {
    this.logic = GlobalLogic(this);
  }

  void setContext(BuildContext context) {
    if (this.context == null) {
      this.context = context;
      Future.wait([
        logic.getAppName(),
        logic.getCurrentLanguageCode(),
        logic.getCurrentLanguage(),
        logic.getLoginState(),
        logic.getAccount(),
        logic.getNickName(),
        logic.getFaceUrl(),
        logic.getGender(),
      ]).then((value) {
        currentLocale = Locale(currentLanguageCode[0], currentLanguageCode[1]);
        refresh();
      });
    }
  }

  Future<void> initInfo() async {
    final List<V2TimUserFullInfo> data = await getUsersProfile([account]);
    if (data.isEmpty) {
      return;
    }

    final V2TimUserFullInfo model = data[0];
    nickName = model.nickName ?? model.userID ?? '';

    await SharedUtil.instance.saveString(Keys.nickName, nickName);
    avatar = model.faceUrl ?? '';
    await SharedUtil.instance.saveString(Keys.faceUrl, avatar);
    gender = model.gender ?? 0;
    await SharedUtil.instance.saveInt(Keys.gender, model.gender!);
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('GlobalModel销毁了');
  }

  void refresh() {
    if (!goToLogin) {
      initInfo();
    }
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:wechat_flutter/tools/provider/loginc/global_loginc.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class GlobalController extends GetxController {

  BuildContext? context;

  ///app的名字
  String appName = "${AppConfig.appName}";

  /// 用户信息
  /// account是TID
  String account = '';
  String? nickName = 'nickName';
  String? avatar = '';
  int? gender = 0;

  ///当前语言
  List<String> currentLanguageCode = ["zh", "CN"];
  String currentLanguage = "中文";
  Locale? currentLocale;

  ///是否进入登录页
  bool goToLogin = true;

  late GlobalLogic logic;

  GlobalController() {
    logic = GlobalLogic(this);
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

  Future initInfo() async {
    final List<V2TimUserFullInfo>? data = await ImApi.getUsersInfo([account]);
    if (!listNoEmpty(data)) return;
    nickName = data![0].nickName;
    await SharedUtil.instance!.saveString(Keys.nickName, data[0].nickName);
    avatar = data[0].faceUrl;
    await SharedUtil.instance!.saveString(Keys.faceUrl, data[0].faceUrl);
    gender = data[0].gender;
    await SharedUtil.instance!.saveInt(Keys.gender, data[0].gender!);
  }
}

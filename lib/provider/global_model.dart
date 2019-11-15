import 'dart:convert';

import 'package:dim_example/tools/wechat_flutter.dart';
import 'package:flutter/material.dart';
import 'package:dim_example/im/info_handle.dart';
import 'package:dim_example/provider/loginc/global_loginc.dart';

class GlobalModel extends ChangeNotifier {
  BuildContext context;

  ///app的名字
  String appName = "微信flutter";

  /// 用户信息
  String account = '';
  String nickName = 'nickName';
  String avatar = '';
  int gender = 0;

  ///当前语言
  List<String> currentLanguageCode = ["zh", "CN"];
  String currentLanguage = "中文";
  Locale currentLocale;

  ///是否进入登录页
  bool goToLogin = true;

  GlobalLogic logic;

  GlobalModel() {
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

  void initInfo() async {
    final data = await getUsersProfile([account]);
    List<dynamic> result = json.decode(data);
    nickName = result[0]['nickName'];
    await SharedUtil.instance.saveString(Keys.nickName, result[0]['nickName']);
    avatar = result[0]['faceUrl'];
    await SharedUtil.instance.saveString(Keys.faceUrl, result[0]['faceUrl']);
    gender = result[0]['gender'];
    await SharedUtil.instance.saveInt(Keys.gender, result[0]['gender']);
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("GlobalModel销毁了");
  }

  void refresh() {
    if (!goToLogin) initInfo();
    notifyListeners();
  }
}

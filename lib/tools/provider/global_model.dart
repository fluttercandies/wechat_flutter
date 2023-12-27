import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:wechat_flutter/im/im_handle/Im_api.dart';
import 'package:wechat_flutter/tools/core/global_controller.dart';
import 'package:wechat_flutter/tools/provider/loginc/global_loginc.dart';
import 'package:wechat_flutter/tools/config/app_config.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class GlobalModel extends ChangeNotifier {
  final model = Get.find<GlobalController>();

  String get account {
    return model.account;
  }

  String get appName {
    return model.appName;
  }

  String? get avatar {
    return model.avatar;
  }

  String? get nickName {
    return model.nickName;
  }

  String get currentLanguage {
    return model.currentLanguage;
  }

  bool get goToLogin {
    return model.goToLogin;
  }

  void setCurrentLanguageCode(List<String> value) {
    model.currentLanguageCode = value;
  }

  void setAvatar(String value) {
    model.avatar = value;
  }

  void setCurrentLanguage(String value) {
    model.currentLanguage = value;
  }

  void setAppName(String value) {
    model.appName = value;
  }

  void setCurrentLocale(Locale value) {
    model.currentLocale = value;
  }

  void setAccount(String value) {
    model.account = value;
  }

  void setGoToLogin(bool value) {
    model.goToLogin = value;
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("GlobalModel销毁了");
  }

  Future setContext(BuildContext context) async {
    model.setContext(context);
  }

  Future refresh() async {
    if (!model.goToLogin) await model.initInfo();
    notifyListeners();
    model.update();
  }
}

import 'package:wechat_flutter/provider/global_model.dart';
import 'package:wechat_flutter/tools/shared_util.dart';

class GlobalLogic {
  final GlobalModel _model;

  GlobalLogic(this._model);

  ///获取当前的语言code
  Future getCurrentLanguageCode() async {
    final list =
        await SharedUtil.instance.getStringList(Keys.currentLanguageCode);
    if (list == null) return;
    if (list == _model.currentLanguageCode) return;
    _model.currentLanguageCode = list;
  }

  ///获取当前的语言
  Future getCurrentLanguage() async {
    final currentLanguage =
        await SharedUtil.instance.getString(Keys.currentLanguage);
    if (currentLanguage == null) return;
    if (currentLanguage == _model.currentLanguage) return;
    _model.currentLanguage = currentLanguage;
  }

  ///获取app的名字
  Future getAppName() async {
    final appName = await SharedUtil.instance.getString(Keys.appName);
    if (appName == null) return;
    if (appName == _model.appName) return;
    _model.appName = appName;
  }

  ///获取本人昵称
  Future getNickName() async {
    final nickName = await SharedUtil.instance.getString(Keys.nickName);
    if (nickName == null) return;
    if (nickName == _model.nickName) return;
    _model.nickName = nickName;
  }

  ///获取本人头像
  Future getFaceUrl() async {
    final faceUrl = await SharedUtil.instance.getString(Keys.faceUrl);
    if (faceUrl == null) return;
    if (faceUrl == _model.avatar) return;
    _model.avatar = faceUrl;
  }

  ///获取本人性别
  Future getGender() async {
    final gender = await SharedUtil.instance.getInt(Keys.gender);
    if (gender == null) return;
    if (gender == _model.gender) return;
    _model.gender = gender;
  }

  ///用于判断是否进入登录页面
  Future getLoginState() async {
    final hasLogged = await SharedUtil.instance.getBoolean(Keys.hasLogged);
    if (hasLogged == null)
      _model.goToLogin = true;
    else
      _model.goToLogin = !hasLogged;
  }

  ///获取当前登录的用户名
  Future getAccount() async {
    final appAccount = await SharedUtil.instance.getString(Keys.account);
    if (appAccount == null) return;
    if (appAccount == _model.account) return;
    _model.account = appAccount;
  }
}

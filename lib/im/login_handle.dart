import 'package:provider/provider.dart';
import 'package:wechat_flutter/pages/login/login_begin_page.dart';
import 'package:wechat_flutter/pages/root/root_page.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

Future<void> init(BuildContext context) async {
  try {
    var result = await im.init(appId);
    debugPrint('初始化结果 ======>   ${result.toString()}');
  } on PlatformException {
    showToast(context, "初始化失败");
  }
}

Future<void> login(String userName, BuildContext context) async {
  final model = Provider.of<GlobalModel>(context, listen: false);

  try {
    var result = await im.imLogin(userName, null);
    if (result.toString().contains('ucc')) {
      model.account = userName;
      model.goToLogin = false;
      await SharedUtil.instance.saveString(Keys.account, userName);
      await SharedUtil.instance.saveBoolean(Keys.hasLogged, true);
      model.refresh();
      await routePushAndRemove(new RootPage());
    } else {
      print('error::' + result.toString());
    }
  } on PlatformException {
    showToast(context, '你已登录或者其他错误');
  }
}

Future<void> loginOut(BuildContext context) async {
  final model = Provider.of<GlobalModel>(context, listen: false);

  try {
    var result = await im.imLogout();
    if (result.toString().contains('ucc')) {
      showToast(context, '登出成功');
    } else {
      print('error::' + result.toString());
    }
    model.goToLogin = true;
    model.refresh();
    await SharedUtil.instance.saveBoolean(Keys.hasLogged, false);
    await routePushAndRemove(new LoginBeginPage());
  } on PlatformException {
    model.goToLogin = true;
    model.refresh();
    await SharedUtil.instance.saveBoolean(Keys.hasLogged, false);
    await routePushAndRemove(new LoginBeginPage());
  }
}

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/pages/login/login_begin_page.dart';
import 'package:wechat_flutter/pages/root/root_page.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

Future<void> init(BuildContext context) async {}

Future<void> login(String userName, BuildContext context) async {
  Get.offAll(new RootPage());
}

Future<void> loginOut(BuildContext context) async {
  final model = Provider.of<GlobalModel>(context, listen: false);

  try {
    showToast(context, '登出成功');
    model.goToLogin = true;
    model.refresh();
    await SharedUtil.instance.saveBoolean(Keys.hasLogged, false);
    await Get.offAll(new LoginBeginPage());
  } on PlatformException {
    model.goToLogin = true;
    model.refresh();
    await SharedUtil.instance.saveBoolean(Keys.hasLogged, false);
    await Get.offAll(new LoginBeginPage());
  }
}

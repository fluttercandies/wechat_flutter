import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_callback.dart';
import 'package:wechat_flutter/im/im_handle/Im_api.dart';
import 'package:wechat_flutter/pages/login/login_begin_page.dart';
import 'package:wechat_flutter/pages/root/root_page.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

Future<void> login(String userName, BuildContext context) async {
  final model = Provider.of<GlobalModel>(context, listen: false);

  try {
    V2TimCallback result = await ImApi.login(userName);
    if (result == null) {
      showToast(context, '出现错误');
      return;
    }
    if (result.code == 0) {
      model.account = userName;
      model.goToLogin = false;
      await SharedUtil.instance.saveString(Keys.account, userName);
      await SharedUtil.instance.saveBoolean(Keys.hasLogged, true);
      model.refresh();
      Get.offAll(new RootPage());
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
    V2TimCallback result = await ImApi.logout();
    if (result.code == 0) {
      showToast(context, '登出成功');
    } else {
      print('error::' + result.toString());
    }
  } catch (e) {
    print("退出登录出现错误");
    showToast(context, '登出失败');
  }
  model.goToLogin = true;
  model.refresh();
  await SharedUtil.instance.saveBoolean(Keys.hasLogged, false);
  await SharedUtil.instance.saveString(Keys.account, "");
  await Get.offAll(new LoginBeginPage());
}

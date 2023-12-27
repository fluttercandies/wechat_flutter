import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_callback.dart';
import 'package:wechat_flutter/im/im_handle/Im_api.dart';
import 'package:wechat_flutter/pages/common/login/login_begin_page.dart';
import 'package:wechat_flutter/pages/root/root/root_view.dart';
import 'package:wechat_flutter/tools/config/keys.dart';
import 'package:wechat_flutter/tools/data/data.dart';
import 'package:wechat_flutter/tools/provider/global_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

Future<void> login(BuildContext context, String userId) async {
  final model = Provider.of<GlobalModel>(context, listen: false);

  try {
    V2TimCallback? result = await ImApi.login(userId);
    if (result == null) {
      q1Toast( '出现错误');
      return;
    }
    if (result.code == 0) {
      /// 数据初始化
      await Q1Data.initData();

      model.setAccount(userId);
      model.setGoToLogin(false);
      await SharedUtil.instance!.saveString(Keys.account, userId);
      await SharedUtil.instance!.saveBoolean(Keys.hasLogged, true);
      model.refresh();
      Get.offAll(new RootPage());
    } else {
      print('error::' + result.toString());
    }
  } on PlatformException {
    q1Toast( '你已登录或者其他错误');
  }
}

Map a = {
  "id": "feb76057-619b-4536-bc6e-8147047ec19c",
  "first_name": "",
  "last_name": "",
  "email": "13244766725@13244766725.com",
  "password": "**********",
  "location": "",
  "title": "",
  "description": "",
  "tags": [],
  "avatar": "",
  "language": "",
  "theme": "auto",
  "tfa_secret": "",
  "status": "active",
  "role": "84f7dc59-dea9-42ee-9d47-e678f1aff0ec",
  "token": "",
  "last_access": "2022-10-11T20:34:49.000Z",
  "last_page": "",
  "provider": "default",
  "external_identifier": "",
  "auth_data": "",
  "email_notifications": true,
  "kid": "10005",
  "mobile": "13244766725",
  "nickname": ""
};

Future<void> loginOut(BuildContext? context, {String? tip}) async {
  GlobalModel? model;
  if (context?.owner != null) {
    model = Provider.of<GlobalModel>(context!, listen: false);
  }
  print("调用退出登录，tip:$tip");
  try {
    V2TimCallback result = await ImApi.logout();
    if (result.code == 0) {
      if (context != null) q1Toast( tip ?? '登出成功');
    } else {
      print('error::' + result.toString());
    }
  } catch (e) {
    print("退出登录出现错误");
    if (!strNoEmpty(tip)) {
      if (context != null) q1Toast( tip ?? '登出失败');
    }
  }
  model?.setGoToLogin(true);
  model?.refresh();
  await SharedUtil.instance!.saveBoolean(Keys.hasLogged, false);
  await SharedUtil.instance!.saveString(Keys.account, "");

  /// 数据清除
  await Q1Data.clearData();

  await Get.offAll(new LoginBeginPage());
}

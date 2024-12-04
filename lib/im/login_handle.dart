import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSDKListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/log_level_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_status.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

import '../pages/root/root_page.dart';
import 'GenerateUserSig.dart';

class ImLoginManager {
  static V2TimSDKListener? _sdkListener;

  // 默认时间：7 x 24 x 60 x 60 = 604800 = 7 天
  static const int expireTime = 604800;

  static Future<void> init(BuildContext context) async {
    _sdkListener = V2TimSDKListener(
      onConnectFailed: (int code, String error) {
        log("[ImLoginManager] onConnectFailed code:$code error:$error");
      },
      onConnectSuccess: () {
        log("[ImLoginManager] onConnectSuccess");
      },
      onConnecting: () {
        log("[ImLoginManager] onConnecting");
      },
      onKickedOffline: () {
        log("[ImLoginManager] onKickedOffline");
      },
      onSelfInfoUpdated: (V2TimUserFullInfo info) {
        log("[ImLoginManager] onSelfInfoUpdated, ${json.encode(info)}");
      },
      onUserSigExpired: () {
        log("[ImLoginManager] onUserSigExpired");
      },
      onUserStatusChanged: (List<V2TimUserStatus> userStatusList) {
        log("[ImLoginManager] onUserStatusChanged, ${json.encode(userStatusList)}");
      },
    );
    V2TimValueCallback<bool> initSDKRes =
        await TencentImSDKPlugin.v2TIMManager.initSDK(
      sdkAppID: appId, // SDKAppID
      loglevel: LogLevelEnum.V2TIM_LOG_ALL, // 日志登记等级
      listener: _sdkListener!, // 事件监听器
    );

    if (initSDKRes.code == 0) {
      debugPrint('初始化结果 ======>   ${json.encode(initSDKRes)}');
    } else {
      showToast("初始化失败");
    }
  }

  static Future<void> login(String userName, BuildContext context) async {
    final model = Provider.of<GlobalModel>(context, listen: false);

    //初始化成功
    GenerateDevUsersigForTest generateDevUsersigForTest =
        GenerateDevUsersigForTest(sdkappid: appId, key: appKey);
    String userSig = generateDevUsersigForTest.genSig(
        identifier: userName, expire: expireTime);
    V2TimCallback loginRes = await TencentImSDKPlugin.v2TIMManager
        .login(userID: userName, userSig: userSig);
    print("login ==> " + json.encode(loginRes));

    V2TimCallback call = await TencentImSDKPlugin.v2TIMManager
        .login(userID: userName, userSig: userSig);
    if (call.code == 0) {
      model.account = userName;
      model.goToLogin = false;
      await SharedUtil.instance.saveString(Keys.account, userName);
      await SharedUtil.instance.saveBoolean(Keys.hasLogged, true);
      model.refresh();
      await Get.offAll(new RootPage());
    } else {
      showToast("登录失败: ${call.desc}");
    }
  }

  static Future<void> loginOut(BuildContext context) async {
    final model = Provider.of<GlobalModel>(context, listen: false);

    // try {
    //   var result = await im.imLogout();
    //   if (result.toString().contains('ucc')) {
    //     showToast( '登出成功');
    //   } else {
    //     print('error::' + result.toString());
    //   }
    //   model.goToLogin = true;
    //   model.refresh();
    //   await SharedUtil.instance.saveBoolean(Keys.hasLogged, false);
    //   await Get.toAndRemove(new LoginBeginPage());
    // } on PlatformException {
    //   model.goToLogin = true;
    //   model.refresh();
    //   await SharedUtil.instance.saveBoolean(Keys.hasLogged, false);
    //   await Get.toAndRemove(new LoginBeginPage());
    // }
  }
}

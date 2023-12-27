import 'dart:convert';

import 'package:wechat_flutter/tools/config/keys.dart';
import 'package:wechat_flutter/tools/entity/api_entity.dart';
import 'package:wechat_flutter/tools/commom/check.dart';
import 'package:wechat_flutter/tools/data/store.dart';
import 'package:wechat_flutter/tools/func/shared_util.dart';

class WeChatActions {
  static String msg() => 'msg';

  static String groupName() => 'groupName';

  static String voiceImg() => 'voiceImg';

  static String user() => 'user';
}

class Q1Data {
  static UserInfoRspEntity? userInfoRspEntity;
  static LoginRspEntity? loginRspEntity;
  static String? userSig;

  static bool get isLogin {
    return loginRspEntity == null;
  }

  static String? get tokenOfRefresh {
    return loginRspEntity?.refreshToken;
  }

  /// 格式化之后token
  static String get tokenFmt {
    if (!strNoEmpty(loginRspEntity?.accessToken)) {
      return "";
    }
    return "Bearer " + loginRspEntity!.accessToken!;
  }

  static String msg() => Store(WeChatActions.msg()).value ?? '';

  /// kUserId
  static String user() => Store(WeChatActions.user()).value ?? '';

  static String get loginUserId => user();

  static String voiceImg() => Store(WeChatActions.voiceImg()).value ?? '';

  static Future initData() async {
    getStoreValue(Keys.account).then((data) {
      Store(WeChatActions.user()).value = data;
    });
    getStoreValue(Keys.loginResult).then((data) {
      print("登录结果::$data");
      if (strNoEmpty(data)) {
        loginRspEntity = LoginRspEntity.fromJson(json.decode(data!));
      }
    });
    getStoreValue(Keys.userMe).then((data) {
      if (strNoEmpty(data)) {
        userInfoRspEntity = UserInfoRspEntity.fromJson(json.decode(data!));
      }
    });
  }

  static Future clearData() async {
    loginRspEntity = null;
    Store(WeChatActions.user()).value = "";
    SharedUtil.instance!.saveString(Keys.loginResult, "");
    SharedUtil.instance!.saveString(Keys.userMe, "");
  }
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/entity/api_entity.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class ApiV2 {
  /// 注册
  static Future<bool> register(
    BuildContext context, {
    required String phone,
    required String password,
    required String code,
    required String? token,
  }) async {
    if (!strNoEmpty(token)) {
      q1Toast( '请先获取验证码');
      return false;
    }
    if (!strNoEmpty(phone)) {
      q1Toast( "请输入手机号");
      return false;
    }
    if (!strNoEmpty(password)) {
      q1Toast( "请输入密码");
      return false;
    }
    if (!strNoEmpty(code)) {
      q1Toast( "请输入验证码");
      return false;
    }

    Map<String, dynamic> params = {
      "phone": phone,
      "password": password,
      "code": code,
      "token": token,
      "privacy": true,
    };

    Completer<bool> completer = Completer<bool>();

    Req.getInstance()!.post(
      ApiUrlV2.register,
      (v) async {
        completer.complete(true);

        /// 注册完立刻调用一次登录，否则uid不存在腾讯云im
        login(context, phone, password);
      },
      params: params,
      errorCallBack: (String? msg, int? code) {
        q1Toast( msg);
        completer.complete(false);
      },
    );
    return completer.future;
  }

  /// 获取验证码
  static Future<CodeRspEntity?> smsGet(
    BuildContext context, {
    required String phone,
  }) async {
    if (!strNoEmpty(phone)) {
      q1Toast( '请输入手机号');
      return null;
    }

    Completer<CodeRspEntity?> completer = Completer<CodeRspEntity?>();

    Map<String, dynamic> params = {"phone": phone};

    Req.getInstance()!.get(
      ApiUrlV2.smsGet,
      (v) async {
        CodeRspEntity codeRspEntity = CodeRspEntity.fromJson(v);
        completer.complete(codeRspEntity);
      },
      params: params,
      errorCallBack: (String? msg, int? code) {
        q1Toast( msg);
        completer.complete(null);
      },
    );
    return completer.future;
  }

  /// 获取自己的信息
  static Future<UserInfoRspEntity?> userMe(BuildContext context) async {
    Map<String, dynamic> params = {};

    Completer<UserInfoRspEntity?> completer = Completer<UserInfoRspEntity?>();
    Req.getInstance()!.get(
      ApiUrlV2.userMe,
      (v) async {
        Q1Data.userInfoRspEntity = UserInfoRspEntity.fromJson(v['data']);
        SharedUtil.instance!
            .saveString(Keys.userMe, json.encode(Q1Data.userInfoRspEntity));
        completer.complete(Q1Data.userInfoRspEntity);
      },
      params: params,
      errorCallBack: (String? msg, int? code) {
        q1Toast( msg);
        completer.complete(null);
      },
    );
    return completer.future;
  }

  /// 登录
  static Future<LoginRspEntity?> login(
      BuildContext context, String phone, String password) async {
    if (!strNoEmpty(phone)) {
      q1Toast( '请输入手机号');
      return null;
    }
    if (!strNoEmpty(password)) {
      q1Toast( '请输入密码');
      return null;
    }

    Map<String, dynamic> params = {
      "email": '$phone@$phone.com',
      "password": password,
    };

    Completer<LoginRspEntity?> completer = Completer<LoginRspEntity?>();
    Req.getInstance()!.post(
      ApiUrlV2.login,
      (v) async {
        LoginRspEntity rspEntity = LoginRspEntity.fromJson(v['data']);
        completer.complete(rspEntity);
      },
      params: params,
      errorCallBack: (String? msg, int? code) {
        q1Toast( msg);
        completer.complete(null);
      },
    );
    return completer.future;
  }

  /// 获取腾讯云签名
  static Future<String?> timGetSig(BuildContext context) async {
    Map<String, dynamic> params = {};

    Completer<String?> completer = Completer<String?>();
    Req.getInstance()!.get(
      ApiUrlV2.timGetSig,
      (v) async {
        completer.complete(v["sig"]);
      },
      params: params,
      errorCallBack: (String? msg, int? code) {
        q1Toast( msg);
        completer.complete(null);
      },
    );
    return completer.future;
  }

  /// 搜索用户
  static Future<UserInfoRspEntity?> searchUser(
      BuildContext? context, String value) async {
    if (!strNoEmpty(value)) {
      q1Toast( '搜索内容不能为空');
      return null;
    }

    Map<String, dynamic> params = {
      /// 需要服务端返回的字段，不传则返回所有的字段。
      "fields": ["kid", "mobile", "id"],
      "filter": {
        "_or": [
          {
            "mobile": {"_eq": value}
          },
          {
            "kid": {"_eq": value}
          }
        ]
      },
    };

    Completer<UserInfoRspEntity?> completer = Completer<UserInfoRspEntity?>();
    Req.getInstance()!.get(
      ApiUrlV2.searchUser,
      (v) async {
        if (!listNoEmpty(v['data'])) {
          completer.complete(null);
          return;
        }
        UserInfoRspEntity userInfoRspEntity =
            UserInfoRspEntity.fromJson(v['data'][0]);
        completer.complete(userInfoRspEntity);
      },
      params: params,
      errorCallBack: (String? msg, int? code) {
        q1Toast( msg);
        completer.complete(null);
      },
    );
    return completer.future;
  }

  /// 更新用户资料
  static void updateUserInfo(
    BuildContext? context,
    String id, {
    String? avatar,
    String? nickname,
  }) async {
    Map<String, dynamic> params = {
      "avatar": avatar,
      "nickname": nickname,
    };

    Req.getInstance()!.patch(
      ApiUrlV2.updateUserInfo + id,
      (v) async {},
      params: params,
      errorCallBack: (String? msg, int? code) {
        q1Toast( msg);
      },
    );
  }

  /// 上传图片
  static Future<String?> uploadFile(
      BuildContext context, String title, File file) async {
    if (!strNoEmpty(title)) {
      q1Toast( '用户错误');
      return null;
    }
    if (file == null) {
      q1Toast( '文件不能为空');
      return null;
    }

    MultipartFile fileData = await MultipartFile.fromFile(file.path);
    FormData params = FormData.fromMap({"title": title, "file": fileData});

    Completer<String?> completer = Completer<String?>();

    Req.getInstance()!.postUpload(
      ApiUrlV2.uploadFile,
      (v) async {
        completer.complete(v['data']['id']);
      },
      (int count, int total) {},
      formData: params,
      errorCallBack: (String? msg, int? code) {
        q1Toast( msg);
        completer.complete(null);
      },
    );
    return completer.future;
  }

  /// 更新图片
  static Future<String?> fileChange(
      BuildContext context, String avatarId, String title, File? file) async {
    if (!strNoEmpty(avatarId)) {
      q1Toast( '旧图片id不能为空');
      return null;
    }

    if (!strNoEmpty(title)) {
      q1Toast( '用户错误');
      return null;
    }

    if (file == null) {
      q1Toast( '文件不能为空');
      return null;
    }

    MultipartFile fileData = await MultipartFile.fromFile(file.path);
    FormData params = FormData.fromMap({"title": title, "file": fileData});
    Completer<String?> completer = Completer<String?>();

    Req.getInstance()!.patchUpload(
      ApiUrlV2.fileChange + avatarId,
      (v) async {
        completer.complete(v['data']['id']);
      },
      (int count, int total) {},
      formData: params,
      errorCallBack: (String? msg, int? code) {
        q1Toast( msg);

        completer.complete(null);
      },
    );

    return completer.future;
  }

  /// 刷新token
  ///
  /// 只要不是登录和注册接口，其他接口出现401，调用此方法，获取到新token后重新调用原本方法。
  static Future<LoginRspEntity?> authRefresh(BuildContext? context) async {
    final String? loginResult =
        await SharedUtil.instance!.getString(Keys.loginResult);
    if (!strNoEmpty(loginResult)) {
      return null;
    }

    LoginRspEntity loginRspEntityStore =
        LoginRspEntity.fromJson(json.decode(loginResult!));

    Map<String, dynamic> params = {
      "refresh_token": loginRspEntityStore.refreshToken,
      "mode": "json",
    };

    Completer<LoginRspEntity?> completer = Completer<LoginRspEntity?>();

    Req.getInstance()!.patch(
      ApiUrlV2.authRefresh,
      (v) async {
        LoginRspEntity loginRspEntity = LoginRspEntity.fromJson(v['data']);
        completer.complete(loginRspEntity);
      },
      params: params,
      errorCallBack: (String? msg, int? code) {
        q1Toast( msg);
        completer.complete(null);
      },
    );
    return completer.future;
  }
}

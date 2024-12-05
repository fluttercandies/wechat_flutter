import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

Future<String?> getRemarkMethod(String id) async {
  // try {
  //   var result = await im.getRemark(id);
  //   callback(result);
  //   return result;
  // } on PlatformException {
  //   print('获取备注失败');
  // } on MissingPluginException {
  //   print('插件内这个功能IOS版还在开发中');
  // }
  return "";
}

Future<bool> setUsersProfileMethod(
  BuildContext context, {
  String nickNameStr = '',
  String avatarStr = '',
}) async {
  final model = Provider.of<GlobalModel>(context, listen: false);
  final String? currentUser = (await V2TIMManager().getLoginUser()).data;
  if (!strNoEmpty(currentUser)) {
    log('error: Current user is empty');
    return false;
  }
  final V2TimUserFullInfo? v2timUserFullInfo =
      (await V2TIMManager().getUsersInfo(userIDList: [currentUser!]))
          .data
          ?.first;
  if (v2timUserFullInfo == null) {
    log('error: Current user info is empty');
    return false;
  }
  if (nickNameStr.isNotEmpty) {
    v2timUserFullInfo.nickName = nickNameStr;
  }
  if (avatarStr.isNotEmpty) {
    v2timUserFullInfo.faceUrl = avatarStr;
  }
  final V2TimCallback value =
      await V2TIMManager().setSelfInfo(userFullInfo: v2timUserFullInfo);
  if (value.code == 0) {
    if (strNoEmpty(nickNameStr)) {
      model.nickName = nickNameStr;
    }
    if (strNoEmpty(avatarStr)) {
      model.avatar = avatarStr;
    }
  }
  return value.code == 0;
}

Future<List<V2TimUserFullInfo>> getUsersProfile(List<String> users) async {
  final V2TimValueCallback<List<V2TimUserFullInfo>> call =
      await V2TIMManager().getUsersInfo(userIDList: users);
  return call.data ?? [];
}

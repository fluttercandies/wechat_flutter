import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

Future<dynamic> getConversationsListData({Callback callback}) async {
  try {
    var result = await im.getConversations();
    String strData = result.toString().replaceAll("'", '"');
    return strData;
  } on PlatformException {
    debugPrint('获取会话列表失败');
  }
}

Future<dynamic> deleteConversationAndLocalMsgModel(int type, String id,
    {Callback callback}) async {
  try {
    var result = await im.deleteConversationAndLocalMsg(type, id);
    callback(result);
  } on PlatformException {
    print("删除会话和聊天记录失败");
  }
}

Future<dynamic> delConversationModel(String identifier, int type,
    {Callback callback}) async {
  try {
    var result = await im.delConversation(identifier, type);
    callback(result);
  } on PlatformException {
    print("删除会话失败");
  }
}

Future<dynamic> getUnreadMessageNumModel(int type, String id,
    {Callback callback}) async {
  try {
    var result = await im.getUnreadMessageNum(type, id);
    callback(result);
  } on PlatformException {
    print("获取未读消息数量失败");
  }
}

Future<dynamic> setReadMessageModel(int type, String id,
    {Callback callback}) async {
  try {
    var result = await im.setReadMessage(type, id);
    callback(result);
  } on PlatformException {
    print("设置消息为已读失败");
  }
}
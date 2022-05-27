import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

Future<dynamic> getConversationsListData({Callback callback}) async {}

Future<dynamic> deleteConversationAndLocalMsgModel(int type, String id,
    {Callback callback}) async {}

Future<dynamic> delConversationModel(String identifier, int type,
    {Callback callback}) async {}

Future<dynamic> getUnreadMessageNumModel(int type, String id,
    {Callback callback}) async {}

Future<dynamic> setReadMessageModel(int type, String id,
    {Callback callback}) async {}

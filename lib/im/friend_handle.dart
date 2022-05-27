import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

typedef OnSuCc = void Function(bool v);

Future<dynamic> addFriend(String userName, BuildContext context,
    {OnSuCc suCc}) async {
  showToast(context, '添加成功');
}

Future<dynamic> delFriend(String userName, BuildContext context,
    {OnSuCc suCc}) async {}

Future<dynamic> getContactsFriends(String userName) async {}

Future<dynamic> createGroupChat(List<String> personList,
    {String name, Callback callback}) async {}

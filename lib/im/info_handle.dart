import 'package:provider/provider.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

import 'package:flutter/material.dart';

Future<dynamic> getRemarkMethod(String id, {Callback callback}) async {}

Future<dynamic> setUsersProfileMethod(
  BuildContext context, {
  Callback callback,
  String nickNameStr = '',
  String avatarStr = '',
}) async {}

Future<dynamic> getUsersProfile(List<String> users,
    {Callback callback}) async {}

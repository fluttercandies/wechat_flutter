import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_flutter/tools/commom.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

Future<dynamic> getDimMessages(String id,
    {int type, Callback callback, int num = 50}) async {}

Future<void> sendImageMsg(String userName, int type,
    {Callback callback, ImageSource source, File file}) async {}

Future<dynamic> sendSoundMessages(String id, String soundPath, int duration,
    int type, Callback callback) async {}

import 'dart:async';
import 'dart:io';

import 'package:dim_example/tools/wechat_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

var subscription = Connectivity();

Future<File> compressFile(File file) async {
  try {
    File result = await FlutterNativeImage.compressImage(file.absolute.path,
        quality: 80, percentage: 50);
    debugPrint('图片压缩中');
    print(file.lengthSync());
    print(result.length);
    return result;
  } catch (e) {
    debugPrint('e => ${e.toString()}');
    return null;
  }
}

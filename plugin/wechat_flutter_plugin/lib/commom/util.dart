import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

Future<File> singleCompressFile(File file) async {
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

Future<List<int>> compressFile(File file) async {
  try {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 200,
      minHeight: 300,
      quality: 80,
    );
    print(file.lengthSync());
    print(result.length);
    return result;
  } catch (e) {
    print('e => ${e.toString()}');
    return null;
  }
}

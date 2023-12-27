/*
* 屏幕适配
* SizeConfig().init(context); 初始化
* height: SizeConfig.blockSizeVertical * 20,
* width: SizeConfig.blockSizeHorizontal * 50,
*
* screen
* width: SizeConfig.screenWidth,
* height: SizeConfig.screenHeight,
*
* 字体 （均可）
* SizeConfig.safeBlockHorizontal
* SizeConfig.blockSizeVertical
*
***/
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static double? blockSizeVertical;

  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static double? safeBlockHorizontal;
  static double? safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
}

Future<File> singleCompressFile(File file) async {
  return file;
//  try {
//    File result = await FlutterNativeImage.compressImage(file.absolute.path,
//        quality: 80, percentage: 50);
//    debugPrint('图片压缩中');
//    print(file.lengthSync());
//    print(result.length);
//    return result;
//  } catch (e) {
//    debugPrint('e => ${e.toString()}');
//    return null;
//  }
}

Future<List<int>?> compressFile(File file) async {
  try {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 200,
      minHeight: 300,
      quality: 80,
    );
    print(file.lengthSync());
    if (result != null) {
      print(result.length);
    }
    return result;
  } catch (e) {
    print('e => ${e.toString()}');
    return null;
  }
}

Future<File?> compressFileGetFile(File file) async {
  try {
    Directory tempDir = await getTemporaryDirectory();

    final String fileName = file.path.split("/").last;

    final String fullPathOfResult = tempDir.path + "/" + "$fileName";

    print("你要压缩的图片为::${file.absolute.path}");
    print("结果路径::$fullPathOfResult");

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      fullPathOfResult,
      minWidth: 200,
      minHeight: 300,
      quality: 70,
      format: fileName.endsWith("png") || fileName.endsWith("PNG")
          ? CompressFormat.png
          : CompressFormat.jpeg,
    );
    print(file.lengthSync());
    return result;
  } catch (e) {
    print('e => ${e.toString()}');
    return null;
  }
}

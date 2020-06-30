import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat_flutter/config/provider_config.dart';
import 'package:wechat_flutter/app.dart';
import 'package:wechat_flutter/tools/data/data.dart';

import 'config/storage_manager.dart';

void main() async {
  /// 确保初始化
  WidgetsFlutterBinding.ensureInitialized();

  /// 数据初始化
  await Data.initData();

  /// 配置初始化
  await StorageManager.init();

  /// APP入口并配置Provider
  runApp(ProviderConfig.getInstance().getGlobal(MyApp()));

  /// 自定义报错页面
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
    debugPrint(flutterErrorDetails.toString());
    return new Center(child: new Text("App错误，快去反馈给作者!"));
  };

  /// Android状态栏透明
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

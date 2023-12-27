import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:wechat_flutter/tools/config/provider_config.dart';
import 'package:wechat_flutter/app.dart';
import 'package:wechat_flutter/tools/data/data.dart';
import 'package:wechat_flutter/tools/test/live_log_page.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/video/other/sp_util.dart';

import 'tools/config/storage_manager.dart';

Logger get q1Logger => Logger.root;

void main() async {
  /// 确保初始化
  WidgetsFlutterBinding.ensureInitialized();

  /// 配置初始化
  await StorageManager.init();

  /// sp初始化
  await SpUtil.perInit();

  /// 数据初始化
  await Q1Data.initData();

  /// 自定义报错页面
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
    debugPrint(flutterErrorDetails.toString());
    return Material(
      type: MaterialType.transparency,
      child: new Center(child: new Text("App错误，快去反馈给作者!")),
    );
  };

  /// Android状态栏透明
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    final String str =
        '${strNoEmpty(record.message) ? ": " : ""}${record.message}';
    LogUtil.vPrint(str);
    LiveLogPageData.writeData(str);
    LiveLogPageData.writeData("\n");
  });


  /// APP入口并配置Provider
  runApp(ProviderConfig.getInstance()!.getGlobal(MyApp()));
}

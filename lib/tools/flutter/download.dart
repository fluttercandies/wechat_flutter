import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadUtil {
  // 申请权限
  static Future<bool> checkPermission(context) async {
    // 先对所在平台进行判断
    if (Theme.of(context).platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  static init() {
    FlutterDownloader.initialize();
  }

  // 根据 downloadUrl 和 savePath 下载文件
  static downloadFile(downloadUrl, uuid, {VoidCallback callback}) async {
    print('downUrl:$downloadUrl');

    final result = await FlutterDownloader.enqueue(
      url: downloadUrl,
      fileName: uuid,
      savedDir: await savePath,
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
    callback();
    print('downUrl:::Result:$result');
  }

  //语音下载
  static downloadVoice(String downUrl, String uuid,
      {VoidCallback callback}) async {
    print('downUrl:$downUrl');
    print('uuid:$uuid');
    print('savePath:${await savePath}');

    await FlutterDownloader.loadTasks();

    await FlutterDownloader.enqueue(
      url: downUrl,
      savedDir: await savePath,
      fileName: uuid,
      showNotification: false,
      // show download progress in status bar (for Android)
      openFileFromNotification:
          false, // click on notification to open downloaded file (for Android)
    );

//    FlutterDownloader.registerCallback(
//        (String id, DownloadTaskStatus status, int progress) {
//      print(
//          'Download task ($id) is in status ($status) and process ($progress)');
////      if (status == DownloadTaskStatus.complete) {
////        callback();
////        print('文件下载成功');
/////*
////      OpenFile.open(savePath);
////*/
//////        FlutterDownloader.open(taskId: id);
////      }
//    });
  }

  static Future<String> get savePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}

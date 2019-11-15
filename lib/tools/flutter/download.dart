import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/material.dart';

class DownloadUtil {
  //语音下载
  static downloadVoice(String downUrl, String uuid,
      {VoidCallback callback}) async {
    print('downUrl:$downUrl');

    FlutterDownloader.registerCallback((id, status, progress) {
      print(
          'Download task ($id) is in status ($status) and process ($progress)');
      if (status == DownloadTaskStatus.complete) {
        callback();
        print('文件下载成功');
/*
      OpenFile.open(savePath);
*/
//        FlutterDownloader.open(taskId: id);
      }
    });
    final taskId = await FlutterDownloader.enqueue(
      url: downUrl,
      savedDir: await savePath,
      fileName: uuid,
      showNotification: false,
      // show download progress in status bar (for Android)
      openFileFromNotification:
          false, // click on notification to open downloaded file (for Android)
    );

    final tasks = await FlutterDownloader.loadTasks();
  }

  static Future<String> get savePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}

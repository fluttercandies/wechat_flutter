import 'dart:typed_data';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:flutter_video_info/flutter_video_info.dart';

class VideoUtilModel {
  /// 视频时长，单位秒
  final int duration;

  /// 封面路径
  final String coverPath;

  VideoUtilModel(this.duration, this.coverPath);

  @override
  String toString() {
    return 'VideoUtilModel{duration: $duration, coverPath: $coverPath}';
  }
}

class VideoUtil {
  /// 保存封面
  /// 返回值：文件路径
  static Future<String?> saveCover(Uint8List imageBytes) async {
    final result = await ImageGallerySaver.saveImage(imageBytes,
        quality: 60, name: "cover_${DateTime.now().millisecondsSinceEpoch}");
    return result['filePath'];
  }

  /// 获取视频时长
  static Future<VideoUtilModel> getVideoDuration(String videoPath) async {
    try {
      final videoInfo = FlutterVideoInfo();
      final VideoData? info = await videoInfo.getVideoInfo(videoPath);

      final int secondDuration = (info?.duration?.toInt() ?? 0) ~/ 1000;

      return VideoUtilModel(secondDuration, ""); //saveCov
    } catch (e) {
      LogUtil.d("出现异常::${e.toString()}");
      return VideoUtilModel(0, ""); //saveCov
    }
  }
}

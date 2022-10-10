import 'dart:typed_data';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

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
  static Future<String> saveCover(Uint8List imageBytes) async {
    final result = await ImageGallerySaver.saveImage(imageBytes,
        quality: 60, name: "cover_${DateTime.now().millisecondsSinceEpoch}");
    return result['filePath'];
  }

  /// 获取视频时长
  static Future<VideoUtilModel> getVideoDuration(String url) async {
    FijkPlayer player = new FijkPlayer();
    player.setOption(FijkOption.hostCategory, "enable-snapshot", 1);

    Completer<VideoUtilModel> completer = Completer<VideoUtilModel>();
    try {
      player.setDataSource(url);
      player.prepareAsync();
      player.addListener(() async {
        player.prepareAsync();
        // String saveCoverValue = await saveCover(await player.takeSnapShot());

        VideoUtilModel model = VideoUtilModel(
            player.value.duration.inSeconds, ""); //saveCoverValue
        print("最终数据::${model.toString()}");
        completer.complete(model);

        player.removeListener(() {});
        // player.dispose();
      });
    } catch (e) {
      print("getVideoDuration出现错误：：${e.toString()}");
      return VideoUtilModel(0, "");
    }

    return completer.future;
  }
}

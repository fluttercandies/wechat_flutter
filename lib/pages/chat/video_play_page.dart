import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:dim_example/tools/wechat_flutter.dart';

class VideoPlayPage extends StatefulWidget {
  final String url;

  VideoPlayPage(this.url);

  @override
  State<StatefulWidget> createState() => VideoPlayPageState();
}

class VideoPlayPageState extends State<VideoPlayPage> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  ChewieController _cheWieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(widget.url);
    _cheWieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 9 / 14.2,
      autoPlay: true,
      looping: false,
    );
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _cheWieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: ThemeData.dark()
          .copyWith(platform: _platform ?? Theme.of(context).platform),
      child: new Scaffold(
        appBar: new ComMomBar(title: '视频预览'),
        body: new Chewie(controller: _cheWieController),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/pages/common/chat/video_play_page.dart';

// import 'package:wechat_flutter/pages/common/chat/video_play_page.dart';
import 'package:wechat_flutter/tools/provider/global_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/massage/img_item_container.dart';
import 'package:wechat_flutter/ui/message_view/msg_avatar.dart';

class VideoMessage extends StatefulWidget {
  final V2TimMessage model;

  VideoMessage(this.model);

  @override
  _VideoMessageState createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
  Widget time() {
    return new Container(
      margin: EdgeInsets.only(right: 8.0, bottom: 5.0),
      alignment: Alignment.bottomRight,
      child: new Text(
        '0:0${widget.model.videoElem!.duration}',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    List<Widget> body = [
      new MsgAvatar(model: widget.model, globalModel: globalModel),
      Space(width: 5),
      new ImgItemContainer(
        height: 210,
        child: new GestureDetector(
          child: new Stack(
            alignment: Alignment.center,
            children: <Widget>[
              new ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: new CachedNetworkImage(
                  imageUrl: '${widget.model.videoElem!.snapshotUrl}',
                  width: double.parse(
                      '${widget.model.videoElem!.snapshotWidth}.0'),
                  height: double.parse(
                      '${widget.model.videoElem!.snapshotHeight}.0'),
                  fit: BoxFit.cover,
                  cacheManager: cacheManager,
                ),
              ),
              new Image.asset(
                'assets/images/ic_chat_play_icon.png',
                color: Colors.white.withOpacity(0.5),
              ),
              time(),
            ],
          ),
          onTap: () {
            Get.to(VideoPlayPage(widget.model.videoElem!.videoUrl));
          },
        ),
      ),
      new Spacer(),
    ];

    if (widget.model.sender == globalModel.account) {
      body = body.reversed.toList();
    } else {
      body = body;
    }

    return Container(
      // type: 1,
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: new Row(children: body),
    );
  }
}

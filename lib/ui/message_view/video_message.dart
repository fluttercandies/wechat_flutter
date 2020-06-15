//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:flutter/material.dart';
//import 'package:wechat_flutter/pages/chat/video_play_page.dart';
//import 'package:wechat_flutter/tools/wechat_flutter.dart';
//import 'package:wechat_flutter/ui/massage/img_item_container.dart';
//import 'package:wechat_flutter/ui/massage/vertical_container.dart';
//import 'package:wechat_flutter/ui/message_view/wai2.dart';
//
//class VideoMessage extends StatefulWidget {
//  final dynamic video;
//  final int type;
//  final dynamic data;
//
//  VideoMessage(this.video, this.type, this.data);
//
//  @override
//  _VideoMessageState createState() => _VideoMessageState();
//}
//
//class _VideoMessageState extends State<VideoMessage> {
//  Widget time() {
//    return new Container(
//      margin: EdgeInsets.only(right: 8.0, bottom: 5.0),
//      alignment: Alignment.bottomRight,
//      child: new Text(
//        '0:0${widget.video['video']['duaration']}',
//        style: TextStyle(color: Colors.white),
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (widget.type == 1) {
//      return VerticalContainer(
//        type: 1,
//        children: <Widget>[
//          new MassageAvatar(widget.data, type: 1),
//          new ImgItemContainer(
//              height: 210,
//              child: new GestureDetector(
//                child: new Stack(
//                  alignment: Alignment.center,
//                  children: <Widget>[
//                    new ClipRRect(
//                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                      child: new CachedNetworkImage(
//                        imageUrl:
//                            '${widget.video['snapshot']['urls'].toString() == '[]' ? defContentImg : widget.video['snapshot']['urls'][0].toString()}',
//                        width: double.parse(
//                            '${widget.video['snapshot']['width']}.0'),
//                        height: double.parse(
//                            '${widget.video['snapshot']['height']}.0'),
//                        fit: BoxFit.cover,
//                        cacheManager: cacheManager,
//                      ),
//                    ),
//                    new Image.asset('assets/images/ic_chat_play_icon.webp'),
//                    time(),
//                  ],
//                ),
//                onTap: () {
//                  routePush(
//                    VideoPlayPage(widget.video['video']['urls'][0]),
//                  );
//                },
//              )),
//        ],
//      );
//    } else {
//      return VerticalContainer(
//        type: 2,
//        children: <Widget>[
//          new ImgItemContainer(
//              height: 210,
//              child: new GestureDetector(
//                child: new Stack(
//                  alignment: Alignment.center,
//                  children: <Widget>[
//                    new ClipRRect(
//                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                      child: new CachedNetworkImage(
//                        imageUrl:
//                            '${widget.video['snapshot']['urls'].toString() == '[]' ? defContentImg : widget.video['snapshot']['urls'][0].toString()}',
//                        width: double.parse(
//                            '${widget.video['snapshot']['width']}.0'),
//                        height: double.parse(
//                            '${widget.video['snapshot']['height']}.0'),
//                        fit: BoxFit.cover,
//                        cacheManager: cacheManager,
//                      ),
//                    ),
//                    new Image.asset('assets/images/ic_chat_play_icon.webp'),
//                    time(),
//                  ],
//                ),
//                onTap: () {
//                  routePush(
//                    VideoPlayPage(widget.video['video']['urls'][0]),
//                  );
//                },
//              )),
//          new Space(width: 8.0),
//          new MassageAvatar(widget.data, type: 0),
//        ],
//      );
//    }
//  }
//}

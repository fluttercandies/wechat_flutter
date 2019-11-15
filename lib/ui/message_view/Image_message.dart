//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:photo_view/photo_view.dart';
//import 'package:dim_example/tools/wechat_flutter.dart';
//import 'package:dim_example/ui/massage/img_item_container.dart';
//import 'package:dim_example/ui/massage/vertical_container.dart';
//import 'package:dim_example/ui/message_view/wai2.dart';
//
//class ImageMessage extends StatefulWidget {
//  final dynamic imageList;
//  final int type;
//  final dynamic data;
//
//  ImageMessage(this.imageList, this.type, this.data);
//
//  ImageMessageState createState() => ImageMessageState();
//}
//
//class ImageMessageState extends State<ImageMessage> {
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (widget.imageList?.toString() != '[]') {
//      if (widget.type == 1) {
//        return VerticalContainer(
//          type: 1,
//          children: <Widget>[
//            new MassageAvatar(widget.data, type: 1),
//            new ImgItemContainer(
//                child: new GestureDetector(
//              child: new CachedNetworkImage(
//                imageUrl:
//                    '${widget.imageList[1]['url'] == '' || widget.imageList[1]['url'] == null ? defContentImg : widget.imageList[1]['url']}',
//                width: (winWidth(context) - 66) - 100,
//                height: double.parse(
//                            '${widget.imageList[1]['height'] == '' || widget.imageList[1]['height'] == null ? '0' : widget.imageList[1]['height']}.0') >
//                        250
//                    ? 250
//                    : double.parse(
//                        '${widget.imageList[1]['height'] == '' || widget.imageList[1]['height'] == null ? '0' : widget.imageList[1]['height']}.0'),
//                fit: BoxFit.cover,
//                cacheManager: cacheManager,
//              ),
//              onTap: () {
//                routePush(new Material(
//                  child: new GestureDetector(
//                    child: new PhotoView(
//                      maxScale: 3.0,
//                      minScale: 0.5,
//                      imageProvider: NetworkImage(
//                          '${widget.imageList[2]['url'] == '' || widget.imageList[2]['url'] == null ? defContentImg : widget.imageList[2]['url']}'),
//                    ),
//                    onTap: () => Navigator.of(context).pop(),
//                  ),
//                ));
//              },
//            )),
//          ],
//        );
//      } else {
//        return VerticalContainer(
//          type: 2,
//          children: <Widget>[
//            new ImgItemContainer(
//              child: new GestureDetector(
//                child: new CachedNetworkImage(
//                  imageUrl:
//                      '${widget.imageList[1]['url'] == '' || widget.imageList[1]['url'] == null ? defContentImg : widget.imageList[1]['url']}',
//                  width: (winWidth(context) - 66) - 100,
//                  height: double.parse(
//                              '${widget.imageList[1]['height'] == '' || widget.imageList[1]['height'] == null ? '0' : widget.imageList[1]['height']}.0') >
//                          250
//                      ? 250
//                      : double.parse(
//                          '${widget.imageList[1]['height'] == '' || widget.imageList[1]['height'] == null ? '0' : widget.imageList[1]['height']}.0'),
//                  fit: BoxFit.cover,
//                  cacheManager: cacheManager,
//                ),
//                onTap: () {
//                  routePush(
//                    new GestureDetector(
//                      child: new PhotoView(
//                        maxScale: 3.0,
//                        minScale: 0.5,
//                        imageProvider: NetworkImage(
//                            '${widget.imageList[2]['url'] == '' || widget.imageList[2]['url'] == null ? defContentImg : widget.imageList[2]['url']}'),
//                      ),
//                      onTap: () => Navigator.of(context).pop(),
//                    ),
//                  );
//                },
//              ),
//            ),
//            new Space(width: 8.0),
//            new MassageAvatar(widget.data, type: 0),
//          ],
//        );
//      }
//    } else {
//      return new Container();
//    }
//  }
//}

import 'package:dim_example/im/model/chat_data.dart';
import 'package:dim_example/ui/message_view/msg_avatar.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:dim_example/tools/wechat_flutter.dart';

import '../../provider/global_model.dart';

class ImgMsg extends StatelessWidget {
  final msg;

  final ChatData model;

  ImgMsg(this.msg, this.model);

  @override
  Widget build(BuildContext context) {
    var msgInfo = msg['imageList'][0];
    var _height = msgInfo['height'].toDouble();
    var resultH = _height > 200.0 ? 200.0 : _height;
    final globalModel = Provider.of<GlobalModel>(context);
    var body = [
      new MsgAvatar(model: model, globalModel: globalModel),
      new Space(width: mainSpace),
      new Expanded(
        child: new GestureDetector(
          child: new Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: new ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: new CachedNetworkImage(
                  imageUrl: msgInfo['url'], height: resultH, fit: BoxFit.cover),
            ),
          ),
          onTap: () => routePush(
            new PhotoView(
              imageProvider: NetworkImage(msgInfo['url']),
              onTapUp: (c, f, s) => Navigator.of(context).pop(),
              maxScale: 3.0,
              minScale: 1.0,
            ),
          ),
        ),
      ),
      new Spacer(),
    ];
    if (model.id == globalModel.account) {
      body = body.reversed.toList();
    } else {
      body = body;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: new Row(children: body),
    );
  }
}

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

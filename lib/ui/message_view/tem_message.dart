//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:wechat_flutter/ui/massage/img_item_container.dart';
//import 'package:wechat_flutter/ui/massage/vertical_container.dart';
//
//import 'package:wechat_flutter/tools/wechat_flutter.dart';
//import 'package:wechat_flutter/ui/message_view/text_item_container.dart';
//import 'package:wechat_flutter/ui/message_view/wai2.dart';
//
//class TemMessage extends StatefulWidget {
//  final dynamic data;
//
//  TemMessage(this.data);
//
//  @override
//  _TemMessageState createState() => _TemMessageState();
//}
//
//class _TemMessageState extends State<TemMessage> {
//  @override
//  Widget build(BuildContext context) {
//    if (widget.data.toString().contains('storage')) {
//      return VerticalContainer(
//        type: 2,
//        children: <Widget>[
//          new Stack(
//            alignment: Alignment.center,
//            children: <Widget>[
//              new ImgItemContainer(
//                child:
//                    Image.file(File(widget.data.toString()), fit: BoxFit.cover),
//              ),
//              CupertinoActivityIndicator(radius: 25.0),
//            ],
//          ),
//          new MassageAvatar({}, type: 0),
//        ],
//      );
//    } else {
//      return VerticalContainer(
//        type: 2,
//        children: <Widget>[
//          new TextItemContainer(
//            text: widget.data.toString() ?? '文字为空',
//            action: '',
//            isMyself: true,
//          ),
//          new MassageAvatar({}, type: 0),
//        ],
//      );
//    }
//  }
//}

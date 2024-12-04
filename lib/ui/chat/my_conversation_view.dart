import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/message_view/content_msg.dart';

class MyConversationView extends StatefulWidget {
  final String? imageUrl;
  final String? title;
  final V2TimMessage? content;
  final Widget? time;
  final bool isBorder;

  const MyConversationView({
    Key? key,
    this.imageUrl,
    this.title,
    this.content,
    this.time,
    this.isBorder = true,
  }) : super(key: key);

  @override
  _MyConversationViewState createState() => _MyConversationViewState();
}

class _MyConversationViewState extends State<MyConversationView> {
  @override
  Widget build(BuildContext context) {
    var row = Row(
      children: <Widget>[
        SizedBox(width: mainSpace),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.title ?? '',
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 2.0),
              ContentMsg(widget.content),
            ],
          ),
        ),
        SizedBox(width: mainSpace),
        Column(
          children: [
            widget.time ?? SizedBox.shrink(),
            Icon(Icons.flag, color: Colors.transparent),
          ],
        )
      ],
    );

    return Container(
      padding: EdgeInsets.only(left: 18.0),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageView(
              img: widget.imageUrl ?? "",
              height: 50.0,
              width: 50.0,
              fit: BoxFit.cover),
          Container(
            padding: EdgeInsets.only(right: 18.0, top: 12.0, bottom: 12.0),
            width: Get.width - 68,
            decoration: BoxDecoration(
              border: widget.isBorder
                  ? Border(
                      top: BorderSide(color: lineColor, width: 0.2),
                    )
                  : null,
            ),
            child: row,
          )
        ],
      ),
    );
  }
}

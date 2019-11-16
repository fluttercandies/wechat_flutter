import 'package:flutter/material.dart';
import 'package:dim_example/tools/wechat_flutter.dart';

class MyConversationView extends StatefulWidget {
  final Widget imageUrl;
  final Widget title;
  final Widget content;
  final Widget time;

  MyConversationView({this.imageUrl, this.title, this.content, this.time});

  @override
  _MyConversationViewState createState() => _MyConversationViewState();
}

class _MyConversationViewState extends State<MyConversationView> {
  @override
  Widget build(BuildContext context) {
    var row = Row(
      children: <Widget>[
        Container(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.title,
              SizedBox(height: 2.0),
              widget.content,
            ],
          ),
        ),
        Container(width: 10.0),
        Column(
          children: [
            widget.time,
            new Icon(Icons.flag, color: Colors.transparent),
          ],
        ),
      ],
    );

    var body = [
      widget.imageUrl,
      Expanded(
        child: Container(
            padding:
                const EdgeInsets.only(right: 18.0, top: 12.0, bottom: 12.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    width: Constants.DividerWidth,
                    color: Color(AppColors.DividerColor)),
              ),
            ),
            child: row),
      ),
    ];

    return Container(
      padding: EdgeInsets.only(left: 18.0),
      color: Colors.white,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: body,
      ),
    );
  }
}

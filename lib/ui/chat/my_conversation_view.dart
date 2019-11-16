import 'package:flutter/material.dart';
import 'package:dim_example/tools/wechat_flutter.dart';

class MyConversationView extends StatefulWidget {
  final String imageUrl;
  final Widget title;
  final Widget content;
  final Widget time;
  final bool isBorder;

  MyConversationView({
    this.imageUrl,
    this.title,
    this.content,
    this.time,
    this.isBorder = true,
  });

  @override
  _MyConversationViewState createState() => _MyConversationViewState();
}

class _MyConversationViewState extends State<MyConversationView> {
  @override
  Widget build(BuildContext context) {
    var row = new Row(
      children: <Widget>[
        new Container(width: 10.0),
        new Expanded(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.title,
              new SizedBox(height: 2.0),
              widget.content,
            ],
          ),
        ),
        new Container(width: 10.0),
        new Column(
          children: [
            widget.time,
            new Icon(Icons.flag, color: Colors.transparent),
          ],
        ),
      ],
    );

    var body = [
      new ImageView(
          img: widget.imageUrl, height: 50.0, width: 50.0, fit: BoxFit.cover),
      new Expanded(
        child: new Container(
          padding: const EdgeInsets.only(right: 18.0, top: 12.0, bottom: 12.0),
          decoration: BoxDecoration(
            border: widget.isBorder
                ? Border(
                    bottom: BorderSide(
                        width: Constants.DividerWidth, color: lineColor),
                  )
                : null,
          ),
          child: row,
        ),
      ),
    ];

    return new Container(
      padding: EdgeInsets.only(left: 18.0),
      color: Colors.white,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: body,
      ),
    );
  }
}

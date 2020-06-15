import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class TipVerifyInput extends StatefulWidget {
  final String title;
  final String defStr;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color color;

  TipVerifyInput(
      {this.title,
      this.controller,
      this.defStr = '',
      this.focusNode,
      this.color = Colors.white});

  @override
  _VerifyInputState createState() => new _VerifyInputState();
}

class _VerifyInputState extends State<TipVerifyInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.defStr;
  }

  Widget contentBuild() {
    var view = [
      new Expanded(
        child: new TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          decoration: InputDecoration(border: InputBorder.none),
          onChanged: (text) {
            setState(() {});
          },
          onTap: () => setState(() {}),
          style: TextStyle(
            color: widget.focusNode.hasFocus ? Colors.black : Colors.grey,
            textBaseline: TextBaseline.alphabetic,
          ),
        ),
      ),
      widget.controller.text != ''
          ? new Visibility(
              visible: widget.focusNode.hasFocus,
              child: new InkWell(
                child: new Padding(
                  padding: EdgeInsets.all(2.0),
                  child: new Image.asset('assets/images/ic_delete.webp'),
                ),
                onTap: () {
                  widget.controller.text = '';
                  setState(() {});
                },
              ))
          : new Container()
    ];

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Space(height: mainSpace),
        new Expanded(
          child: new Container(
            width: winWidth(context) - 20,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: widget.focusNode.hasFocus
                        ? Colors.green
                        : lineColor.withOpacity(0.5),
                    width: 0.5),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            alignment: Alignment.center,
            child: new Row(children: view),
          ),
        ),
        new Space(height: mainSpace),
        new Text(
          widget.title ?? '',
          style:
              TextStyle(color: mainTextColor.withOpacity(0.7), fontSize: 15.0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 100.0,
      width: winWidth(context),
      color: widget.color,
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: contentBuild(),
    );
  }
}

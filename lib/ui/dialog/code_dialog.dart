import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

codeDialog(BuildContext context, List items) {
  Widget item(item) {
    return new Container(
      width: winWidth(context),
      decoration: BoxDecoration(
        border: item != '重置二维码'
            ? Border(
                bottom: BorderSide(color: lineColor, width: 0.2),
              )
            : null,
      ),
      child: new FlatButton(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        onPressed: () {
          Navigator.of(context).pop();
          showToast(context, '$item正在开发中');
        },
        child: new Text(item),
      ),
    );
  }

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return new Center(
        child: new Material(
          type: MaterialType.transparency,
          child: new Column(
            children: <Widget>[
              new Expanded(
                child: new InkWell(
                  child: new Container(),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
              new ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                child: new Container(
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      new Column(children: items.map(item).toList()),
                      new HorizontalLine(color: appBarColor, height: 10.0),
                      new FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        color: Colors.white,
                        onPressed: () => Navigator.of(context).pop(),
                        child: new Container(
                          width: winWidth(context),
                          alignment: Alignment.center,
                          child: new Text('取消'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

friendItemDialog(BuildContext context) {
  action(v) {
    Navigator.of(context).pop();
    if (v == '删除') {
      showToast(context, '功能还没放');
    } else {
      showToast(context, '删除功能是好的');
    }
  }

  Widget item(item) {
    return new Container(
      width: winWidth(context),
      decoration: BoxDecoration(
        border: item != '删除'
            ? Border(
                bottom: BorderSide(color: lineColor, width: 0.2),
              )
            : null,
      ),
      child: new FlatButton(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        onPressed: () => action(item),
        child: new Text(item),
      ),
    );
  }

  showModalBottomSheet(
    context: context,
    builder: (context) {
      List data = [
        '设置备注和标签',
        '把她推荐给朋友',
        '设为星标好友',
        '设置朋友圈和视频动态权限',
        '加入黑名单',
        '投诉',
        '添加到桌面',
        '删除',
      ];

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
                      new Column(children: data.map(item).toList()),
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

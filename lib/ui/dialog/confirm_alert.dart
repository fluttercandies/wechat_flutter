import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/ui/flutter/my_cupertino_dialog.dart';

void confirmAlert<T>(
  BuildContext context,
  VoidCallbackConfirm callBack, {
  int type,
  String tips,
  String okBtn,
  String cancelBtn,
  TextStyle okBtnStyle,
  TextStyle style,
  bool isWarm = false,
  String warmStr,
}) {
  showDialog<T>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      if (!strNoEmpty(okBtn)) okBtn = '确定';
      if (!strNoEmpty(cancelBtn)) cancelBtn = '取消';
      if (!strNoEmpty(warmStr)) warmStr = '温馨提示：';
      return MyCupertinoAlertDialog(
        title: isWarm
            ? new Padding(
                padding: EdgeInsets.only(bottom: 20.0, top: 0),
                child: Text(
                  '$warmStr',
                  style: TextStyle(
                      color: Color(0xff343243),
                      fontSize: 19.0,
                      fontWeight: FontWeight.normal),
                ),
              )
            : new Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  '$tips',
                  style: TextStyle(
                      color: Color(0xff343243),
                      fontSize: 19.0,
                      fontWeight: FontWeight.normal),
                ),
              ),
        content: isWarm
            ? new Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  '$tips',
                  style: TextStyle(color: Color(0xff888697)),
                ),
              )
            : new Container(),
        actions: <Widget>[
          CupertinoDialogAction(
            child: new Text(
              '$cancelBtn',
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
            ),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              callBack(false);
            },
          ),
          CupertinoDialogAction(
            child: new Text('$okBtn', style: okBtnStyle),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              callBack(true);
            },
          ),
        ],
      );
    },
  ).then<void>((T value) {});
}

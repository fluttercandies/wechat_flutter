import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/data/my_theme.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui_commom/bt/small_button.dart';

class NoDataView extends StatefulWidget {
  final String label;
  final VoidCallback onRefresh;
  final bool isTeam;
  final Function onPressed;
  final double height;

  NoDataView({
    this.label,
    this.height,
    this.onRefresh,
    this.isTeam = true,
    this.onPressed,
  });

  NoDataViewState createState() => NoDataViewState();
}

class NoDataViewState extends State<NoDataView> {
  bool isWay = false;

  @override
  Widget build(BuildContext context) {
    final String label = widget.label ?? '暂无数据';
    final double imgWidth = widget.isTeam ? 168 : 84.5;
    return Container(
      height: widget.height ?? 320,
      width: winWidth(context),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Image.asset(
              'images/main/${widget.isTeam ? 'ic_empty' : 'ic_no_data'}.png',
              width: widget.height != null ? widget.height / 2 : imgWidth),
          new Space(height: mainSpace * 1.5),
          new Text(
            label,
            style: TextStyle(color: Colors.grey, fontSize: 14.0),
          ),
          new Space(height: mainSpace * 2.5),
          new Visibility(
            visible: widget.onRefresh != null,
            child: isWay
                ? new CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(MyTheme.themeColor()),
                  )
                : new Container(),
          ),
          new Visibility(
            visible: widget.onRefresh != null,
            child: SmallButton(
              padding: EdgeInsets.symmetric(horizontal: 10),
              onPressed: () => handle(),
              child: new Text('重新加载'),
            ),
          )
        ],
      ),
    );
  }

  handle() {
    widget.onRefresh();

    if (mounted) setState(() => isWay = true);
    new Future.delayed(new Duration(seconds: 2), () {}).then((v) {
      if (mounted) setState(() => isWay = false);
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wechat_flutter/config/const.dart';

class ComMomBar extends StatelessWidget implements PreferredSizeWidget {
  const ComMomBar(
      {this.title = '',
      this.showShadow = false,
      this.rightDMActions,
      this.backgroundColor = appBarColor,
      this.mainColor = Colors.black,
      this.titleW,
      this.bottom,
      this.leadingImg = '',
      this.leadingW});

  final String title;
  final bool showShadow;
  final List<Widget> rightDMActions;
  final Color backgroundColor;
  final Color mainColor;
  final Widget titleW;
  final Widget leadingW;
  final PreferredSizeWidget bottom;
  final String leadingImg;

  @override
  Size get preferredSize => new Size(100, 50);

  Widget leading(BuildContext context) {
    final bool isShow = Navigator.canPop(context);
    if (isShow) {
      return new InkWell(
        child: new Container(
          width: 15,
          height: 28,
          child: leadingImg != ''
              ? new Image.asset(leadingImg)
              : new Icon(CupertinoIcons.back, color: mainColor),
        ),
        onTap: () {
          if (Navigator.canPop(context)) {
            FocusScope.of(context).requestFocus(new FocusNode());
            Navigator.pop(context);
          }
        },
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return showShadow
        ? new Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: new BorderSide(
                        color: Colors.grey, width: showShadow ? 0.5 : 0.0))),
            child: new AppBar(
              title: titleW == null
                  ? new Text(
                      title,
                      style: new TextStyle(
                          color: mainColor,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600),
                    )
                  : titleW,
              backgroundColor: mainColor,
              elevation: 0.0,
              brightness: Brightness.light,
              leading: leadingW ?? leading(context),
              centerTitle: true,
              actions: rightDMActions ?? [new Center()],
              bottom: bottom != null ? bottom : null,
            ),
          )
        : new AppBar(
            title: titleW == null
                ? new Text(
                    title,
                    style: new TextStyle(
                        color: mainColor,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600),
                  )
                : titleW,
            backgroundColor: backgroundColor,
            elevation: 0.0,
            brightness: Brightness.light,
            leading: leadingW ?? leading(context),
            centerTitle: false,
            bottom: bottom != null ? bottom : null,
            actions: rightDMActions ?? [new Center()],
          );
  }
}

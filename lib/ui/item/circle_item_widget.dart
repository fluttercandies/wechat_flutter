import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/theme/my_theme.dart';
import 'package:wechat_flutter/tools/func/func.dart';
import 'package:wechat_flutter/ui_commom/image/sw_image.dart';

import '../../tools/wechat_flutter.dart';

class CircleItemWidget extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? des;
  final Widget? desWidget;
  final Widget? time;
  final Widget? endWidget;
  final bool isBorder;
  final bool isSubText;
  final GestureTapCallback? onTap;
  final String? id;
  final int? type;
  final double? rSpace;

  CircleItemWidget({
    this.imageUrl,
    this.title,
    this.des,
    this.desWidget,
    this.id,
    this.time,
    this.type,
    this.endWidget,
    this.isBorder = true,
    this.isSubText = true,
    this.onTap,
    this.rSpace,
  });

  final mainTextColor = Color.fromRGBO(115, 115, 115, 1.0);

  @override
  Widget build(BuildContext context) {
    final Widget titleW = new Text(
      title ?? '',
      style: TextStyle(fontSize: 17.0, fontWeight: MyTheme.fontWeight()),
    );
    var row = new Row(
      children: <Widget>[
        Space(width: mainSpace),
        new Expanded(
          child: !isSubText
              ? titleW
              : new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    titleW,
                    new SizedBox(height: 2.0),
                    desWidget ??
                        Text(
                          des ?? '',
                          style: TextStyle(
                              color: mainTextColor,
                              fontSize: 14.0,
                              fontWeight: MyTheme.fontWeight()),
                        ),
                  ],
                ),
        ),
        new Space(width: mainSpace),
        SizedBox(
          width: 45,
          child: endWidget != null
              ? endWidget
              : new Column(
                  children: [
                    time!,
                    new Icon(Icons.flag, color: Colors.transparent),
                  ],
                ),
        ),
        new Space(width: rSpace),
      ],
    );

    return ClickEvent(
      child: new Container(
        padding: EdgeInsets.only(left: 18.0),
        color: Colors.white,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new ImageView(
                img: imageUrl, height: 50.0, width: 50.0, fit: BoxFit.cover),
            new Container(
              padding: EdgeInsets.only(right: 18.0, top: 12.0, bottom: 12.0),
              width: FrameSize.winWidth() - 68,
              decoration: BoxDecoration(
                border: isBorder
                    ? Border(
                        top: BorderSide(
                            color: const Color(0xfff1f0f1), width: 0.2),
                      )
                    : null,
              ),
              child: row,
            )
          ],
        ),
      ),
      onTap: onTap ??
          () {
            // Get.to(ChatPage(
            //   id: id,
            //   title: title,
            //   type: type ?? 1,
            // ));
          },
    );
  }
}

class CircleItemWidgetNew extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? des;
  final Widget? desWidget;
  final Widget? time;
  final Widget? endWidget;
  final bool isBorder;
  final GestureTapCallback? onTap;
  final String? id;
  final int? type;
  final double? rSpace;
  final bool isOwner;

  CircleItemWidgetNew({
    this.imageUrl,
    this.title,
    this.des,
    this.desWidget,
    this.id,
    this.time,
    this.type,
    this.endWidget,
    this.isBorder = true,
    this.isOwner = false,
    this.onTap,
    this.rSpace,
  });

  final mainTextColor = Color.fromRGBO(115, 115, 115, 1.0);

  @override
  Widget build(BuildContext context) {
    final Widget titleW = new Text(
      title ?? '',
      style: TextStyle(fontSize: 18.0, fontWeight: MyTheme.fontWeight()),
    );
    var row = new Row(
      children: <Widget>[
        Space(width: mainSpace),
        new Expanded(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              titleW,
              new SizedBox(height: 10.0),
              desWidget ??
                  Text(
                    des ?? '',
                    style: TextStyle(
                        color: mainTextColor,
                        fontSize: 14.0,
                        fontWeight: MyTheme.fontWeight()),
                  ),
            ],
          ),
        ),
        new Space(width: mainSpace),
        if (isOwner)
          SwImage(
            'images/main/ic_group_owner.png',
            width: 20,
          ),
        new Space(width: rSpace),
      ],
    );

    return ClickEvent(
      child: new Container(
        padding: EdgeInsets.only(left: 18.0, top: 10, bottom: 10),
        color: Colors.white,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new ImageView(
                img: imageUrl, height: 80.0, width: 80.0, fit: BoxFit.cover),
            new Expanded(
              child: Container(
                padding: EdgeInsets.only(right: 18.0, top: 12.0, bottom: 12.0),
                decoration: BoxDecoration(
                  border: isBorder
                      ? Border(
                          top: BorderSide(
                              color: const Color(0xfff1f0f1), width: 0.2),
                        )
                      : null,
                ),
                child: row,
              ),
            )
          ],
        ),
      ),
      onTap: onTap ??
          () {
            // Get.to(ChatPage(
            //   id: id,
            //   title: title,
            //   type: type ?? 1,
            // ));
          },
    );
  }
}

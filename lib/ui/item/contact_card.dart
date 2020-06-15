import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/view/image_view.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ContactCard extends StatelessWidget {
  final String img, title, nickName, id, area;
  final bool isBorder;
  final double lineWidth;

  ContactCard({
    @required this.img,
    this.title,
    this.id,
    this.nickName,
    this.area,
    this.isBorder = false,
    this.lineWidth = mainLineWidth,
  }) : assert(id != null);

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = TextStyle(fontSize: 14, color: mainTextColor);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: isBorder
            ? Border(
                bottom: BorderSide(color: lineColor, width: lineWidth),
              )
            : null,
      ),
      width: winWidth(context),
      padding: EdgeInsets.only(right: 15.0, left: 15.0, bottom: 20.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new GestureDetector(
            child: new ImageView(
                img: img, width: 55, height: 55, fit: BoxFit.cover),
            onTap: () {
              if (isNetWorkImg(img)) {
                routePush(
                  new PhotoView(
                    imageProvider: NetworkImage(img),
                    onTapUp: (c, f, s) => Navigator.of(context).pop(),
                    maxScale: 3.0,
                    minScale: 1.0,
                  ),
                );
              } else {
                showToast(context, '无头像');
              }
            },
          ),
          new Space(width: mainSpace * 2),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text(
                    title ?? '未知',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  new Space(width: mainSpace / 3),
                  new Image.asset('assets/images/Contact_Female.webp',
                      width: 20.0, fit: BoxFit.fill),
                ],
              ),
              new Padding(
                padding: EdgeInsets.only(top: 3.0),
                child: new Text("昵称：" + nickName ?? '', style: labelStyle),
              ),
              new Text("微信号：" + id ?? '', style: labelStyle),
              new Text("地区：" + area ?? '', style: labelStyle),
            ],
          )
        ],
      ),
    );
  }
}

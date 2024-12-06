import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class ContactCard extends StatelessWidget {
  final String img;
  final String? title;
  final String id;
  final String? nickName;
  final String? area;
  final bool isBorder;
  final double lineWidth;

  ContactCard({
    required this.img,
    required this.id,
    this.title,
    this.nickName,
    this.area,
    this.isBorder = false,
    this.lineWidth = mainLineWidth,
  });

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
      width: Get.width,
      padding: EdgeInsets.only(right: 15.0, left: 15.0, bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child:
                ImageView(img: img, width: 55, height: 55, fit: BoxFit.cover),
            onTap: () {
              if (isNetWorkImg(img)) {
                Get.to<void>(
                  PhotoView(
                    imageProvider: NetworkImage(img),
                    onTapUp: (c, f, s) => Navigator.of(context).pop(),
                    maxScale: 3.0,
                    minScale: 1.0,
                  ),
                );
              } else {
                showToast( '无头像');
              }
            },
          ),
          SizedBox(width: mainSpace * 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    title ?? '未知',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: mainSpace / 3),
                  Image.asset('assets/images/Contact_Female.webp',
                      width: 20.0, fit: BoxFit.fill),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0),
                child: Text("昵称：" + (nickName ?? ''), style: labelStyle),
              ),
              Text("微信号：" + id, style: labelStyle),
              Text("地区：" + (area ?? ''), style: labelStyle),
            ],
          )
        ],
      ),
    );
  }
}

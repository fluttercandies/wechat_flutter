import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class PersonCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String area;
  final int gender;

  PersonCard({this.imageUrl, this.name, this.area, this.gender = 0});

  Widget dynamicAvatar(avatar, {size}) {
    if (isNetWorkImg(avatar))
      return new CachedNetworkImage(
          imageUrl: avatar,
          cacheManager: cacheManager,
          width: size ?? null,
          height: size ?? null,
          fit: BoxFit.fill);
    else
      return new Image.asset(avatar,
          fit: BoxFit.fill, width: size ?? null, height: size ?? null);
  }

  List<Widget> content() {
    return [
      new Space(),
      new Container(
        margin: EdgeInsets.all(15.0),
        width: 60.0,
        height: 60.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: strNoEmpty(imageUrl)
              ? dynamicAvatar(imageUrl)
              : new Image.asset(defIcon, fit: BoxFit.cover),
        ),
      ),
      new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Text(
                name,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
              new Space(),
              new Image.asset(
                  'assets/images/Contact_${gender == 0 ? 'Female' : 'Male'}.webp',
                  fit: BoxFit.cover,
                  width: 20.0)
            ],
          ),
          new Space(height: mainSpace * 0.3),
          new Text(
            '地区： $area',
            style: TextStyle(color: labelTextColor, fontSize: 13),
          )
        ],
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      height: 90.0,
      child: new Row(children: content()),
    );
  }
}

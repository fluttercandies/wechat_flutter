import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class PersonCard extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String area;
  final int gender;

  PersonCard({
    this.imageUrl,
    required this.name,
    required this.area,
    this.gender = 0,
  });

  Widget dynamicAvatar(String avatar, {double? size}) {
    if (GetUtils.isURL(avatar)) {
      return CachedNetworkImage(
        imageUrl: avatar,
        cacheManager: cacheManager,
        width: size,
        height: size,
        fit: BoxFit.fill,
      );
    } else {
      return Image.asset(
        avatar,
        fit: BoxFit.fill,
        width: size,
        height: size,
      );
    }
  }

  List<Widget> content() {
    return [
      SizedBox(width: 10.0),
      Container(
        margin: EdgeInsets.all(15.0),
        width: 60.0,
        height: 60.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: imageUrl != null && strNoEmpty(imageUrl!)
              ? dynamicAvatar(imageUrl!)
              : Image.asset(defIcon, fit: BoxFit.cover),
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                name,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 10),
              Image.asset(
                'assets/images/Contact_${gender == 0 ? 'Female' : 'Male'}.webp',
                fit: BoxFit.cover,
                width: 20.0,
              ),
            ],
          ),
          SizedBox(height: mainSpace * 0.3),
          Text(
            '地区： $area',
            style: TextStyle(color: labelTextColor, fontSize: 13),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 90.0,
      child: Row(children: content()),
    );
  }
}

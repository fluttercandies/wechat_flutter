import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class SelectBgPage extends StatefulWidget {
  @override
  _SelectBgPageState createState() => _SelectBgPageState();
}

class _SelectBgPageState extends State<SelectBgPage> {
  List data = [
    {'name': 'def', 'img': 'assets/images/group/local_background_default.png'},
    {'name': 'one', 'img': 'assets/images/group/local_background_one.webp'},
    {'name': 'two', 'img': 'assets/images/group/local_background_two.webp'},
    {'name': 'three', 'img': 'assets/images/group/local_background_three.webp'},
    {'name': 'four', 'img': 'assets/images/group/local_background_four.webp'},
    {'name': 'five', 'img': 'assets/images/group/local_background_five.webp'},
  ];

  Widget buildBg(item) {
    double _size = (winWidth(context) - 30) / 3;
    return new InkWell(
      child: new ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: new Image.asset(
          item['img'],
          width: _size - 0.01,
          height: _size,
          fit: BoxFit.fill,
        ),
      ),
      onTap: () => showToast(context, '敬请期待'),
//      onTap: () =>
//          routePush(new ChatBackgroundDetailsPage(item['img'], item['name'])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new ComMomBar(title: '选择背景图'),
      backgroundColor: Color(0xff3b4449),
      body: new Container(
        padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
        child: new Wrap(
          runSpacing: 10.0,
          spacing: 10.0,
          children:
              listNoEmpty(data) ? data.map(buildBg).toList() : new Container(),
        ),
      ),
    );
  }
}

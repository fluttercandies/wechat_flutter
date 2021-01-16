import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class PayHomePage extends StatefulWidget {
  @override
  _PayHomePageState createState() => _PayHomePageState();
}

class _PayHomePageState extends State<PayHomePage> {
  List data = [
    {
      'title': '金融理财',
      'data': ['信用卡还款', '理财通'],
    },
    {
      'title': '生活服务',
      'data': ['手机充值', '生活缴费', 'Q币充值', '城市服务', '腾讯公益', '医疗健康', '防疫健康码'],
    },
    {
      'title': '交通出行',
      'data': ['出行服务', '火车票机票', '滴滴出行', '酒店'],
    },
    {
      'title': '购物消费',
      'data': [
        '京东购物',
        '美团外卖',
        '电影演出赛事',
        '美团团购',
        '拼多多',
        '蘑菇街女装',
        '唯品会特卖',
        '转转二手',
        '贝壳找房',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: appBarColor,
      appBar: new ComMomBar(
        title: '支付',
        rightDMActions: [
          new IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.black,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: new ListView(
        padding: EdgeInsets.symmetric(vertical: 10),
        children: [
          new Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: new Row(
              children: [
                {'label': '收付款', 'icon': ''},
                {'label': '钱包', 'icon': ''},
              ].map((e) {
                return new Container(
                  width: (winWidth(context) - 22) / 2,
                  padding: EdgeInsets.symmetric(vertical: 35),
                  child: new Column(
                    children: [
                      new Icon(
                        Icons.event,
                        color: Colors.white,
                      ),
                      new Space(height: 7),
                      new Text(
                        '${e['label']}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ]..addAll(data.map<Widget>((out) {
            return new Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.only(left: 8, right: 8, top: 10),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: new Text(
                      '金融理财',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  new Wrap(
                    children: out['data'].map<Widget>((e) {
                      return new Container(
                        width: (winWidth(context) - 42) / 4,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: new Column(
                          children: [
                            new Icon(Icons.event),
                            new Space(height: 7),
                            new Text('$e'),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }).toList()),
      ),
    );
  }
}

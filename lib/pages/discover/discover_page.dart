import 'package:wechat_flutter/pages/settings/language_page.dart';
import 'package:wechat_flutter/pages/wechat_friends/page/wechat_friends_circle.dart';
import 'package:wechat_flutter/ui/view/indicator_page_view.dart';
import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/view/list_tile_view.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Widget buildContent(item) {
    bool isShow() {
      if (item['name'] == '朋友圈' ||
          item['name'] == '摇一摇' ||
          item['name'] == '搜一搜' ||
          item['name'] == '附近的餐厅' ||
          item['name'] == '游戏' ||
          item['name'] == '小程序') {
        return true;
      } else {
        return false;
      }
    }

    return new ListTileView(
      border: isShow()
          ? null
          : Border(bottom: BorderSide(color: lineColor, width: 0.3)),
      title: item['name'],
      titleStyle: TextStyle(fontSize: 15.0),
      isLabel: false,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      icon: item['icon'],
      margin: EdgeInsets.only(bottom: isShow() ? 10.0 : 0.0),
      onPressed: () {
        if (item['name'] == '朋友圈') {
          routePush(new WeChatFriendsCircle());
        } else {
          routePush(new LanguagePage());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List data = [
      {'icon': 'assets/images/discover/ff_Icon_album.webp', 'name': '朋友圈'},
      {'icon': 'assets/images/discover/ff_Icon_qr_code.webp', 'name': '扫一扫'},
      {'icon': 'assets/images/discover/ff_Icon_shake.webp', 'name': '摇一摇'},
      {'icon': 'assets/images/discover/ff_Icon_browse.webp', 'name': '看一看'},
      {'icon': 'assets/images/discover/ff_Icon_search.webp', 'name': '搜一搜'},
      {'icon': 'assets/images/discover/ff_Icon_nearby.webp', 'name': '附近的人'},
      {'icon': 'assets/images/discover/ff_Icon_bottle.webp', 'name': '漂流瓶'},
      {'icon': 'assets/images/discover/ff_Icon_qr_code.webp', 'name': '附近的餐厅'},
      {'icon': 'assets/images/discover/ff_Icon_qr_code.webp', 'name': '购物'},
      {'icon': 'assets/images/discover/game_center_h5.webp', 'name': '游戏'},
      {'icon': 'assets/images/discover/mini_program.webp', 'name': '小程序'},
    ];

    return new Scaffold(
      backgroundColor: appBarColor,
      body: new ScrollConfiguration(
        behavior: MyBehavior(),
        child: new SingleChildScrollView(
          child: new Column(children: data.map(buildContent).toList()),
        ),
      ),
    );
  }
}

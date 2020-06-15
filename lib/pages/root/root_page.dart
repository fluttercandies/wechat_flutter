import 'package:wechat_flutter/http/api.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/pages/contacts/contacts_page.dart';
import 'package:wechat_flutter/pages/discover/discover_page.dart';
import 'package:wechat_flutter/pages/home/home_page.dart';
import 'package:wechat_flutter/pages/mine/mine_page.dart';
import 'package:wechat_flutter/pages/root/root_tabbar.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
    ifBrokenNetwork();
    updateApi(context);
  }

  ifBrokenNetwork() async {
    final ifNetWork = await SharedUtil.instance.getBoolean(Keys.brokenNetwork);
    if (ifNetWork) {
      /// 监测网络变化
      subscription.onConnectivityChanged
          .listen((ConnectivityResult result) async {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          final currentUser = await im.getCurrentLoginUser();
          if (currentUser == '' || currentUser == null) {
            final account = await SharedUtil.instance.getString(Keys.account);
            im.imAutoLogin(account);
          }
          await SharedUtil.instance.saveBoolean(Keys.brokenNetwork, false);
        }
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TabBarModel> pages = <TabBarModel>[
      new TabBarModel(
          title: S.of(context).weChat,
          icon: new LoadImage("assets/images/tabbar_chat_c.webp"),
          selectIcon: new LoadImage("assets/images/tabbar_chat_s.webp"),
          page: new HomePage()),
      new TabBarModel(
        title: S.of(context).contacts,
        icon: new LoadImage("assets/images/tabbar_contacts_c.webp"),
        selectIcon: new LoadImage("assets/images/tabbar_contacts_s.webp"),
        page: new ContactsPage(),
      ),
      new TabBarModel(
        title: S.of(context).discover,
        icon: new LoadImage("assets/images/tabbar_discover_c.webp"),
        selectIcon: new LoadImage("assets/images/tabbar_discover_s.webp"),
        page: new DiscoverPage(),
      ),
      new TabBarModel(
        title: S.of(context).me,
        icon: new LoadImage("assets/images/tabbar_me_c.webp"),
        selectIcon: new LoadImage("assets/images/tabbar_me_s.webp"),
        page: new MinePage(),
      ),
    ];
    return new Scaffold(
      key: scaffoldGK,
      body: new RootTabBar(pages: pages, currentIndex: 0),
    );
  }
}

class LoadImage extends StatelessWidget {
  final String img;

  LoadImage(this.img);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(bottom: 2.0),
      child: new Image.asset(img, fit: BoxFit.cover, gaplessPlayback: true),
    );
  }
}

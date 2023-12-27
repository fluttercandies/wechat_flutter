import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/pages/common/contacts/contacts_page.dart';
import 'package:wechat_flutter/pages/common/discover/discover_page.dart';
import 'package:wechat_flutter/pages/common/home/home_page.dart';
import 'package:wechat_flutter/pages/common/mine/mine_page.dart';
import 'package:wechat_flutter/pages/root/root_tabbar.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

import 'root_logic.dart';

class RootPage extends StatefulWidget {
  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with WidgetsBindingObserver {
  final logic = Get.find<RootLogic>();

  @override
  void initState() {
    super.initState();
    logic.ifBrokenNetwork();
    // updateApi(context);

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        var keyboardSize = MediaQuery.of(context).viewInsets.bottom;
        if (keyboardSize > AppConfig.keyboardHeight) {
          AppConfig.keyboardHeight = keyboardSize;
          SharedUtil.instance!
              .saveDouble(Keys.keyboardSize, AppConfig.keyboardHeight);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<TabBarModel> pages = <TabBarModel>[
      new TabBarModel(
          title: "消息",
          icon: new LoadImage("assets/images/tabbar_chat_c.webp"),
          selectIcon: new LoadImage("assets/images/tabbar_chat_s.webp"),
          page: new HomePage()),
      new TabBarModel(
        title: "通讯录",
        icon: new LoadImage("assets/images/tabbar_contacts_c.webp"),
        selectIcon: new LoadImage("assets/images/tabbar_contacts_s.webp"),
        page: new ContactsPage(),
      ),
      new TabBarModel(
        title: "发现",
        icon: new LoadImage("assets/images/tabbar_discover_c.webp"),
        selectIcon: new LoadImage("assets/images/tabbar_discover_s.webp"),
        page: new DiscoverPage(),
      ),
      new TabBarModel(
        title: "我",
        icon: new LoadImage("assets/images/tabbar_me_c.webp"),
        selectIcon: new LoadImage("assets/images/tabbar_me_s.webp"),
        page: new MinePage(),
      ),
    ];
    return new Scaffold(
      body: new RootTabBar(pages: pages, currentIndex: 0),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
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

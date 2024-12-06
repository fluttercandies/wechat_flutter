import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:wechat_flutter/http/api.dart';
import 'package:wechat_flutter/pages/contacts/contacts_page.dart';
import 'package:wechat_flutter/pages/discover/discover_page.dart';
import 'package:wechat_flutter/pages/home/home_page.dart';
import 'package:wechat_flutter/pages/mine/mine_page.dart';
import 'package:wechat_flutter/pages/root/root_tabbar.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

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

  Future<void> ifBrokenNetwork() async {
    final ifNetWork = await SharedUtil.instance.getBoolean(Keys.brokenNetwork);
    if (ifNetWork) {
      /// 监测网络变化
      subscription.onConnectivityChanged
          .listen((List<ConnectivityResult> result) async {
        if (result.contains(ConnectivityResult.mobile) ||
            result.contains(ConnectivityResult.wifi)) {
          V2TimValueCallback<String> currentUser =
              await V2TIMManager().getLoginUser();
          log('ConnectivityResult::currentUser::$currentUser');
          // if (currentUser == '' ) {
          // final account = await SharedUtil.instance.getString(Keys.account);
          // im.imAutoLogin(account);
          // }
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
      TabBarModel(
          title: S.of(context).weChat,
          icon: LoadImage('assets/images/tabbar_chat_c.webp'),
          selectIcon: LoadImage('assets/images/tabbar_chat_s.webp'),
          page: HomePage()),
      TabBarModel(
        title: S.of(context).contacts,
        icon: LoadImage('assets/images/tabbar_contacts_c.webp'),
        selectIcon: LoadImage('assets/images/tabbar_contacts_s.webp'),
        page: const ContactsPage(),
      ),
      TabBarModel(
        title: S.of(context).discover,
        icon: LoadImage('assets/images/tabbar_discover_c.webp'),
        selectIcon: LoadImage('assets/images/tabbar_discover_s.webp'),
        page: DiscoverPage(),
      ),
      TabBarModel(
        title: S.of(context).me,
        icon: LoadImage('assets/images/tabbar_me_c.webp'),
        selectIcon: LoadImage('assets/images/tabbar_me_s.webp'),
        page: MinePage(),
      ),
    ];
    return Scaffold(
      body: RootTabBar(pages: pages, currentIndex: 0),
    );
  }
}

class LoadImage extends StatelessWidget {
  const LoadImage(this.img, {super.key});

  final String img;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2.0),
      child: Image.asset(img, fit: BoxFit.cover, gaplessPlayback: true),
    );
  }
}

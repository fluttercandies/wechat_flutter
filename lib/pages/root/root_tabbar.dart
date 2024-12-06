import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/pages/contacts/group_launch_page.dart';
import 'package:wechat_flutter/pages/home/search_page.dart';
import 'package:wechat_flutter/pages/more/add_friend_page.dart';
import 'package:wechat_flutter/pages/settings/language_page.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/view/indicator_page_view.dart';
import 'package:wechat_flutter/ui/w_pop/w_popup_menu.dart';

typedef CheckLogin = void Function(int index);

class RootTabBar extends StatefulWidget {
  final List<TabBarModel> pages;
  final CheckLogin? checkLogin;
  final int currentIndex;

  const RootTabBar({
    Key? key,
    required this.pages,
    this.checkLogin,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => RootTabBarState();
}

class RootTabBarState extends State<RootTabBar> {
  late int currentIndex;
  late PageController pageController;
  final List<BottomNavigationBarItem> pages = [];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    pageController = PageController(initialPage: currentIndex);
    for (var model in widget.pages) {
      pages.add(
        BottomNavigationBarItem(
          icon: model.icon,
          activeIcon: model.selectIcon,
          label: model.title,
        ),
      );
    }
  }

  void actionsHandle(String v) {
    if (v == '添加朋友') {
      Get.to<void>(AddFriendPage());
    } else if (v == '发起群聊') {
      Get.to<void>(GroupLaunchPage());
    } else if (v == '帮助与反馈') {
      Get.to<void>(WebViewPage(url: helpUrl, title: '帮助与反馈'));
    } else {
      Get.to<void>(LanguagePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> actions = [
      {"title": '发起群聊', 'icon': 'assets/images/contacts_add_newmessage.png'},
      {"title": '添加朋友', 'icon': 'assets/images/ic_add_friend.webp'},
      {"title": '扫一扫', 'icon': ''},
      {"title": '收付款', 'icon': ''},
      {"title": '帮助与反馈', 'icon': ''},
    ];

    final BottomNavigationBar bottomNavigationBar = BottomNavigationBar(
      items: pages,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      fixedColor: Colors.green,
      unselectedItemColor: mainTextColor,
      onTap: (int index) {
        setState(() => currentIndex = index);
        pageController.jumpToPage(currentIndex);
      },
      unselectedFontSize: 12.0,
      selectedFontSize: 12.0,
      elevation: 0,
    );

    var appBar = ComMomBar(
      title: widget.pages[currentIndex].title,
      showShadow: false,
      rightDMActions: <Widget>[
        InkWell(
          child: Container(
            width: 60.0,
            child: Image.asset('assets/images/search_black.webp'),
          ),
          onTap: () => Get.to<void>(SearchPage()),
        ),
        WPopupMenu(
          menuWidth: Get.width / 2.5,
          alignment: Alignment.center,
          onValueChanged: (String value) {
            if (value.isEmpty) return;
            actionsHandle(value);
          },
          actions: actions,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Image.asset('assets/images/add_addressicon.png',
                color: Colors.black, width: 22.0, fit: BoxFit.fitWidth),
          ),
        )
      ],
    );

    return Scaffold(
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: Colors.grey[50],
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: lineColor, width: 0.2))),
          child: bottomNavigationBar,
        ),
      ),
      appBar:
          widget.pages[currentIndex].title != S.of(context).me ? appBar : null,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: PageView.builder(
          itemBuilder: (BuildContext context, int index) =>
              widget.pages[index].page,
          controller: pageController,
          itemCount: pages.length,
          physics: Platform.isAndroid
              ? ClampingScrollPhysics()
              : NeverScrollableScrollPhysics(),
          onPageChanged: (int index) {
            setState(() => currentIndex = index);
          },
        ),
      ),
    );
  }
}

class TabBarModel {
  const TabBarModel({
    required this.title,
    required this.page,
    required this.icon,
    required this.selectIcon,
  });

  final String title;
  final Widget icon;
  final Widget selectIcon;
  final Widget page;
}

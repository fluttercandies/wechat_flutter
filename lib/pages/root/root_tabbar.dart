import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dim_example/pages/more/add_friend_page.dart';

import 'package:dim_example/tools/wechat_flutter.dart';
import 'package:dim_example/ui/w_pop/w_popup_menu.dart';

typedef CheckLogin(index);

class RootTabBar extends StatefulWidget {
  RootTabBar({this.pages, this.checkLogin, this.currentIndex = 0});

  final List pages;
  final CheckLogin checkLogin;
  final int currentIndex;

  @override
  State<StatefulWidget> createState() => new RootTabBarState();
}

class RootTabBarState extends State<RootTabBar> {
  var pages = new List<BottomNavigationBarItem>();
  int currentIndex;
  var contents = new List<Offstage>();
  PageController pageController;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    pageController = PageController(initialPage: currentIndex);
    for (int i = 0; i < widget.pages.length; i++) {
      TabBarModel model = widget.pages[i];
      pages.add(
        new BottomNavigationBarItem(
          icon: model.icon,
          activeIcon: model.selectIcon,
          title: new Text(model.title, style: new TextStyle(fontSize: 12.0)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> actions = ['发起群聊', '添加朋友', '扫一扫', '收付款', '帮助与反馈'];

    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
      items: pages,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      fixedColor: Colors.green,
      unselectedItemColor: mainTextColor,
      onTap: (int index) {
        setState(() => currentIndex = index);
        pageController.jumpToPage(currentIndex);
      },
      unselectedFontSize: 18.0,
      selectedFontSize: 18.0,
      elevation: 0,
    );

    var appBar = new ComMomBar(
      title: widget.pages[currentIndex].title,
      showShadow: false,
      rightDMActions: <Widget>[
        new InkWell(
          child: new Container(
            width: 60.0,
            child: new Image.asset('assets/images/search_black.webp'),
          ),
          onTap: () => showToast(context, 'search'),
        ),
        new WPopupMenu(
          menuWidth: winWidth(context) / 2.5,
          alignment: Alignment.center,
          onValueChanged: (String value) {
            if (!strNoEmpty(value)) return;
            switch (value) {
              case '添加朋友':
                routePush(new AddFriendPage());
                break;
            }
          },
          actions: actions,
          child: new Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: new Image.asset('assets/images/add_addressicon.png',
                color: Colors.black, width: 22.0, fit: BoxFit.fitWidth),
          ),
        )
      ],
    );

    return new Scaffold(
      bottomNavigationBar: new Theme(
        data: new ThemeData(
          canvasColor: Colors.grey[50],
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: new Container(
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: lineColor, width: 0.2))),
          child: bottomNavigationBar,
        ),
      ),
      appBar:
          widget.pages[currentIndex].title != S.of(context).me ? appBar : null,
      body: new PageView.builder(
        itemBuilder: (BuildContext context, int index) =>
            widget.pages[index].page,
        controller: pageController,
        itemCount: pages.length,
        physics: Platform.isAndroid
            ? new ClampingScrollPhysics()
            : new NeverScrollableScrollPhysics(),
        onPageChanged: (int index) {
          setState(() => currentIndex = index);
        },
      ),
    );
  }
}

class TabBarModel {
  const TabBarModel({this.title, this.page, this.icon, this.selectIcon});

  final String title;
  final Widget icon;
  final Widget selectIcon;
  final Widget page;
}

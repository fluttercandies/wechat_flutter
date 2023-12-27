import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/pages/common/mine/code_page.dart';
import 'package:wechat_flutter/pages/common/user/user_page.dart';
import 'package:wechat_flutter/tools/core/global_controller.dart';
import 'package:wechat_flutter/ui/view/list_tile_view.dart';
import 'package:wechat_flutter/ui/view/search_main_view.dart';
import 'package:wechat_flutter/ui/view/search_tile_view.dart';

import '../../../../tools/wechat_flutter.dart';
import 'add_friend_logic.dart';

class AddFriendPage extends StatelessWidget {
  final logic = Get.find<AddFriendLogic>();

  Widget buildItem(item) {
    return new ListTileView(
      border: item['title'] == '雷达加朋友'
          ? null
          : Border(top: BorderSide(color: lineColor, width: 0.2)),
      title: item['title'],
      label: item['label'],
      icon: strNoEmpty(item['icon'])
          ? item['icon']
          : 'assets/images/favorite.webp',
      fit: BoxFit.cover,
      onPressed: () => Get.to(new UserPage()),
    );
  }

  Widget body() {
    final model = Get.find<GlobalController>();

    List data = [
      {
        'icon': contactAssets + 'ic_reda.webp',
        'title': '雷达加朋友',
        'label': '添加身边的朋友',
      },
      {
        'icon': contactAssets + 'ic_group.webp',
        'title': '面对面建群',
        'label': '与身边的朋友进入同一个群聊'
      },
      {
        'icon': contactAssets + 'ic_scanqr.webp',
        'title': '扫一扫',
        'label': '扫描二维码名片',
      },
      {
        'icon': contactAssets + 'ic_new_friend.webp',
        'title': '手机联系人',
        'label': '添加或邀请通讯录中的朋友',
      },
      {
        'icon': contactAssets + 'ic_offical.webp',
        'title': '公众号',
        'label': '获取更多资讯和服务',
      },
      {
        'icon': contactAssets + 'ic_search_wework.webp',
        'title': '企业${AppConfig.appName}联系人',
        'label': '通过手机号搜索企业${AppConfig.appName}用户',
      },
    ];
    var content = [
      new SearchMainView(
        text: '${AppConfig.appName}号/手机号',
        onTap: () {
          logic.isSearch = true;
          logic.update();
          logic.searchF.requestFocus();
        },
      ),
      new Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 30.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              '我的${AppConfig.appName}号：${logic.currentUser ?? '[${model.account}]'}',
              style: TextStyle(color: mainTextColor, fontSize: 14.0),
            ),
            new Space(width: mainSpace * 1.5),
            new InkWell(
              child: new Image.asset('assets/images/mine/ic_small_code.png',
                  color: mainTextColor.withOpacity(0.7)),
              onTap: () => Get.to(new CodePage(id: model.account)),
            )
          ],
        ),
      ),
      new Column(children: data.map(buildItem).toList())
    ];

    return new Column(children: content);
  }

  List<Widget> searchBody(BuildContext context) {
    if (logic.isResult) {
      return [
        new Container(
          color: Colors.white,
          width: FrameSize.winWidth(),
          height: 110.0,
          alignment: Alignment.center,
          child: new Text(
            '该用户不存在',
            style: TextStyle(color: mainTextColor),
          ),
        ),
        new Space(height: mainSpace),
        new SearchTileView(logic.searchC.text, type: 1),
        new Container(
          color: Colors.white,
          width: FrameSize.winWidth(),
          height: (FrameSize.winHeight() - 185 * 1.38),
        )
      ];
    } else {
      return [
        new SearchTileView(
          logic.searchC.text,
          onPressed: () => logic.search(logic.searchC.text),
        ),
        new Container(
          color: strNoEmpty(logic.searchC.text) ? Colors.white : appBarColor,
          width: FrameSize.winWidth(),
          height: strNoEmpty(logic.searchC.text)
              ? (FrameSize.winHeight() - 65 * 2.1) -
                  FrameSize.winKeyHeight(context)
              : FrameSize.winHeight(),
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddFriendLogic>(
      builder: (logic) {
        print("刷新了页面");
        return WillPopScope(
          child: new Scaffold(
            backgroundColor: appBarColor,
            appBar: new ComMomBar(
              leadingW: logic.isSearch
                  ? new InkWell(
                      child: new Container(
                        width: 15,
                        height: 28,
                        child:
                            new Icon(CupertinoIcons.back, color: Colors.black),
                      ),
                      onTap: () => logic.unFocusMethod(),
                    )
                  : null,
              title: '添加朋友',
              titleW: logic.isSearch
                  ? new Row(
                      children: [
                        new Expanded(
                          child: new TextField(
                            focusNode: logic.searchF,
                            controller: logic.searchC,
                            style: TextStyle(
                                textBaseline: TextBaseline.alphabetic),
                            decoration: InputDecoration(
                                hintText: '${AppConfig.appName}号/手机号',
                                border: InputBorder.none),
                            onChanged: logic.onChange,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (txt) => logic.search(txt),
                          ),
                        ),
                        strNoEmpty(logic.searchC.text)
                            ? new InkWell(
                                child: new Image.asset(
                                    'assets/images/ic_delete.webp'),
                                onTap: () {
                                  logic.searchC.text = '';
                                  logic.update();
                                },
                              )
                            : new Container()
                      ],
                    )
                  : null,
            ),
            body: new SingleChildScrollView(
              child: logic.isSearch
                  ? new GestureDetector(
                      child: new Column(children: searchBody(context)),
                      onTap: () => logic.unFocusMethod(),
                    )
                  : body(),
            ),
          ),
          onWillPop: () async {
            if (logic.isSearch) {
              logic.unFocusMethod();
            } else {
              Navigator.pop(context);
            }
            return false;
          },
        );
      },
    );
  }
}

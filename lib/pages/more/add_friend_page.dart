import 'dart:convert';

import 'package:wechat_flutter/im/entity/i_person_info_entity.dart';
import 'package:wechat_flutter/im/entity/person_info_entity.dart';
import 'package:wechat_flutter/pages/mine/code_page.dart';
import 'package:wechat_flutter/pages/root/user_page.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/im/info_handle.dart';
import 'package:wechat_flutter/pages/more/add_friend_details.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/view/list_tile_view.dart';
import 'package:wechat_flutter/ui/view/search_main_view.dart';
import 'package:wechat_flutter/ui/view/search_tile_view.dart';
import 'package:provider/provider.dart';

class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendPageState createState() => new _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  bool isSearch = false;
  bool showBtn = false;
  bool isResult = false;

  String currentUser;

  FocusNode searchF = new FocusNode();
  TextEditingController searchC = new TextEditingController();

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
      onPressed: () => routePush(new UserPage()),
    );
  }

  Widget body() {
    final model = Provider.of<GlobalModel>(context);

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
        'title': '企业微信联系人',
        'label': '通过手机号搜索企业微信用户',
      },
    ];
    var content = [
      new SearchMainView(
        text: '微信号/手机号',
        onTap: () {
          isSearch = true;
          setState(() {});
          searchF.requestFocus();
        },
      ),
      new Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 30.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              '我的微信号：${currentUser ?? '[${model.account}]'}',
              style: TextStyle(color: mainTextColor, fontSize: 14.0),
            ),
            new Space(width: mainSpace * 1.5),
            new InkWell(
              child: new Image.asset('assets/images/mine/ic_small_code.png',
                  color: mainTextColor.withOpacity(0.7)),
              onTap: () => routePush(new CodePage()),
            )
          ],
        ),
      ),
      new Column(children: data.map(buildItem).toList())
    ];

    return new Column(children: content);
  }

  List<Widget> searchBody() {
    if (isResult) {
      return [
        new Container(
          color: Colors.white,
          width: winWidth(context),
          height: 110.0,
          alignment: Alignment.center,
          child: new Text(
            '该用户不存在',
            style: TextStyle(color: mainTextColor),
          ),
        ),
        new Space(height: mainSpace),
        new SearchTileView(searchC.text, type: 1),
        new Container(
          color: Colors.white,
          width: winWidth(context),
          height: (winHeight(context) - 185 * 1.38),
        )
      ];
    } else {
      return [
        new SearchTileView(
          searchC.text,
          onPressed: () => search(searchC.text),
        ),
        new Container(
          color: strNoEmpty(searchC.text) ? Colors.white : appBarColor,
          width: winWidth(context),
          height: strNoEmpty(searchC.text)
              ? (winHeight(context) - 65 * 2.1) - winKeyHeight(context)
              : winHeight(context),
        )
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    if (Platform.isAndroid) {
      currentUser = await im.getCurrentLoginUser();
    } else {
      currentUser = null;
    }
    setState(() {});
  }

  unFocusMethod() {
    searchF.unfocus();
    isSearch = false;
    if (isResult) isResult = !isResult;
    setState(() {});
  }

  // 搜索好友
  Future search(String userName) async {
    final data = await getUsersProfile([userName]);
    List<dynamic> dataMap = json.decode(data);
    setState(() {
      if (Platform.isIOS) {
        IPersonInfoEntity model = IPersonInfoEntity.fromJson(dataMap[0]);
        if (strNoEmpty(model.allowType.toString())) {
          routePush(new AddFriendsDetails('search', model.identifier,
              model.faceURL, model.nickname, model.gender));
        } else {
          isResult = true;
        }
      } else {
        PersonInfoEntity model = PersonInfoEntity.fromJson(dataMap[0]);
        if (strNoEmpty(model.allowType)) {
          routePush(new AddFriendsDetails('search', model.identifier,
              model.faceUrl, model.nickName, model.gender));
        } else {
          isResult = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var leading = new InkWell(
      child: new Container(
        width: 15,
        height: 28,
        child: new Icon(CupertinoIcons.back, color: Colors.black),
      ),
      onTap: () => unFocusMethod(),
    );

    // ignore: unused_element
    List<Widget> searchView() {
      return [
        new Expanded(
          child: new TextField(
            focusNode: searchF,
            controller: searchC,
            style: TextStyle(textBaseline: TextBaseline.alphabetic),
            decoration:
                InputDecoration(hintText: '微信号/手机号', border: InputBorder.none),
            onChanged: (txt) {
              if (strNoEmpty(searchC.text))
                showBtn = true;
              else
                showBtn = false;
              if (isResult) isResult = false;

              setState(() {});
            },
            textInputAction: TextInputAction.search,
            onSubmitted: (txt) => search(txt),
          ),
        ),
        strNoEmpty(searchC.text)
            ? new InkWell(
                child: new Image.asset('assets/images/ic_delete.webp'),
                onTap: () {
                  searchC.text = '';
                  setState(() {});
                },
              )
            : new Container()
      ];
    }

    var bodyView = new SingleChildScrollView(
      child: isSearch
          ? new GestureDetector(
              child: new Column(children: searchBody()),
              onTap: () => unFocusMethod(),
            )
          : body(),
    );

    return WillPopScope(
      child: new Scaffold(
        backgroundColor: appBarColor,
        appBar: new ComMomBar(
          leadingW: isSearch ? leading : null,
          title: '添加朋友',
          titleW: isSearch ? new Row(children: searchView()) : null,
        ),
        body: bodyView,
      ),
      onWillPop: () {
        if (isSearch) {
          unFocusMethod();
        } else {
          Navigator.pop(context);
        }
        return;
      },
    );
  }
}

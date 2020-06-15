import 'dart:convert';

import 'package:wechat_flutter/pages/more/add_friend_page.dart';
import 'package:wechat_flutter/ui/orther/label_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/im/info_handle.dart';
import 'package:wechat_flutter/pages/more/add_friend_details.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/view/list_tile_view.dart';
import 'package:wechat_flutter/ui/view/search_main_view.dart';
import 'package:wechat_flutter/ui/view/search_tile_view.dart';

class NewFriendPage extends StatefulWidget {
  @override
  _NewFriendPageState createState() => new _NewFriendPageState();
}

class _NewFriendPageState extends State<NewFriendPage> {
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
    );
  }

  Widget body() {
    var content = [
      new SearchMainView(
        text: '微信号/手机号',
        isBorder: true,
        onTap: () {
          isSearch = true;
          setState(() {});
          searchF.requestFocus();
        },
      ),
      new LabelRow(
        headW: new Padding(
          padding: EdgeInsets.only(right: 15.0),
          child: new Image.asset('assets/images/contact/ic_voice.png',
              width: 25, fit: BoxFit.cover),
        ),
        label: '添加手机联系人',
      )
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
    currentUser = await im.getCurrentLoginUser();
    setState(() {});
  }

  unFocusMethod() {
    searchF.unfocus();
    isSearch = false;
    if (isResult) isResult = !isResult;
    setState(() {});
  }

  /// 搜索好友
  Future search(String userName) async {
    final data = await getUsersProfile([userName]);
    List<dynamic> dataMap = json.decode(data);
    Map map = dataMap[0];
    if (strNoEmpty(map['allowType'])) {
      routePush(new AddFriendsDetails('search', map['identifier'],
          map['faceUrl'], map['nickName'], map['gender']));
    } else {
      isResult = true;
      setState(() {});
    }
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
            style: TextStyle(textBaseline: TextBaseline.alphabetic),
            focusNode: searchF,
            controller: searchC,
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

    var rWidget = new FlatButton(
      onPressed: () => routePush(new AddFriendPage()),
      child: new Text('添加朋友'),
    );

    return WillPopScope(
      child: new Scaffold(
        backgroundColor: appBarColor,
        appBar: new ComMomBar(
          leadingW: isSearch ? leading : null,
          title: '新的朋友',
          titleW: isSearch ? new Row(children: searchView()) : null,
          rightDMActions: !isSearch ? [rWidget] : [],
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

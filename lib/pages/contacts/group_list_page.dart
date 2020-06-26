import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wechat_flutter/im/fun_dim_group_model.dart';
import 'package:wechat_flutter/pages/chat/chat_page.dart';
import 'package:wechat_flutter/pages/contacts/group_launch_page.dart';
import 'package:wechat_flutter/pages/home/search_page.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class GroupListPage extends StatefulWidget {
  @override
  _GroupListPageState createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  List _groupList = new List();

  @override
  void initState() {
    super.initState();
    _getGroupListModel();
    Notice.addListener(WeChatActions.groupName(), (v) {
      _getGroupListModel();
    });
  }

  // 获取群聊列表
  Future _getGroupListModel() async {
    await DimGroup.getGroupListModel((result) {
      setState(() =>
          _groupList = json.decode(result.toString().replaceAll("'", '"')));
    });
  }

  Widget groupItem(BuildContext context, String gName, String gId,
      String gFaceURL, String title) {
    return FlatButton(
      onPressed: () {
        routePush(ChatPage(
          title: gName,
          type: 2,
          id: gId,
//                returnType: 1,
        ));
      },
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                  width: 50.0,
                  height: 50.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: CachedNetworkImage(
                      imageUrl: gFaceURL,
                      cacheManager: cacheManager,
                    ),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(gName),
                  // 群聊Id
//                        Text(
//                          gId,
//                          style: TextStyle(color: Colors.grey),
//                        ),
                ],
              ),
            ],
          ),
          Container(
            height: 1.0,
            width: winWidth(context),
            color: mainBGColor,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var rWidget = [
      new InkWell(
        child: new Container(
          width: 60.0,
          child: new Image.asset('assets/images/search_black.webp'),
        ),
        onTap: () => routePush(new SearchPage()),
      ),
      new InkWell(
        child: new Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          child: new Image.asset('assets/images/contact/ic_contact_add.webp',
              color: Colors.black, width: 22.0, fit: BoxFit.fitWidth),
        ),
        onTap: () => routePush(new GroupLaunchPage()),
      ),
    ];

    return new Scaffold(
      appBar: new ComMomBar(title: '群聊', rightDMActions: rWidget),
      body: listNoEmpty(_groupList)
          ? ListView.builder(
              itemCount: _groupList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    _groupList.length > 0
                        ? groupItem(
                            context,
                            _groupList[index]['groupName'] ?? '',
                            _groupList[index]['groupId'] ?? '',
                            !strNoEmpty(_groupList[index]['getFaceUrl'])
                                ? defGroupAvatar
                                : _groupList[index]['getFaceUrl'],
                            _groupList[index]['groupId'] ?? '',
                          )
                        : SizedBox(height: 1),
                  ],
                );
              },
            )
          : new Center(
              child: new Text(
                '暂无群聊',
                style: TextStyle(color: mainTextColor),
              ),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Notice.removeListenerByEvent(WeChatActions.groupName());
  }
}

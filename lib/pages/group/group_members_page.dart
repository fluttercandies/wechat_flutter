import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wechat_flutter/im/friend/fun_dim_friend.dart';
import 'package:wechat_flutter/im/fun_dim_group_model.dart';
import 'package:wechat_flutter/pages/group/select_members_page.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class GroupMembersPage extends StatefulWidget {
  final String groupId;

  GroupMembersPage(this.groupId);

  @override
  _GroupMembersPageState createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends State<GroupMembersPage> {
  Future _futureBuilderFuture;
  List memberList = [
    {'user': '+'},
//    {'user': '-'}
  ];

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _gerData();
  }

  handle(String uId) {
    if (!strNoEmpty(uId)) {
      routePush(new SelectMembersPage());
//      routePush(CreateGroupChat(
//        'invite',
//        groupId: widget.groupId,
//        callBack: (data) {
//          if (data.toString().contains('suc')) {
//            setState(() {});
//          }
//          print('邀请好友进群callback >>>> $data');
//        },
//      ));
//    } else {
//      routePush(ConversationDetailPage(
//        title: uId,
//        type: 1,
//      ));
    } else {
      showToast(context, '敬请期待');
    }
  }

  Widget memberItem(item) {
    List userInfo;
    String uId;
    String uFace;
    String nickName;

    if (item['user'] == "+" || item['user'] == '-') {
      return new InkWell(
        child: new SizedBox(
          width: (winWidth(context) - 60) / 5,
          child: Image.asset(
            'assets/images/group/${item['user']}.png',
            height: 48.0,
            width: 48.0,
          ),
        ),
        onTap: () => handle(null),
      );
    }

    return new FutureBuilder(
      future: DimFriend.getUsersProfile(item['user'], (cb) {
        userInfo = json.decode(cb.toString());
        uId = userInfo[0]['identifier'];
        uFace = userInfo[0]['faceUrl'];
        nickName = userInfo[0]['nickName'];
      }),
      builder: (context, snap) {
        return new SizedBox(
          width: (winWidth(context) - 60) / 5,
          child: FlatButton(
            onPressed: () => handle(uId),
            padding: EdgeInsets.all(0),
            highlightColor: Colors.transparent,
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: !strNoEmpty(uFace)
                      ? new Image.asset(
                          defIcon,
                          height: 48.0,
                          width: 48.0,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: uFace,
                          height: 48.0,
                          width: 48.0,
                          cacheManager: cacheManager,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(height: 2),
                Container(
                  alignment: Alignment.center,
                  height: 20.0,
                  width: 50,
                  child: Text(
                    nickName == null || nickName == ''
                        ? '默认昵称'
                        : nickName.length > 5
                            ? '${nickName.substring(0, 3)}...'
                            : nickName,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _gerData() async {
    return DimGroup.getGroupMembersListModel(widget.groupId,
        callback: (result) {
      setState(() {
        memberList.insertAll(
            0, json.decode(result.toString().replaceAll("'", '"')));
      });
    });
  }

  Widget titleWidget() {
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (context, snap) {
        return new Text(
          '聊天成员(${memberList?.length != null ? memberList.length - 1 : 0})',
          style: new TextStyle(
              color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!listNoEmpty(memberList)) {
      return Container();
    }

    return new Scaffold(
      appBar: new ComMomBar(titleW: titleWidget()),
      body: new ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          new Wrap(
            alignment: WrapAlignment.start,
            children: memberList.map(memberItem).toList(),
            runSpacing: 20.0,
            spacing: 10,
          ),
        ],
      ),
    );
  }
}

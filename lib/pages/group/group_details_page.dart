import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/im/friend/fun_dim_friend.dart';
import 'package:wechat_flutter/im/fun_dim_group_model.dart';
import 'package:wechat_flutter/im/group/fun_dim_info.dart';
import 'package:wechat_flutter/tools/commom.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/dialog/confirm_alert.dart';

class GroupDetailsPage extends StatefulWidget {
  final String peer;
  final Callback callBack;

  GroupDetailsPage(this.peer, {this.callBack});

  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  bool _top = false;
  bool _DND = false;
  String _myGroupNickName = '我的默认群昵称';
  String dimUser;
  String groupName;
  String groupNotification;
  String time;
  String cardName;

  List memberList = new List();
  List dataGroup;
  List groupUserInfo = [];

  @override
  void initState() {
    super.initState();
    _getGroupMembers();
    _getGroupInfo();
    getStoreValue('dimUser').then((data) {
      dimUser = data;
    });

    getCardName();
  }

  getCardName() async {
    await InfoModel.getSelfGroupNameCardModel(widget.peer, callback: (str) {
      cardName = str.toString();
      setState(() {});
    });
  }

  // 获取群组信息
  _getGroupInfo() {
    DimGroup.getGroupInfoListModel([widget.peer], callback: (result) {
      dataGroup = json.decode(result.toString().replaceAll("'", '"'));
      groupName = dataGroup[0]['groupName'].toString();
      String notice = strNoEmpty(dataGroup[0]['groupNotification'].toString())
          ? dataGroup[0]['groupNotification'].toString()
          : '暂无公告';
      groupNotification = notice;
      time = dataGroup[0]['groupIntroduction'].toString();
      setState(() {});
    });
  }

  // 获取群成员列表
  _getGroupMembers() async {
    await DimGroup.getGroupMembersListModelLIST(widget.peer,
        callback: (result) {
      print('获取群成员 getGroupMembersListModel >>>> $result');
      memberList = json.decode(result.toString().replaceAll("'", '"'));
      setState(() {});
    });
    if (listNoEmpty(memberList))
      for (int i = 0; i < memberList.length; i++)
        await DimFriend.getUsersProfile(memberList[i]['user'], (cb) {
          groupUserInfo.add(json.decode(cb.toString()));
        });
  }

  Widget memberItem(item) {
    List<dynamic> userInfo;
    String uId;
    String uFace = '';
    String nickName;
//    if (listNoEmpty(groupUserInfo))
//      print('groupUserInfo ' + groupUserInfo[1][0].toString());
    return new FutureBuilder(
        future: DimFriend.getUsersProfile(item['user'], (cb) {
          userInfo = json.decode(cb.toString());
          uId = userInfo[0]['identifier'];
          uFace = userInfo[0]['faceUrl'];
          print('faceUrlfaceUrl::' + cb.toString());
          nickName = userInfo[0]['nickName'];
        }),
        builder: (context, snap) {
          return FlatButton(
              onPressed: () {
//                routePush(
//                    GroupMemberDetails(dimUser == uId ? true : false, uId));
              },
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: !strNoEmpty(uFace)
                        ? new Image.asset(defIcon, height: 48.0, width: 48.0)
                        : CachedNetworkImage(
                            imageUrl: uFace,
                            height: 48.0,
                            width: 48.0,
                            cacheManager: cacheManager,
                          ),
                  ),
                  SizedBox(height: 2),
                  Container(
                    alignment: Alignment.center,
                    height: 20.0,
                    width: 50,
                    child: Text(
                      nickName == null || nickName == ''
                          ? '默认名称'
                          : nickName.length > 4
                              ? '${nickName.substring(0, 3)}...'
                              : nickName,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                ],
              ));
        });
  }

  Widget functionBtn(String title,
      {String detail, Widget right, double width}) {
    if (detail == null && detail == '') {
      return new Container();
    }
    double widthT() {
      if (detail != null) {
        return detail.length > 35 ? SizeConfig.blockSizeHorizontal * 60 : null;
      } else {
        return null;
      }
    }

    return FlatButton(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 20, right: 10.0),
      color: Colors.white,
      onPressed: () {
//        switch (title) {
//          case '群聊名称':
//            routePush(UpdateGroupName(widget.peer, groupName)).then((data) {
//              groupName = data ?? groupName;
//            });
//            break;
//          case '群二维码':
//            break;
//          case '群公告':
//            routePush(
//              GroupBillBoardPage(
//                dataGroup[0]['groupOwner'],
//                groupNotification,
//                groupId: widget.peer,
//                time: time,
//                callback: (timeData) => time = timeData,
//              ),
//            ).then((data) {
//              groupNotification = data ?? groupNotification;
//            });
//            break;
//          case '查找聊天记录':
//            routePush(new SearchPage());
//            break;
//          case '消息免打扰':
//            _DND = !_DND;
//            _DND == true ? _setDND(1) : _setDND(2);
//            break;
//          case '聊天置顶':
//            _top = !_top;
//            setState(() {});
//            _top == true ? _setTop(1) : _setTop(2);
//            break;
//          case '我的群昵称':
//            routePush(MyGroupNickName(detail)).then((myGroupNickName) {
//              _myGroupNickName = myGroupNickName ?? _myGroupNickName;
//            });
//            break;
//          case '设置当前聊天背景':
//            routePush(new ChatBackgroundPage());
//            break;
//          case '我在本群的昵称':
//            groupCardNameModify(context, widget.peer, text: cardName,
//                callback: (isC) {
//              if (isC) getCardName();
//            });
//            break;
//          case '投诉':
//            routePush(new ComplaintPage());
//            break;
//        }
      },
      child: Row(
        children: <Widget>[
          new Container(
            width: width != 0 ? width : null,
            child: Text(title),
          ),
          Expanded(child: Container()),
          new SizedBox(
            width: widthT(),
            child: Text(
              detail ?? '',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          right != null ? right : new Container(),
          new Space(width: 5.0),
          title == '消息免打扰' || title == '聊天置顶'
              ? Container()
              : Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  // 设置消息免打扰
  _setDND(int type) {
    DimGroup.setReceiveMessageOptionModel(widget.peer, dimUser, type,
        callback: (_) {});
  }

  // 设置聊天置顶
  _setTop(int type) {
    print('设置聊天置顶 >>> $type');
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          new Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 10.0),
            width: winWidth(context),
            child: Wrap(
              runSpacing: 20.0,
              children: memberList.map(memberItem).toList(),
            ),
          ),
          new InkWell(
            child: new Container(
              alignment: Alignment.center,
              color: Colors.white,
              padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
              child: new Text(
                '查看全部群成员',
                style: TextStyle(fontSize: 14.0, color: Colors.black54),
              ),
            ),
            onTap: () {
//              routePush(GroupMembersPage(widget.peer));
            },
          ),
          SizedBox(height: 10.0),
          functionBtn('群聊名称',
              detail: groupName.toString().length > 7
                  ? '${groupName.toString().substring(0, 6)}...'
                  : groupName.toString(),
              width: SizeConfig.blockSizeHorizontal * 16),
          functionBtn('群公告',
              detail: groupNotification.toString().length < 10
                  ? groupNotification
                  : '${groupNotification.toString().substring(0, 9)}...',
              width: SizeConfig.blockSizeHorizontal * 16),
          new Space(height: 10.0),
          functionBtn('查找聊天记录'),
          new Space(height: 10.0),
          functionBtn('消息免打扰',
              right: Switch(
                value: _DND,
                onChanged: (bool value) {
                  _DND = value;
                  setState(() {});
                  value == true ? _setDND(1) : _setDND(2);
                },
              )),
          functionBtn('聊天置顶',
              right: Switch(
                value: _top,
                onChanged: (bool value) {
                  _top = value;
                  setState(() {});
                  value == true ? _setTop(1) : _setTop(2);
                },
              )),
          new Space(height: 10.0),
          functionBtn('我在本群的昵称', detail: cardName),
          new Space(),
          functionBtn('设置当前聊天背景'),
          functionBtn('投诉'),
          new Space(),
          functionBtn('清空聊天记录'),
          new Space(),
          FlatButton(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            color: Colors.white,
            onPressed: () {
              if (widget.peer == '') return;
              confirmAlert(context, (isOK) {
                if (isOK) {
//                  DimGroup.quitGroupModel(widget.peer, callback: (str) {
//                    if (str.toString().contains('失败')) {
//                      print('失败了，开始执行解散');
//                      DimGroup.deleteGroupModel(widget.peer, callback: (data) {
//                        if (str.toString().contains('成功')) {
//                          Navigator.of(context).pop();
//                          Navigator.of(context).pop();
//                          if (Navigator.canPop(context)) {
//                            Navigator.of(context).pop();
//                          }
//                          print('解散群聊成功');
//                          showToast(context, '解散群聊成功');
//                        }
//                      });
//                    } else if (str.toString().contains('succ')) {
//                      Navigator.of(context).pop();
//                      Navigator.of(context).pop();
//                      if (Navigator.canPop(context)) {
//                        Navigator.of(context).pop();
//                      }
//                      print('退出成功');
//                      showToast(context, '退出成功');
//                    }
//                  });
                }
              }, tips: '确定要退出本群吗？');
            },
            child: Center(
              child: Text(
                '删除并退出',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0),
              ),
            ),
          ),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (!listNoEmpty(dataGroup)) {
      return new Container(color: Colors.white);
    }

    return Scaffold(
      backgroundColor: Color(0xffEDEDED),
      appBar: new ComMomBar(
//        context,
        title: '聊天信息 (${dataGroup[0]['memberNum']})',
//        callBackType: 1,
//        callback: (data) => widget.callBack(groupName),
      ),
      body: body(),
    );
  }
}

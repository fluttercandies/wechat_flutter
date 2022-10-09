import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_group_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_group_member_full_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_group_member_info_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:wechat_flutter/im/im_handle/Im_api.dart';
import 'package:wechat_flutter/im/im_handle/im_group_api.dart';
import 'package:wechat_flutter/pages/group/group_billboard_page.dart';
import 'package:wechat_flutter/pages/group/group_member_details.dart';
import 'package:wechat_flutter/pages/group/group_members_page.dart';
import 'package:wechat_flutter/pages/group/group_remarks_page.dart';
import 'package:wechat_flutter/pages/group/select_members_page.dart';
import 'package:wechat_flutter/pages/home/search_page.dart';
import 'package:wechat_flutter/pages/mine/code_page.dart';
import 'package:wechat_flutter/pages/settings/chat_background_page.dart';
import 'package:wechat_flutter/tools/commom.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/dialog/confirm_alert.dart';
import 'package:wechat_flutter/ui/view/indicator_page_view.dart';

class GroupDetailsPage extends StatefulWidget {
  final String peer;
  final Callback callBack;

  GroupDetailsPage(this.peer, {this.callBack});

  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  /// 是否聊天置顶
  bool _top = false;

  /// 是否显示群成员昵称
  bool _showName = false;

  /// 是否保存到通讯录
  bool _contact = false;

  /// 是否免打扰
  bool _dnd = false;

  String cardName = '默认';

  /// 成员列表数据
  List<V2TimGroupMemberFullInfo> memberList = [
    V2TimGroupMemberFullInfo(userID: '+'),
    // V2TimGroupMemberFullInfo(userID: '-'),
  ];
  V2TimGroupInfo dataGroupInfo;

  String get groupNotification {
    return strNoEmpty(dataGroupInfo.notification.toString())
        ? dataGroupInfo.notification.toString()
        : '暂无公告';
  }

  @override
  void initState() {
    super.initState();
    try {
      _getGroupMembers();
      _getGroupInfo();
    } catch (e) {
      print("出现错误::${e.toString()}");
      showToast(context, "群聊异常");
    }
    getCardName();
  }

  getCardName() async {
    // await InfoModel.getSelfGroupNameCardModel(widget.peer, callback: (str) {
    //   cardName = str.toString();
    //   setState(() {});
    // });
  }

  // 获取群组信息
  _getGroupInfo() async {
    dataGroupInfo =
        (await ImGroupApi.getGroupsInfo([widget.peer]))[0].groupInfo;
    setState(() {});
  }

  // 获取群成员列表
  _getGroupMembers() async {
    final V2TimGroupMemberInfoResult result =
        await ImGroupApi.getGroupMemberList(widget.peer);

    memberList.insertAll(0, result.memberInfoList);
    setState(() {});
  }

  /// 成员item的UI序列渲染
  Widget memberItem(V2TimGroupMemberFullInfo item) {
    /// "+" 和 "-"
    if (item.userID == "+" || item.userID == '-') {
      return new InkWell(
        child: new SizedBox(
          width: (winWidth(context) - 60) / 5,
          child: Image.asset(
            'assets/images/group/${item.userID}.png',
            height: 48.0,
            width: 48.0,
          ),
        ),

        /// "+" 和 "-" 点击之后
        onTap: () => Get.to(new SelectMembersPage()),
      );
    }

    return new SizedBox(
      width: (winWidth(context) - 60) / 5,
      child: FlatButton(
        onPressed: () =>
            Get.to(GroupMemberDetails(Data.user() == item.userID, item.userID)),
        padding: EdgeInsets.all(0),
        highlightColor: Colors.transparent,
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: !strNoEmpty(item.faceUrl)
                  ? new Image.asset(
                      defIcon,
                      height: 48.0,
                      width: 48.0,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: item.faceUrl,
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
                '${!strNoEmpty(item.nickName) ? item.userID : item.nickName.length > 4 ? '${item.nickName.substring(0, 3)}...' : item.nickName}',
                style: TextStyle(fontSize: 12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 设置消息免打扰
  _setDND(int type) {
    // DimGroup.setReceiveMessageOptionModel(widget.peer, Data.user(), type,
    //     callback: (_) {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (dataGroupInfo == null) {
      return new Container(color: Colors.white);
    }

    return Scaffold(
      backgroundColor: Color(0xffEDEDED),
      appBar: new ComMomBar(title: '聊天信息 (${dataGroupInfo.memberCount})'),
      body: new ScrollConfiguration(
        behavior: MyBehavior(),
        child: new ListView(
          children: <Widget>[
            new Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 10.0, bottom: 10),
              width: winWidth(context),
              child: Wrap(
                runSpacing: 20.0,
                spacing: 10,
                children: memberList.map(memberItem).toList(),
              ),
            ),
            new Visibility(
              visible: memberList.length > 20,
              child: new FlatButton(
                padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
                color: Colors.white,
                child: new Text(
                  '查看全部群成员',
                  style: TextStyle(fontSize: 14.0, color: Colors.black54),
                ),
                onPressed: () => Get.to(new GroupMembersPage(widget.peer)),
              ),
            ),
            SizedBox(height: 10.0),
            functionBtn(
              '群聊名称',
              detail: dataGroupInfo.groupName.toString().length > 7
                  ? '${dataGroupInfo.groupName.toString().substring(0, 6)}...'
                  : dataGroupInfo.groupName.toString(),
            ),
            functionBtn(
              '群二维码',
              right: new Image.asset('assets/images/group/group_code.png',
                  width: 20),
            ),
            functionBtn(
              '群公告',
              detail: groupNotification.toString(),
            ),
            new Visibility(
              visible: dataGroupInfo.owner == Data.user(),
              child: functionBtn('群管理'),
            ),
            functionBtn('备注'),
            new Space(height: 10.0),
            functionBtn('查找聊天记录'),
            new Space(height: 10.0),
            functionBtn('消息免打扰',
                right: CupertinoSwitch(
                  value: _dnd,
                  onChanged: (bool value) {
                    _dnd = value;
                    setState(() {});
                    value ? _setDND(1) : _setDND(2);
                  },
                )),
            functionBtn('聊天置顶',
                right: CupertinoSwitch(
                  value: _top,
                  onChanged: (bool value) {
                    _top = value;
                    setState(() {});
                    value ? _setTop(1) : _setTop(2);
                  },
                )),
            functionBtn('保存到通讯录',
                right: CupertinoSwitch(
                  value: _contact,
                  onChanged: (bool value) {
                    _contact = value;
                    setState(() {});
                    value ? _setTop(1) : _setTop(2);
                  },
                )),
            new Space(height: 10.0),
            functionBtn('我在群里的昵称', detail: cardName),
            functionBtn('显示群成员昵称',
                right: CupertinoSwitch(
                  value: _showName,
                  onChanged: (bool value) {
                    _showName = value;
                    setState(() {});
                    value ? _setTop(1) : _setTop(2);
                  },
                )),
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
                    // DimGroup.quitGroupModel(widget.peer, callback: (str) {
                    //   if (str.toString().contains('失败')) {
                    //     print('失败了，开始执行解散');
                    //     DimGroup.deleteGroupModel(widget.peer,
                    //         callback: (data) {
                    //       if (str.toString().contains('成功')) {
                    //         Navigator.of(context).pop();
                    //         Navigator.of(context).pop();
                    //         if (Navigator.canPop(context)) {
                    //           Navigator.of(context).pop();
                    //         }
                    //         print('解散群聊成功');
                    //         showToast(context, '解散群聊成功');
                    //       }
                    //     });
                    //   } else if (str.toString().contains('succ')) {
                    //     Navigator.of(context).pop();
                    //     Navigator.of(context).pop();
                    //     if (Navigator.canPop(context)) {
                    //       Navigator.of(context).pop();
                    //     }
                    //     print('退出成功');
                    //     showToast(context, '退出成功');
                    //   }
                    // });
                  }
                }, tips: '确定要退出本群吗？');
              },
              child: Text(
                '删除并退出',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0),
              ),
            ),
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  /*
  * 点击之后的事件处理，[title]是标题，点击之后的具体事件就是通过标题来判断
  * */
  handle(String title) {
    switch (title) {
      case '备注':
        Get.to(new GroupRemarksPage());
        break;
      case '群聊名称':
        Get.to(
          new GroupRemarksPage(
            groupInfoType: GroupInfoType.name,
            text: dataGroupInfo.groupName,
            groupId: widget.peer,
          ),
        ).then((data) {
          dataGroupInfo.groupName = data ?? dataGroupInfo.groupName;
          Notice.send(WeChatActions.groupName(), dataGroupInfo.groupName);
        });
        break;
      case '群二维码':
        Get.to(new CodePage(isGroup: true, id: dataGroupInfo.groupID));
        break;
      case '群公告':
        Get.to(
          new GroupBillBoardPage(
            dataGroupInfo.owner,
            dataGroupInfo.notification,
            groupId: widget.peer,
          ),
        ).then((data) {
          dataGroupInfo.notification = data ?? dataGroupInfo.notification;
        });
        break;
      case '查找聊天记录':
        Get.to(new SearchPage());
        break;
      case '消息免打扰':
        _dnd = !_dnd;
        _dnd ? _setDND(1) : _setDND(2);
        break;
      case '聊天置顶':
        _top = !_top;
        setState(() {});
        _top ? _setTop(1) : _setTop(2);
        break;
      case '设置当前聊天背景':
        Get.to(new ChatBackgroundPage());
        break;
      case '我在群里的昵称':
        Get.to(
          new GroupRemarksPage(
            groupInfoType: GroupInfoType.cardName,
            text: cardName,
            groupId: widget.peer,
          ),
        ).then((data) {
          cardName = data ?? cardName;
        });
        break;
      case '投诉':
        Get.to(new WebViewPage(helpUrl, '投诉'));
        break;
      case '清空聊天记录':
        confirmAlert(
          context,
          (isOK) {
            if (isOK) showToast(context, '敬请期待');
          },
          tips: '确定删除群的聊天记录吗？',
          okBtn: '清空',
        );
        break;
    }
  }

  _setTop(int i) {}

  /*
  * item封装调用
  * */
  functionBtn(
    title, {
    final String detail,
    final Widget right,
  }) {
    return GroupItem(
      detail: detail,
      title: title,
      right: right,
      onPressed: () => handle(title),
    );
  }
}

class GroupItem extends StatelessWidget {
  final String detail;
  final String title;
  final VoidCallback onPressed;
  final Widget right;

  GroupItem({
    this.detail,
    this.title,
    this.onPressed,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
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

    bool isSwitch = title == '消息免打扰' ||
        title == '聊天置顶' ||
        title == '保存到通讯录' ||
        title == '显示群成员昵称';
    bool noBorder = title == '备注' ||
        title == '查找聊天记录' ||
        title == '保存到通讯录' ||
        title == '显示群成员昵称' ||
        title == '投诉' ||
        title == '清空聊天记录';

    return FlatButton(
      padding: EdgeInsets.only(left: 15, right: 15.0),
      color: Colors.white,
      onPressed: () => onPressed(),
      child: new Container(
        padding: EdgeInsets.only(
          top: isSwitch ? 10 : 15.0,
          bottom: isSwitch ? 10 : 15.0,
        ),
        decoration: BoxDecoration(
          border: noBorder
              ? null
              : Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Expanded(
                  child: Text(title),
                ),
                new Visibility(
                  visible: title != '群公告',
                  child: new SizedBox(
                    width: widthT(),
                    child: Text(
                      detail ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                right != null ? right : new Container(),
                new Space(width: 10.0),
                isSwitch
                    ? Container()
                    : Image.asset(
                        'assets/images/group/ic_right.png',
                        width: 15,
                      ),
              ],
            ),
            new Visibility(
              visible: title == '群公告',
              child: new Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  detail ?? '',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

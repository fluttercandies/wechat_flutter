import 'package:get/get.dart';
import 'package:tencent_im_sdk_plugin/enum/group_member_role_enum.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_group_member.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:wechat_flutter/config/dictionary.dart';
import 'package:wechat_flutter/im/im_handle/Im_api.dart';
import 'package:wechat_flutter/im/im_handle/im_friend_api.dart';
import 'package:wechat_flutter/im/im_handle/im_group_api.dart';
import 'package:wechat_flutter/im/model/contacts.dart';
import 'package:wechat_flutter/tools/im/im_info_util.dart';
import 'package:wechat_flutter/ui/item/contact_item.dart';
import 'package:wechat_flutter/ui/item/contact_view.dart';
import 'package:wechat_flutter/ui/item/launch_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'dart:convert';
import 'package:wechat_flutter/pages/more/add_friend_details.dart';

class GroupLaunchPage extends StatefulWidget {
  @override
  _GroupLaunchPageState createState() => new _GroupLaunchPageState();
}

class _GroupLaunchPageState extends State<GroupLaunchPage> {
  bool isSearch = false;
  bool showBtn = false;
  bool isResult = false;

  List defItems = ['选择一个群', '面对面建群'];
  List<Contact> _contacts = [];
  List<String> selectData = [];

  FocusNode searchF = new FocusNode();
  TextEditingController searchC = new TextEditingController();
  ScrollController sC;

  final Map _letterPosMap = {INDEX_BAR_WORDS[0]: 0.0};

  List<Widget> searchBody() {
    if (isResult) {
      return [
        new Space(height: mainSpace),
      ];
    } else {
      return [
        new Space(height: mainSpace),
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  unFocusMethod() {
    searchF.unfocus();
    isSearch = false;
    if (isResult) isResult = !isResult;
    setState(() {});
  }

  Future getContacts() async {
    final List<V2TimFriendInfo> listFriendInfo =
        await ImFriendApi.getFriendList();
    List<Contact> listContact =
        ImInfoUtil.friendListToContactList(listFriendInfo);
    _contacts.clear();
    _contacts..addAll(listContact);
    _contacts
        .sort((Contact a, Contact b) => a.nameIndex.compareTo(b.nameIndex));
    sC = new ScrollController();

    /// 计算用于 IndexBar 进行定位的关键通讯录列表项的位置
    var _totalPos = ContactItemState.heightItem(false);
    for (int i = 0; i < _contacts.length; i++) {
      bool _hasGroupTitle = true;
      if (i > 0 &&
          _contacts[i].nameIndex.compareTo(_contacts[i - 1].nameIndex) == 0)
        _hasGroupTitle = false;

      if (_hasGroupTitle) _letterPosMap[_contacts[i].nameIndex] = _totalPos;

      _totalPos += ContactItemState.heightItem(_hasGroupTitle);
    }
    if (mounted) setState(() {});
  }

  // 搜索好友
  Future search(String userName) async {
    final List<V2TimUserFullInfo> data = await ImApi.getUsersInfo([userName]);
    if (!listNoEmpty(data)) {
      showToast(context, "未找到用户");
      return;
    }
    V2TimUserFullInfo model = data[0];
    if (strNoEmpty("${model?.allowType ?? ""}")) {
      Get.to(
        new AddFriendsDetails('search', model?.userID, model?.faceUrl,
            model?.nickName, model?.gender),
      );
    } else {
      isResult = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> body() {
      return [
        new Space(height: 50.0),
        new Container(
          child: new Column(
            children:
                defItems.map((item) => new LaunchGroupItem(item)).toList(),
          ),
        ),
        new Expanded(
          child: new ContactView(
            sC: sC,
            contacts: _contacts,
            type: ClickType.select,
            callback: (v) {
              selectData = v;
            },
          ),
        )
      ];
    }

    var rWidget = new ComMomButton(
      text: '确定',
      style: TextStyle(color: Colors.white),
      width: 45.0,
      margin: EdgeInsets.all(10.0),
      radius: 4.0,
      onTap: () async {
        final callBack = await ImGroupApi.createGroupV2(selectData.join(),
            memberList: selectData.map((e) {
              GroupMemberRoleTypeEnum role = e == Data.user()
                  ? GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_OWNER
                  : GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_MEMBER;
              return V2TimGroupMember(role: role, userID: e);
            }).toList());

        if (callBack.code == 0) {
          showToast(context, '创建群组成功');
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        } else {
          showToast(context, callBack.desc);
        }
      },
    );

    return WillPopScope(
      child: new Scaffold(
        backgroundColor: appBarColor,
        appBar: new ComMomBar(title: '发起群聊', rightDMActions: <Widget>[rWidget]),
        body: new Stack(
          children: <Widget>[
            new MainInputBody(
              child: isSearch
                  ? new GestureDetector(
                      child: new Column(children: searchBody()),
                      onTap: () => unFocusMethod(),
                    )
                  : new Column(children: body()),
              onTap: () => unFocusMethod(),
            ),
            new Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                border: Border(
                  bottom: BorderSide(
                      color: isSearch ? Colors.green : lineColor, width: 0.3),
                ),
              ),
              width: winWidth(context),
              alignment: Alignment.center,
              height: 50.0,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: new LaunchSearch(
                searchC: searchC,
                searchF: searchF,
                onChanged: (txt) {
                  if (strNoEmpty(searchC.text))
                    showBtn = true;
                  else
                    showBtn = false;
                  if (isResult) isResult = false;

                  setState(() {});
                },
                onTap: () {
                  setState(() => isSearch = true);
                },
                onSubmitted: (txt) => search(txt),
                delOnTap: () => setState(() {}),
              ),
            )
          ],
        ),
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

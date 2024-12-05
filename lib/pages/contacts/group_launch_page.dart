import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:wechat_flutter/config/dictionary.dart';
import 'package:wechat_flutter/im/friend_handle.dart';
import 'package:wechat_flutter/im/info_handle.dart';
import 'package:wechat_flutter/im/model/contacts.dart';
import 'package:wechat_flutter/pages/more/add_friend_details.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/item/contact_item.dart';
import 'package:wechat_flutter/ui/item/contact_view.dart';
import 'package:wechat_flutter/ui/item/launch_group.dart';

class GroupLaunchPage extends StatefulWidget {
  @override
  _GroupLaunchPageState createState() => _GroupLaunchPageState();
}

class _GroupLaunchPageState extends State<GroupLaunchPage> {
  bool isSearch = false;
  bool showBtn = false;
  bool isResult = false;

  List<String> defItems = ['选择一个群', '面对面建群'];
  List<Contact> _contacts = [];
  List<String> selectData = [];

  FocusNode searchF = FocusNode();
  TextEditingController searchC = TextEditingController();
  ScrollController? sC;

  final Map _letterPosMap = {INDEX_BAR_WORDS[0]: 0.0};

  List<Widget> searchBody() {
    if (isResult) {
      return [
        SizedBox(height: mainSpace),
      ];
    } else {
      return [
        SizedBox(height: mainSpace),
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  void unFocusMethod() {
    searchF.unfocus();
    isSearch = false;
    if (isResult) {
      isResult = !isResult;
    }
    setState(() {});
  }

  Future getContacts() async {
    final str = await ContactsPageData().listFriend();

    List<Contact> listContact = str;
    _contacts.clear();
    _contacts..addAll(listContact);
    _contacts
        .sort((Contact a, Contact b) => a.nameIndex.compareTo(b.nameIndex));
    sC = ScrollController();

    /// 计算用于 IndexBar 进行定位的关键通讯录列表项的位置
    var _totalPos = ContactItemState.heightItem(false);
    for (int i = 0; i < _contacts.length; i++) {
      bool _hasGroupTitle = true;
      if (i > 0 &&
          _contacts[i].nameIndex.compareTo(_contacts[i - 1].nameIndex) == 0) {
        _hasGroupTitle = false;
      }

      if (_hasGroupTitle) {
        _letterPosMap[_contacts[i].nameIndex] = _totalPos;
      }

      _totalPos += ContactItemState.heightItem(_hasGroupTitle);
    }
    if (mounted) {
      setState(() {});
    }
  }

  // 搜索好友
  Future search(String userName) async {
    final List<V2TimUserFullInfo> data = await getUsersProfile([userName]);
    if (data[0].allowType != null) {
      Get.to(
        AddFriendsDetails(
          'search',
          data[0].userID!,
          data[0].faceUrl ?? '',
          data[0].nickName ?? '',
          data[0].gender ?? 0,
        ),
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
        SizedBox(height: 50.0),
        Container(
          child: Column(
            children:
                defItems.map((item) => LaunchGroupItem(item: item)).toList(),
          ),
        ),
        Expanded(
          child: ContactView(
            sC: sC,
            contacts: _contacts,
            type: ClickType.select,
            callback: (List<String> v) {
              selectData = v;
            },
          ),
        )
      ];
    }

    var rWidget = ComMomButton(
      text: '确定',
      style: TextStyle(color: Colors.white),
      width: 45.0,
      margin: EdgeInsets.all(10.0),
      radius: 4.0,
      onTap: () {
        if (Platform.isIOS) {
          showToast('IOS暂不支持发起群聊');
          return;
        }
        createGroupChat(selectData, name: selectData.join(),
            callback: (callBack) {
          if (callBack.toString().contains('succ')) {
            showToast('创建群组成功');
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        });
        showToast('当前ID：${selectData.toString()}');
      },
    );

    return WillPopScope(
      child: Scaffold(
        backgroundColor: appBarColor,
        appBar: ComMomBar(title: '发起群聊', rightDMActions: <Widget>[rWidget]),
        body: Stack(
          children: <Widget>[
            MainInputBody(
              child: isSearch
                  ? GestureDetector(
                      child: Column(children: searchBody()),
                      onTap: () => unFocusMethod(),
                    )
                  : Column(children: body()),
              onTap: () => unFocusMethod(),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                border: Border(
                  bottom: BorderSide(
                      color: isSearch ? Colors.green : lineColor, width: 0.3),
                ),
              ),
              width: Get.width,
              alignment: Alignment.center,
              height: 50.0,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: LaunchSearch(
                searchC: searchC,
                searchF: searchF,
                onChanged: (txt) {
                  if (strNoEmpty(searchC.text)) {
                    showBtn = true;
                  } else {
                    showBtn = false;
                  }
                  if (isResult) {
                    isResult = false;
                  }

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
      onWillPop: () async {
        if (isSearch) {
          unFocusMethod();
        } else {
          Navigator.pop(context);
        }
        return true;
      },
    );
  }
}

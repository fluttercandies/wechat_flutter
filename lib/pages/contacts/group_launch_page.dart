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

  List<String> defItems = <String>['选择一个群', '面对面建群'];
  List<Contact> _contacts = <Contact>[];
  List<String> selectData = <String>[];

  FocusNode searchF = FocusNode();
  TextEditingController searchC = TextEditingController();
  ScrollController? sC;

  final Map _letterPosMap = <dynamic, dynamic>{INDEX_BAR_WORDS[0]: 0.0};

  List<Widget> searchBody() {
    if (isResult) {
      return <Widget>[
        const SizedBox(height: mainSpace),
      ];
    } else {
      return <Widget>[
        const SizedBox(height: mainSpace),
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
    final List<Contact> str = await ContactsPageData().listFriend();

    final List<Contact> listContact = str;
    _contacts.clear();
    _contacts.addAll(listContact);
    _contacts
        .sort((Contact a, Contact b) => a.nameIndex.compareTo(b.nameIndex));
    sC = ScrollController();

    /// 计算用于 IndexBar 进行定位的关键通讯录列表项的位置
    double totalPos = ContactItemState.heightItem(false);
    for (int i = 0; i < _contacts.length; i++) {
      bool hasGroupTitle = true;
      if (i > 0 &&
          _contacts[i].nameIndex.compareTo(_contacts[i - 1].nameIndex) == 0) {
        hasGroupTitle = false;
      }

      if (hasGroupTitle) {
        _letterPosMap[_contacts[i].nameIndex] = totalPos;
      }

      totalPos += ContactItemState.heightItem(hasGroupTitle);
    }
    if (mounted) {
      setState(() {});
    }
  }

  // 搜索好友
  Future<void> search(String userName) async {
    final List<V2TimUserFullInfo> data =
        await getUsersProfile(<String>[userName]);
    if (data[0].allowType != null) {
      Get.to<void>(
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
      return <Widget>[
        const SizedBox(height: 50.0),
        Column(
          children: defItems
              .map((String item) => LaunchGroupItem(item: item))
              .toList(),
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

    final ComMomButton rWidget = ComMomButton(
      text: '确定',
      style: const TextStyle(color: Colors.white),
      width: 45.0,
      margin: const EdgeInsets.all(10.0),
      radius: 4.0,
      onTap: () async {
        final bool result = await createGroupChat(
          selectData,
          name: selectData.join(),
        );
        if (result) {
          showToast('创建群组成功');
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        } else {
          showToast('创建失败');
        }
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: LaunchSearch(
                searchC: searchC,
                searchF: searchF,
                onChanged: (String txt) {
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
                onSubmitted: (String txt) => search(txt),
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

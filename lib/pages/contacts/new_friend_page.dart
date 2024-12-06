import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:wechat_flutter/im/info_handle.dart';
import 'package:wechat_flutter/pages/more/add_friend_details.dart';
import 'package:wechat_flutter/pages/more/add_friend_page.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/orther/label_row.dart';
import 'package:wechat_flutter/ui/view/search_main_view.dart';
import 'package:wechat_flutter/ui/view/search_tile_view.dart';

class NewFriendPage extends StatefulWidget {
  const NewFriendPage({super.key});

  @override
  State<NewFriendPage> createState() => _NewFriendPageState();
}

class _NewFriendPageState extends State<NewFriendPage> {
  bool isSearch = false;
  bool showBtn = false;
  bool isResult = false;

  FocusNode searchF = FocusNode();
  TextEditingController searchC = TextEditingController();

  Widget body() {
    final List<StatelessWidget> content = <StatelessWidget>[
      SearchMainView(
        text: '微信号/手机号',
        isBorder: true,
        onTap: () {
          isSearch = true;
          setState(() {});
          searchF.requestFocus();
        },
      ),
      LabelRow(
        headW: Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Image.asset('assets/images/contact/ic_voice.png',
              width: 25, fit: BoxFit.cover),
        ),
        label: '添加手机联系人',
      )
    ];

    return Column(children: content);
  }

  List<Widget> searchBody() {
    if (isResult) {
      return <Widget>[
        Container(
          color: Colors.white,
          width: Get.width,
          height: 110.0,
          alignment: Alignment.center,
          child: const Text(
            '该用户不存在',
            style: TextStyle(color: mainTextColor),
          ),
        ),
        const SizedBox(height: mainSpace),
        SearchTileView(searchC.text, type: 1),
        Container(
          color: Colors.white,
          width: Get.width,
          height: Get.height - 185 * 1.38,
        )
      ];
    } else {
      return <Widget>[
        SearchTileView(
          searchC.text,
          onPressed: () => search(searchC.text),
        ),
        Container(
          color: strNoEmpty(searchC.text) ? Colors.white : appBarColor,
          width: Get.width,
          height: strNoEmpty(searchC.text)
              ? (Get.height - 65 * 2.1) - winKeyHeight(context)
              : Get.height,
        )
      ];
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void unFocusMethod() {
    searchF.unfocus();
    isSearch = false;
    if (isResult) isResult = !isResult;
    setState(() {});
  }

  /// 搜索好友
  Future search(String userName) async {
    final List<V2TimUserFullInfo> data =
        await getUsersProfile(<String>[userName]);
    final V2TimUserFullInfo model = data[0];
    if (model.allowType != null) {
      Get.to<void>(AddFriendsDetails('search', model.userID!,
          model.faceUrl ?? '', model.nickName ?? '', model.gender ?? 0));
    } else {
      isResult = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final InkWell leading = InkWell(
      child: Container(
        width: 15,
        height: 28,
        child: const Icon(CupertinoIcons.back, color: Colors.black),
      ),
      onTap: () => unFocusMethod(),
    );

    // ignore: unused_element
    List<Widget> searchView() {
      return <Widget>[
        Expanded(
          child: TextField(
            style: const TextStyle(textBaseline: TextBaseline.alphabetic),
            focusNode: searchF,
            controller: searchC,
            decoration: const InputDecoration(
                hintText: '微信号/手机号', border: InputBorder.none),
            onChanged: (String txt) {
              if (strNoEmpty(searchC.text)) {
                showBtn = true;
              } else {
                showBtn = false;
              }
              if (isResult) isResult = false;

              setState(() {});
            },
            textInputAction: TextInputAction.search,
            onSubmitted: (String txt) => search(txt),
          ),
        ),
        if (strNoEmpty(searchC.text))
          InkWell(
            child: Image.asset('assets/images/ic_delete.webp'),
            onTap: () {
              searchC.text = '';
              setState(() {});
            },
          )
        else
          Container()
      ];
    }

    final SingleChildScrollView bodyView = SingleChildScrollView(
      child: isSearch
          ? GestureDetector(
              child: Column(children: searchBody()),
              onTap: () => unFocusMethod(),
            )
          : body(),
    );

    final TextButton rWidget = TextButton(
      onPressed: () => Get.to<void>(AddFriendPage()),
      child: const Text('添加朋友'),
    );

    return WillPopScope(
      child: Scaffold(
        backgroundColor: appBarColor,
        appBar: ComMomBar(
          leadingW: isSearch ? leading : null,
          title: '新的朋友',
          titleW: isSearch ? Row(children: searchView()) : null,
          rightDMActions: !isSearch ? <Widget>[rWidget] : <Widget>[],
        ),
        body: bodyView,
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

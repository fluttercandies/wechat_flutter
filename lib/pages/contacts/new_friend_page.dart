import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_application.dart';
import 'package:wechat_flutter/im/im_handle/im_friend_api.dart';
import 'package:wechat_flutter/pages/contacts/contacts_details_page.dart';
import 'package:wechat_flutter/pages/more/add_friend_details.dart';
import 'package:wechat_flutter/pages/more/add_friend_page.dart';
import 'package:wechat_flutter/tools/app_config.dart';
import 'package:wechat_flutter/tools/data/my_theme.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/item/circle_item_widget.dart';
import 'package:wechat_flutter/ui/orther/label_row.dart';
import 'package:wechat_flutter/ui/view/list_tile_view.dart';
import 'package:wechat_flutter/ui/view/search_main_view.dart';
import 'package:wechat_flutter/ui/view/search_tile_view.dart';
import 'package:wechat_flutter/ui_commom/data/no_data_view.dart';

class NewFriendPage extends StatefulWidget {
  @override
  _NewFriendPageState createState() => new _NewFriendPageState();
}

class _NewFriendPageState extends State<NewFriendPage> {
  bool isSearch = false;
  bool showBtn = false;
  bool isResult = false;

  String currentUser;

  List<V2TimFriendApplication> allData = [];
  bool isLoadOk = false;

  FocusNode searchF = new FocusNode();
  TextEditingController searchC = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    allData = await ImFriendApi.getFriendApplicationList();

    /// 模拟数据
    allData.insert(
      0,
      V2TimFriendApplication(
        userID: '12',
        type: 0,
        nickname: "昵称",
        addTime:
            DateTime.now().subtract(Duration(hours: 30)).millisecondsSinceEpoch,
      ),
    );

    /// 处理数据
    if (listNoEmpty(allData)) {
      for (int i = 0; i < allData.length; i++) {
        final int addTime = allData[i].addTime;
        bool isNeedInsert = addTime <=
            DateTime.now().subtract(Duration(days: 3)).millisecondsSinceEpoch ~/
                1000;
        if (isNeedInsert) {
          allData.insert(
              i, V2TimFriendApplication(userID: 'Three days ago', type: -1));
          break;
        }
      }

      allData.insert(
          0, V2TimFriendApplication(userID: 'Nearly three days', type: -1));
    }

    isLoadOk = true;
    if (mounted) setState(() {});
  }

  Widget buildItem(item) {
    return new ListTileView(
      border: item['title'] == '雷达加朋友'
          ? null
          : Border(top: BorderSide(color: lineColor, width: 0.2)),
      title: item['title'],
      label: item['label'],
    );
  }

  Widget titleWidget(String title) {
    return Container(
      width: winWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.grey.withOpacity(0.2),
      child: Text(title),
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
      ),

      /// 不需要显示暂无数据模式
      // if (!listNoEmpty(allData) && isLoadOk) NoDataView(),
      ...List.generate(allData.length, (index) {
        V2TimFriendApplication friendModel = allData[index];
        if (friendModel.userID == "Nearly three days" &&
            friendModel.type == -1) {
          return titleWidget("近三天");
        } else if (friendModel.userID == "Three days ago" &&
            friendModel.type == -1) {
          return titleWidget("三天前");
        } else {
          return CircleItemWidget(
            type: 2,
            imageUrl: friendModel?.faceUrl ?? AppConfig.mockCover,
            title: friendModel?.nickname ?? "",
            des: friendModel?.addWording ?? "",
            onTap: () {
              Get.to(ContactsDetailsPage(
                  id: friendModel?.userID,
                  title: friendModel?.nickname ?? "",
                  avatar: friendModel?.faceUrl ?? AppConfig.mockCover));
            },
            endWidget: (friendModel?.type != 0)
                ? Text("已添加")
                : Container(
                    alignment: Alignment.center,
                    width: 45,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: MyTheme.themeColor()[200],
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                    child: Text(
                      '查看',
                      style: TextStyle(color: MyTheme.themeColor()),
                    ),
                  ),
          );
        }
      })
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

  unFocusMethod() {
    searchF.unfocus();
    isSearch = false;
    if (isResult) isResult = !isResult;
    setState(() {});
  }

  /// 搜索好友
  Future search(String userName) async {
    List<dynamic> dataMap = [];
    Map map = dataMap[0];
    if (strNoEmpty(map['allowType'])) {
      Get.to(new AddFriendsDetails('search', map['identifier'], map['faceUrl'],
          map['nickName'], map['gender']));
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
      onPressed: () => Get.to(new AddFriendPage()),
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

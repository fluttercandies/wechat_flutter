import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_application.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_check_result.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:wechat_flutter/im/im_handle/Im_api.dart';
import 'package:wechat_flutter/im/im_handle/im_friend_api.dart';
import 'package:wechat_flutter/pages/common/contacts/contact_system_page.dart';
import 'package:wechat_flutter/pages/common/contacts/contacts_details_page.dart';
import 'package:wechat_flutter/pages/common/more/add_friend_details.dart';
import 'package:wechat_flutter/tools/config/app_config.dart';
import 'package:wechat_flutter/tools/theme/my_theme.dart';
import 'package:wechat_flutter/tools/func/func.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/item/circle_item_widget.dart';
import 'package:wechat_flutter/ui/orther/label_row.dart';
import 'package:wechat_flutter/ui/view/list_tile_view.dart';
import 'package:wechat_flutter/ui/view/search_main_view.dart';
import 'package:wechat_flutter/ui/view/search_tile_view.dart';
import 'package:wechat_flutter/ui_commom/image/sw_image.dart';

class NewFriendPage extends StatefulWidget {
  @override
  _NewFriendPageState createState() => new _NewFriendPageState();
}

class _NewFriendPageState extends State<NewFriendPage> {
  bool isSearch = false;
  bool showBtn = false;
  bool isResult = false;

  String? currentUser;

  List<V2TimFriendApplication?>? allData = [];

  /// 是否是好友数据 key=用户id
  Map<String, bool> isFriendData = {};
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

    List<String> userIdList = [];

    /// 处理数据
    if (listNoEmpty(allData)) {
      for (int i = 0; i < allData!.length; i++) {
        userIdList.add(allData![i]!.userID);

        final int addTime = allData![i]!.addTime!;
        bool isNeedInsert = addTime <=
            DateTime.now().subtract(Duration(days: 3)).millisecondsSinceEpoch ~/
                1000;
        if (isNeedInsert) {
          allData!.insert(
              i, V2TimFriendApplication(userID: 'Three days ago', type: -1));
          break;
        }
      }

      allData!.insert(
          0, V2TimFriendApplication(userID: 'Nearly three days', type: -1));
    }

    List<V2TimFriendCheckResult> checkFriend =
        (await ImFriendApi.checkFriend(userIdList)) ?? [];
    for (V2TimFriendCheckResult result in checkFriend) {
      /// result.resultType = 3 表示双向好友
      isFriendData[result.userID] = result.resultType == 3;
      print("新数据::${isFriendData.toString()}");
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
      width: FrameSize.winWidth(),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.grey.withOpacity(0.2),
      child: Text(title),
    );
  }

  Widget body() {
    var content = [
      new SearchMainView(
        text: '${AppConfig.appName}号/手机号',
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
        onPressed: () {
          Get.to(ContactSystemPage());
        },
      ),

      /// 不需要显示暂无数据模式
      // if (!listNoEmpty(allData) && isLoadOk) NoDataView(),
      ...List.generate(allData!.length, (index) {
        V2TimFriendApplication friendModel = allData![index]!;
        if (friendModel.userID == "Nearly three days" &&
            friendModel.type == -1) {
          return titleWidget("近三天");
        } else if (friendModel.userID == "Three days ago" &&
            friendModel.type == -1) {
          return titleWidget("三天前");
        } else {
          return CircleItemWidget(
            type: 2,
            imageUrl: friendModel.faceUrl ?? AppConfig.mockCover,
            title: friendModel.nickname ?? "",
            des: friendModel.addWording ?? "",
            onTap: () {
              Get.to(
                ContactsDetailsPage(
                  id: friendModel.userID,
                  title: friendModel.nickname ?? "",
                  avatar: friendModel.faceUrl ?? AppConfig.mockCover,
                  friendModel: friendModel,
                ),
              );
            },
            endWidget: isFriendData[friendModel.userID]!
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
          width: FrameSize.winWidth(),
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
          width: FrameSize.winWidth(),
          height: (FrameSize.winHeight() - 185 * 1.38),
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
          width: FrameSize.winWidth(),
          height: strNoEmpty(searchC.text)
              ? (FrameSize.winHeight() - 65 * 2.1) -
                  FrameSize.winKeyHeight(context)
              : FrameSize.winHeight(),
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
    final List<V2TimUserFullInfo>? data = await ImApi.getUsersInfo([userName]);
    if (!listNoEmpty(data)) {
      q1Toast("未找到用户");
      return;
    }
    V2TimUserFullInfo model = data![0];
    if (strNoEmpty("${model.allowType ?? ''}")) {
      Get.to(new AddFriendsDetails(
          'search', model.userID, model.faceUrl, model.nickName, model.gender));
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
            decoration: InputDecoration(
                hintText: '${AppConfig.appName}号/手机号',
                border: InputBorder.none),
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

    var rWidget = new TextButton(
      onPressed: () => Get.toNamed(RouteConfig.addFriendPage),
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
      onWillPop: () async {
        if (isSearch) {
          unFocusMethod();
        } else {
          Navigator.pop(context);
        }
        return false;
      },
    );
  }
}

class SearchMainViewNew extends StatefulWidget {
  final TextEditingController controller;
  final Function(bool hasFocus) onCallFocus;
  final ValueChanged<String> onChanged;
  final Color? color;
  final GestureTapCallback? onTap;
  final String? hintText;
  final ValueChanged<String>? onSubmitted;

  const SearchMainViewNew(
      {required this.controller,
      required this.onCallFocus,
      required this.onChanged,
      this.onSubmitted,
      this.color,
      this.onTap,
      this.hintText,
      Key? key})
      : super(key: key);

  @override
  State<SearchMainViewNew> createState() => _SearchMainViewNewState();
}

class _SearchMainViewNewState extends State<SearchMainViewNew> {
  bool isSearch = false;

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        isSearch = false;
        setState(() {});
      } else {
        if (!isSearch) {
          isSearch = true;
          setState(() {});
        }
      }
      widget.onCallFocus.call(focusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle hintStyle = TextStyle(color: Colors.grey, fontSize: 15);
    String hintText = widget.hintText ?? "搜索";
    return MyInkWell(
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              height: 35,
              decoration: BoxDecoration(
                  color: widget.color == null ? Colors.white : widget.color,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Space(width: 5),
                  SwImage(
                    'assets/images/contact/ic_search_long.png',
                    color: Colors.grey,
                    width: 20,
                  ),
                  Space(width: 5),
                  if (isSearch)
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        expands: true,
                        maxLines: null,
                        focusNode: focusNode,
                        controller: widget.controller,
                        textInputAction: TextInputAction.search,
                        onSubmitted: widget.onSubmitted,
                        decoration: InputDecoration(
                          hintStyle: hintStyle,
                          hintText: hintText,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        onChanged: (value) {
                          if (mounted) setState(() {});
                          widget.onChanged(value);
                        },
                      ),
                    )
                  else
                    Text(
                      hintText,
                      style: hintStyle,
                    ),
                  () {
                    if (!strNoEmpty(widget.controller.text) || !isSearch) {
                      return Container();
                    }
                    return SwImage(
                      'images/main/ic_delete.webp',
                      width: 15,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      onTap: () {
                        widget.controller.text = "";
                        setState(() {});

                        widget.onChanged("");
                      },
                    );
                  }()
                ],
              ),
            ),
          ),
          if (isSearch)
            TextButton(
              style: ButtonStyle(
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                focusNode.unfocus();
              },
              child: Text('取消'),
            )
        ],
      ),
      onTap: widget.onTap ??
          () {
            isSearch = true;
            focusNode.requestFocus();
            setState(() {});
          },
    );
  }
}

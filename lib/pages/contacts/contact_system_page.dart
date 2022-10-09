import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:toast/toast.dart';
import 'package:wechat_flutter/im/im_handle/Im_api.dart';
import 'package:wechat_flutter/pages/contacts/contacts_details_page.dart';
import 'package:wechat_flutter/pages/contacts/new_friend_page.dart';
import 'package:wechat_flutter/tools/app_config.dart';
import 'package:wechat_flutter/tools/data/my_theme.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/item/build_sus_widget.dart';
import 'package:wechat_flutter/ui/item/circle_item_widget.dart';
import 'package:wechat_flutter/ui_commom/app/my_scaffold.dart';
import 'package:wechat_flutter/ui_commom/dialog/confirm_sw_dialog.dart';

class ContactSystemModel extends ISuspensionBean {
  final String displayName;
  final String phone;
  final bool isRegister;
  final V2TimUserFullInfo info;

  String tagIndex;
  String namePinyin;

  @override
  String getSuspensionTag() => tagIndex;

  ContactSystemModel(this.displayName, this.phone, this.isRegister, this.info,
      this.tagIndex, this.namePinyin);
}

// 系统手机通讯录页面
// 通讯录朋友页面
class ContactSystemPage extends StatefulWidget {
  const ContactSystemPage({Key key}) : super(key: key);

  @override
  State<ContactSystemPage> createState() => _ContactSystemPageState();
}

class _ContactSystemPageState extends State<ContactSystemPage> {
  List<Contact> _contacts = [];
  bool _permissionDenied = false;
  bool isLoadOk = false;
  bool isShowSearchResult = false;

  /// 实际显示的数据
  List<ContactSystemModel> allData = [];
  List<ContactSystemModel> searchData = [];

  String deniedText =
      "目前无法访问你的通讯录，无法帮你添加朋友。请在系统设置[手机系统的设置]-隐私-通讯录里允许${AppConfig.appName}访问你的通讯录。";

  String checkText =
      "无数据或无权限，请在系统设置[手机系统的设置]-隐私-通讯录里检查是否允许${AppConfig.appName}访问你的通讯录。";

  TextEditingController searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  /*
  * 设置加载完毕
  * */
  void setLoadOk() {
    isLoadOk = true;
    if (mounted) setState(() {});
  }

  /*
  * 取通讯录
  * */
  Future _fetchContacts() async {
    if (await FlutterContacts.requestPermission(readonly: true)) {
      _permissionDenied = true;
    }

    final contacts = await FlutterContacts.getContacts();
    _contacts = contacts;

    if (!listNoEmpty(_contacts)) {
      if (_permissionDenied) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          confirmSwDialog(
            context,
            text: deniedText,
            isHaveCancel: false,
          );
        });
      }
      setLoadOk();
      return;
    }

    List<List<String>> _nameAndPhone = await getNameAndPhone(contacts);

    final List<String> userIds = _nameAndPhone.map((e) => e[1]).toList();

    List<V2TimUserFullInfo> userInfoList = await ImApi.getUsersInfo(userIds);
    if (!listNoEmpty(userInfoList)) {
      /// 全部未注册
      allData = _nameAndPhone.map<ContactSystemModel>((e) {
        String pinyin = PinyinHelper.getPinyinE(e[0]);
        String tag = pinyin.substring(0, 1).toUpperCase();

        return ContactSystemModel(e[0], e[1], false, null, tag, pinyin);
      }).toList();

      _handleList(allData);
      return;
    }

    /// 标识是否注册
    userInfoList.forEach((iElement) {
      _nameAndPhone.forEach((nElement) {
        if (iElement.userID == nElement[1]) {
          nElement[0] = iElement.nickName + "(${nElement[0]})";

          /// 表示已注册
          nElement[2] = json.encode(iElement);
        }
      });
    });

    /// 处理数据
    allData = _nameAndPhone.map<ContactSystemModel>((e) {
      final bool _isRegisterValue = strNoEmpty(e[2]);

      String pinyin = PinyinHelper.getPinyinE(e[0]);
      String tag = pinyin.substring(0, 1).toUpperCase();

      return ContactSystemModel(
        e[0],
        e[1],
        _isRegisterValue,
        _isRegisterValue ? V2TimUserFullInfo.fromJson(json.decode(e[2])) : null,
        tag,
        pinyin,
      );
    }).toList();

    _handleList(allData);
  }

  /*
  * 处理数据列表
  * */
  void _handleList(List<ContactSystemModel> list) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].displayName);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(allData);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(allData);

    setLoadOk();
  }

  /*
  * 获取名字和手机号
  *
  * 二维数组的第一个是名字，第二个手机号
  * */
  Future<List<List<String>>> getNameAndPhone(List<Contact> contacts) async {
    List<List<String>> nameAndPhones = [];

    for (Contact e in contacts) {
      final Contact contact = await FlutterContacts.getContact(e.id);
      final String number = contact.phones.isNotEmpty
          ? contact.phones.first.number.replaceAll(" ", "")
          : '(none)';
      nameAndPhones.add([contact?.displayName ?? "未知", number, ""]);
    }

    return nameAndPhones;
  }

  /*
  * 搜索
  * */
  void onSearch(String searchValue) {
    searchData = [];

    if (!strNoEmpty(searchValue.trim())) {
      if (mounted) setState(() {});
      return;
    }

    allData.forEach((element) {
      if (element.displayName.contains(searchValue)) {
        searchData.add(element);
      }
    });
    if (mounted) setState(() {});
  }

  Widget showTipText(String text) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Center(child: Text(text)),
    );
  }

  Widget _buildSusWidget(String susTag) {
    return BuildSubWidget(susTag);
  }

  Widget _circleItemWidget(ContactSystemModel systemModel) {
    final String avatar = systemModel.info?.faceUrl ?? AppConfig.mockCover;

    return CircleItemWidget(
      type: 1,
      imageUrl: avatar,
      title: systemModel?.displayName ?? "",
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());

        if (!systemModel.isRegister) {
          Toast.show("此用户未注册，请先邀请对方注册此app吧～", context);
          return;
        }

        Get.to(ContactsDetailsPage(
            id: systemModel?.info?.userID ?? systemModel.phone,
            title: systemModel.info?.nickName ?? systemModel.displayName,
            avatar: avatar));
      },
      des: !systemModel.isRegister
          ? systemModel.phone
          : (systemModel.info?.selfSignature ?? "暂无"),
      rSpace: 30,
      endWidget: !systemModel.isRegister
          ? Text(
              "未注册",
              style: TextStyle(color: Colors.grey),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: MyTheme.themeColor(),
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              child: Text(
                '查看',
                style: TextStyle(color: Colors.white),
              ),
            ),
    );
  }

  Widget _buildListItem(ContactSystemModel systemModel) {
    String susTag = systemModel.getSuspensionTag();

    return Column(
      children: <Widget>[
        Offstage(
          offstage: systemModel.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        _circleItemWidget(systemModel),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: appBarColor,
      appBar: ComMomBar(
        title: '通讯录朋友',
        mainColor: Colors.black,
        backgroundColor: appBarColor,
      ),
      body: (_permissionDenied && !listNoEmpty(_contacts))
          ? showTipText(deniedText)
          : isLoadOk && !listNoEmpty(_contacts)
              ? showTipText(checkText)
              : Column(
                  children: [
                    SearchMainViewNew(
                      controller: searchC,
                      onCallFocus: (bool hasFocus) {
                        isShowSearchResult = hasFocus;
                        if (mounted) setState(() {});
                      },
                      onChanged: onSearch,
                      onSubmitted: onSearch,
                    ),
                    Expanded(
                      child: isShowSearchResult
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                ContactSystemModel model = searchData[index];
                                return _circleItemWidget(model);
                              },
                              itemCount: searchData.length,
                            )
                          : AzListView(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              data: allData,
                              itemCount: allData.length,
                              itemBuilder: (BuildContext context, int index) {
                                ContactSystemModel model = allData[index];
                                return _buildListItem(model);
                              },
                              indexBarData:
                                  SuspensionUtil.getTagIndexList(allData),
                              indexHintBuilder: (context, hint) {
                                return Container(
                                  alignment: Alignment.center,
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[700].withAlpha(200),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    hint,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.0,
                                      fontWeight: MyTheme.fontWeight(),
                                    ),
                                  ),
                                );
                              },
                              indexBarMargin: EdgeInsets.all(10),
                              indexBarOptions: IndexBarOptions(
                                needRebuild: true,
                                decoration: MyTheme.getIndexBarDecoration(
                                    Colors.grey[50]),
                                downDecoration: MyTheme.getIndexBarDecoration(
                                    Colors.grey[200]),
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }
}

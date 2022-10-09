import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:wechat_flutter/im/im_handle/Im_api.dart';
import 'package:wechat_flutter/tools/im/im_info_util.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/card/set_item.dart';

class FriendProPage extends StatefulWidget {
  const FriendProPage({Key key}) : super(key: key);

  @override
  State<FriendProPage> createState() => _FriendProPageState();
}

class _FriendProPageState extends State<FriendProPage> {
  V2TimUserFullInfo userInfo;

  /// 添加我是否需要验证
  RxBool isNeedVer = true.obs;

  /// 向我推荐通讯录朋友
  RxBool rec = true.obs;

  List items = [
    "加我为朋友时需要验证",
    "添加我的方式",
    "向我推荐通讯录朋友",
    "仅聊天",
    "朋友圈",
    "视频号",
    "看一看",
    "微信运动",
    "通讯录黑名单",
  ];

  bool isNotBorder(String value) {
    return value == "加我为朋友时需要验证" ||
        value == "向我推荐通讯录朋友" ||
        value == "微信运动" ||
        value == "通讯录黑名单";
  }

  bool isTopMargin(String value) {
    return value == "添加我的方式" || value == "通讯录黑名单" || value == "帮助与反馈";
  }

  void actionHandle(String value) {}

  @override
  void initState() {
    super.initState();
    getCurrentAddType();
  }

  Future getCurrentAddType() async {
    userInfo = (await ImApi.getUsersInfo([Data.user()]))[0];
    //用户的好友验证方式 0:允许所有人加我好友 1:不允许所有人加我好友 2:加我好友需我确认
    isNeedVer.value = userInfo.allowType != 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: ComMomBar(title: "朋友权限"),
      body: ListView(
        children: items.map((e) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isTopMargin(e))
                new Container(
                    width: double.infinity, height: 10, color: appBarColor),
              if (e == "仅聊天")
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 6, top: 15),
                  child: Text(
                    '朋友圈',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
              SetItem(
                onTap: () => actionHandle(e),
                isBorder: isNotBorder(e),
                text: e,
                subText: "",
                bottomText: e == "加我为朋友时需要验证" ? "开启后，为你推荐已经注册账号的手机联系人。" : null,
                rWidget: e == "加我为朋友时需要验证" || e == "向我推荐通讯录朋友"
                    ? Obx(() {
                        return CupertinoSwitch(
                          onChanged: (bool value) {
                            //用户的好友验证方式 0:允许所有人加我好友 1:不允许所有人加我好友 2:加我好友需我确认
                            if (e == "加我为朋友时需要验证") {
                              isNeedVer.value = !isNeedVer.value;
                              ImApi.setSelfInfo(
                                  allowType: isNeedVer.value ? 2 : 0);
                            } else {
                              rec.value = !rec.value;
                            }
                          },
                          value:
                              e == "加我为朋友时需要验证" ? isNeedVer.value : rec.value,
                        );
                      })
                    : null,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

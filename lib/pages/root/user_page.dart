import 'package:wechat_flutter/im/friend_handle.dart';
import 'package:wechat_flutter/im/model/user_data.dart';
import 'package:wechat_flutter/im/send_handle.dart';
import 'package:wechat_flutter/ui/dialog/confirm_alert.dart';
import 'package:wechat_flutter/ui/new_friend_card.dart';
import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<UserData> _userData = [];

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future getUserData() async {
    final str = await UserDataPageGet().listUserData();

    List<UserData> listData = str;
    _userData.clear();
    _userData..addAll(listData.reversed);
    if (mounted) setState(() {});
  }

  action(UserData model) {
    addFriend(
      model.identifier,
      context,
      suCc: (v) {
        if (v) {
          sendTextMsg(model.identifier, 1, '你好${model.name}，我添加你为好友啦');
          Navigator.of(context).maybePop();
        }
      },
    );
  }

  Widget body() {
    if (_userData == null || _userData?.length == 0)
      return new LoadingView(isStr: false);

    return new ListView.builder(
      itemBuilder: (context, index) {
        UserData model = _userData[index];
        return new NewFriendCard(
          img: model.avatar,
          name: model.name,
          isAdd: model.isAdd,
          onTap: () => action(model),
        );
      },
      itemCount: _userData?.length ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: appBarColor,
      appBar: new ComMomBar(
        title: '推荐好友',
        rightDMActions: <Widget>[
          new ComMomButton(
            text: '查看提示',
            style: TextStyle(color: Colors.white),
            margin: EdgeInsets.all(10.0),
            onTap: () {
              confirmAlert(
                context,
                (bool) {
                  if (bool) showToast(context, '感谢支持');
                },
                tips:
                    '如果显示添加成功了好友列表还是没这个好友，说明对方的好友数量上限了，你可以选择下一个或者自己注册一个新的来测试。',
                okBtn: '确定',
                isWarm: true,
                style: TextStyle(fontWeight: FontWeight.w500),
              );
            },
          )
        ],
      ),
      body: body(),
    );
  }
}

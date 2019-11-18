import 'package:dim_example/im/friend_handle.dart';
import 'package:dim_example/im/model/user_data.dart';
import 'package:dim_example/im/send_handle.dart';
import 'package:dim_example/ui/new_friend_card.dart';
import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

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
      cc: (v) {
        if (v) {
          showToast(context, '添加成功');
          sendTextMsg(model.identifier, 1, '你好${model.name}，我添加你为好友啦');
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: appBarColor,
      appBar: new ComMomBar(title: '添加好友进行聊天'),
      body: new ListView.builder(
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
      ),
    );
  }
}

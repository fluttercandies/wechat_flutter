import 'package:wechat_flutter/pages/wechat_friends/page/wechat_friends_circle.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/pages/more/verification_page.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/orther/button_row.dart';
import 'package:wechat_flutter/ui/orther/label_row.dart';
import 'package:wechat_flutter/ui/orther/person_card.dart';

class AddFriendsDetails extends StatefulWidget {
  final String type;
  final String imUser;
  final String avatarImg;
  final String nickName;
  final int gender;

  AddFriendsDetails(
      this.type, this.imUser, this.avatarImg, this.nickName, this.gender);

  @override
  _AddFriendsDetailsState createState() => _AddFriendsDetailsState();
}

class _AddFriendsDetailsState extends State<AddFriendsDetails> {
  Widget body() {
    var content = [
      new PersonCard(
          imageUrl: widget.avatarImg,
          name: strNoEmpty(widget.nickName) ? widget.nickName : widget.imUser,
          gender: 0,
          area: '北京 海淀'),
      new Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 15.0),
        child: new HorizontalLine(height: 0.7),
      ),
      new Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: new LabelRow(label: '设置备注和标签'),
      ),
      new LabelRow(
        label: '个性签名',
        labelWidth: winWidth(context) / 4.5,
        isRight: false,
        isLine: true,
        value: '这是我的签名',
      ),
      new LabelRow(
        label: '朋友圈',
        onPressed: () => routePush(new WeChatFriendsCircle()),
      ),
      new ButtonRow(
        margin: EdgeInsets.only(top: 10.0),
        text: '添加到通讯录',
        onPressed: () => routePush(
            new VerificationPage(nickName: widget.nickName, id: widget.imUser)),
      ),
    ];

    return new Column(children: content);
  }

  @override
  Widget build(BuildContext context) {
    var rWidget = [
      new InkWell(
        child: new Image.asset('assets/images/right_more.png'),
        onTap: () {},
      )
    ];

    return Scaffold(
      backgroundColor: appBarColor,
      appBar: new ComMomBar(
          title: '', backgroundColor: Colors.white, rightDMActions: rWidget),
      body: new SingleChildScrollView(child: body()),
    );
  }
}

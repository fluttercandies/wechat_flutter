import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/tools/entity/api_entity.dart';
import 'package:wechat_flutter/tools/http/api_v2.dart';
import 'package:wechat_flutter/im/login_handle.dart';
import 'package:wechat_flutter/pages/common/login/select_location_page.dart';
import 'package:wechat_flutter/tools/provider/login_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _tC =
      new TextEditingController(text: AppConfig.mockPhone);

  @override
  void initState() {
    super.initState();
    initEdit();
  }

  initEdit() async {
    final user = await SharedUtil.instance!.getString(Keys.account);
    if (strNoEmpty(user)) {
      _tC.text = user!;
    }
  }

  Widget bottomItem(item) {
    return new Row(
      children: <Widget>[
        new InkWell(
          child: new Text(item, style: TextStyle(color: tipColor)),
          onTap: () {
            q1Toast("暂未开启" + item);
          },
        ),
        item == "微信安全中心"
            ? new Container()
            : new Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: new VerticalLine(height: 15.0),
              )
      ],
    );
  }

  Widget body(LoginModel model) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(
              left: 20.0, top: mainSpace * 3, bottom: mainSpace * 2),
          child: new Text("手机号登录", style: TextStyle(fontSize: 25.0)),
        ),
        new TextButton(
          child: new Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: new Row(
              children: <Widget>[
                new Container(
                  width: FrameSize.winWidth() * 0.25,
                  alignment: Alignment.centerLeft,
                  child: new Text("国家/地区",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w400)),
                ),
                new Expanded(
                  child: new Text(
                    model.area,
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
          onPressed: () async {
            final result = await Get.to(new SelectLocationPage());
            if (result == null) return;
            model.area = result;
            model.refresh();
            SharedUtil.instance!.saveString(Keys.area, result);
          },
        ),
        new Container(
          padding: EdgeInsets.only(bottom: 5.0),
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.grey, width: 0.15))),
          child: new Row(
            children: <Widget>[
              new Container(
                width: FrameSize.winWidth() * 0.25,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 25.0),
                child: new Text(
                  "手机号",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                ),
              ),
              new Expanded(
                  child: new TextField(
                controller: _tC,
                maxLines: 1,
                style: TextStyle(textBaseline: TextBaseline.alphabetic),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter(new RegExp(r'[0-9]'), allow: true)
                ],
                decoration: InputDecoration(
                    hintText: "请填写手机号", border: InputBorder.none),
                onChanged: (text) {
                  setState(() {});
                },
              ))
            ],
          ),
        ),
        new Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: new InkWell(
            child: new Text(
              "用微信号/QQ号/邮箱登录",
              style: TextStyle(color: tipColor),
            ),
            onTap: () => q1Toast("暂未开启"),
          ),
        ),
        new Space(height: mainSpace * 2.5),
        new ComMomButton(
          text: "下一步",
          style: TextStyle(
              color:
                  _tC.text == '' ? Colors.grey.withOpacity(0.8) : Colors.white),
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          color: _tC.text == ''
              ? Color.fromRGBO(226, 226, 226, 1.0)
              : Color.fromRGBO(8, 191, 98, 1.0),
          onTap: () {
            login(context, _tC.text);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LoginModel>(context);

    List btItem = [
      "找回密码",
      "紧急冻结",
      "微信安全中心",
    ];

    return new Scaffold(
      appBar:
          new ComMomBar(title: '', leadingImg: 'assets/images/bar_close.png'),
      body: new Container(
        height: FrameSize.winHeight(),
        color: appBarColor,
        child: new Stack(
          children: <Widget>[
            new SingleChildScrollView(child: body(model)),
            new Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: btItem.map(bottomItem).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

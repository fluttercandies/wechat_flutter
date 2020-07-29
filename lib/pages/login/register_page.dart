import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/pages/login/login_begin_page.dart';
import 'package:wechat_flutter/provider/login_model.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/view/edit_view.dart';

import 'select_location_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isSelect = false;

  FocusNode nickF = new FocusNode();
  TextEditingController nickC = new TextEditingController();
  FocusNode phoneF = new FocusNode();
  TextEditingController phoneC = new TextEditingController();
  FocusNode pWF = new FocusNode();
  TextEditingController pWC = new TextEditingController();

  String localAvatarImgPath = '';

  _openGallery() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      localAvatarImgPath = img.path;
      setState(() {});
    } else {
      return;
    }
  }

  Widget body(LoginModel model) {
    var column = [
      new Padding(
        padding: EdgeInsets.only(
            left: 5.0, top: mainSpace * 3, bottom: mainSpace * 2),
        child: new Text(S.of(context).numberRegister,
            style: TextStyle(fontSize: 25.0)),
      ),
      new Row(
        children: <Widget>[
          new Expanded(
            child: new EditView(
              label: S.of(context).nickName,
              hint: S.of(context).exampleName,
              bottomLineColor:
                  nickF.hasFocus ? Colors.green : lineColor.withOpacity(0.5),
              focusNode: nickF,
              controller: nickC,
              onTap: () => setState(() {}),
            ),
          ),
          new InkWell(
            child: !strNoEmpty(localAvatarImgPath)
                ? new Image.asset('assets/images/login/select_avatar.webp',
                    width: 60.0, height: 60.0, fit: BoxFit.cover)
                : new ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: new Image.file(File(localAvatarImgPath),
                        width: 60.0, height: 60.0, fit: BoxFit.cover),
                  ),
            onTap: () => _openGallery(),
          ),
        ],
      ),
      new InkWell(
        child: new Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
          child: new Row(
            children: <Widget>[
              new Container(
                width: winWidth(context) * 0.25,
                alignment: Alignment.centerLeft,
                child: new Text(S.of(context).phoneCity,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400)),
              ),
              new Expanded(
                child: new Text(
                  model.area,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        ),
        onTap: () async {
          final result = await routePush(new SelectLocationPage());
          if (result == null) return;
          model.area = result;
          model.refresh();
          SharedUtil.instance.saveString(Keys.area, result);
        },
      ),
      new EditView(
        label: S.of(context).phoneNumber,
        hint: S.of(context).phoneNumberHint,
        controller: phoneC,
        focusNode: phoneF,
        onTap: () => setState(() {}),
      ),
      new EditView(
        label: S.of(context).passWord,
        hint: S.of(context).pwTip,
        controller: pWC,
        focusNode: pWF,
        bottomLineColor:
            pWF.hasFocus ? Colors.green : lineColor.withOpacity(0.5),
        onTap: () => setState(() {}),
        onChanged: (str) {
          setState(() {});
        },
      ),
      new Space(height: mainSpace * 2),
      new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new InkWell(
            child: new Image.asset(
              'assets/images/login/${isSelect ? 'ic_select_have.webp' : 'ic_select_no.png'}',
              width: 25.0,
              height: 25.0,
              fit: BoxFit.cover,
            ),
            onTap: () {
              setState(() => isSelect = !isSelect);
            },
          ),
          new Padding(
            padding: EdgeInsets.only(left: mainSpace / 2),
            child: new Text(
              S.of(context).readAgree,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          new InkWell(
            child: new Text(
              S.of(context).protocolName,
              style: TextStyle(color: tipColor),
            ),
            onTap: () => routePush(new WebViewPage(
                S.of(context).protocolUrl, S.of(context).protocolTitle)),
          ),
        ],
      ),
      new ComMomButton(
        text: S.of(context).register,
        style: TextStyle(
            color:
                pWC.text == '' ? Colors.grey.withOpacity(0.8) : Colors.white),
        margin: EdgeInsets.only(top: 20.0),
        color: pWC.text == ''
            ? Color.fromRGBO(226, 226, 226, 1.0)
            : Color.fromRGBO(8, 191, 98, 1.0),
        onTap: () {
          if (!strNoEmpty(pWC.text)) return;
          if (!isMobilePhoneNumber(phoneC.text)) {
            showToast(context, '请输入正确的手机号');
            return;
          }
          showToast(context, '注册成功');
          popToRootPage();
        },
      ),
    ];

    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: column),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LoginModel>(context);

    return new Scaffold(
      appBar:
          new ComMomBar(title: "", leadingImg: 'assets/images/bar_close.png'),
      body: new MainInputBody(
        color: appBarColor,
        child: new SingleChildScrollView(child: body(model)),
        onTap: () => setState(() => {}),
      ),
    );
  }
}

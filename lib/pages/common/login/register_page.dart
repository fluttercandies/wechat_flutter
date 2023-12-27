import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/tools/entity/api_entity.dart';
import 'package:wechat_flutter/tools/http/api_v2.dart';
import 'package:wechat_flutter/tools/provider/login_model.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/view/edit_view.dart';
import 'package:wechat_flutter/ui_commom/bt/small_button.dart';

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
  FocusNode codeF = new FocusNode();
  TextEditingController codeC = new TextEditingController();

  Timer? timer;
  RxInt count = 0.obs;

  String localAvatarImgPath = '';
  String? codeToken = "";

  _openGallery() async {
    XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);

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
        child: new Text("手机号注册",
            style: TextStyle(fontSize: 25.0)),
      ),
      new Row(
        children: <Widget>[
          new Expanded(
            child: new EditView(
              label: "昵称",
              hint: "例如: 陈晨",
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
                width: FrameSize.winWidth() * 0.25,
                alignment: Alignment.centerLeft,
                child: new Text("国家/地区",
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
          final result = await Get.to(new SelectLocationPage());
          if (result == null) return;
          model.area = result;
          model.refresh();
          SharedUtil.instance!.saveString(Keys.area, result);
        },
      ),
      new EditView(
        label: "手机号",
        hint: "请填写手机号",
        controller: phoneC,
        focusNode: phoneF,
        keyboardType: TextInputType.number,
        onTap: () => setState(() {}),
      ),
      new EditView(
        label: '验证码',
        hint: '输入验证码',
        controller: codeC,
        focusNode: codeF,
        bottomLineColor:
            codeF.hasFocus ? Colors.green : lineColor.withOpacity(0.5),
        onTap: () => setState(() {}),
        onChanged: (str) {
          setState(() {});
        },
        rWidget: Obx(() {
          return SmallButton(
            color: count.value == 0 ? null : Colors.grey,
            margin: EdgeInsets.all(0),
            onPressed: () => sendCode(),
            padding: EdgeInsets.all(0),
            minWidth: 80,
            child: Text(count.value == 0 ? '发送' : "${count.value}"),
          );
        }),
      ),
      new EditView(
        label: "密码",
        hint: "填写密码",
        controller: pWC,
        focusNode: pWF,
        obscureText: true,
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
              "已阅读并同意",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          new InkWell(
            child: new Text(
              "《微信软件许可及服务协议》",
              style: TextStyle(color: tipColor),
            ),
            onTap: () => Get.to(new WebViewPage(
                "https://weixin.qq.com/agreement?lang=zh_CN", "微信软件许可及服务协议")),
          ),
        ],
      ),
      new ComMomButton(
        text: "注册",
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
            q1Toast( '请输入正确的手机号');
            return;
          }
          registerHandle();
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

  Future registerHandle() async {
    final bool rsp = await ApiV2.register(context,
        phone: phoneC.text,
        password: pWC.text,
        code: codeC.text,
        token: codeToken);
    if (!rsp) {
      return;
    }
    q1Toast( '注册成功');
    Get.offNamedUntil('/', (route) => false);
  }

  void cancelTimer() {
    timer?.cancel();
    timer = null;
  }

  Future sendCode() async {
    if (count.value != 0) {
      return;
    }
    cancelTimer();

    final CodeRspEntity? codeRspEntity =
        await ApiV2.smsGet(context, phone: phoneC.text);
    if (codeRspEntity == null) {
      return;
    }

    codeToken = codeRspEntity.token;

    if (strNoEmpty(codeRspEntity.code)) {
      codeC.text = codeRspEntity.code!;
      setState(() {});
    }

    count.value = 60;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      count.value--;
      if (count.value <= 0) {
        cancelTimer();
        return;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    cancelTimer();
  }
}

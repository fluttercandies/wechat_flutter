import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/config/provider_config.dart';
import 'package:wechat_flutter/im/login_handle.dart';
import 'package:wechat_flutter/pages/login/register_page.dart';
import 'package:wechat_flutter/pages/settings/language_page.dart';
import 'package:wechat_flutter/provider/global_model.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

import 'login_page.dart';

class LoginBeginPage extends StatefulWidget {
  @override
  _LoginBeginPageState createState() => new _LoginBeginPageState();
}

class _LoginBeginPageState extends State<LoginBeginPage> {
  Widget body(GlobalModel model) {
    var buttons = [
      new ComMomButton(
        text: S.of(context).login,
        margin: EdgeInsets.only(left: 10.0),
        width: 100.0,
        onTap: () => routePush(
            ProviderConfig.getInstance().getLoginPage(new LoginPage())),
      ),
      new ComMomButton(
          text: S.of(context).register,
          color: bgColor,
          style:
              TextStyle(fontSize: 15.0, color: Color.fromRGBO(8, 191, 98, 1.0)),
          margin: EdgeInsets.only(right: 10.0),
          onTap: () => routePush(
              ProviderConfig.getInstance().getLoginPage(new RegisterPage())),
          width: 100.0),
    ];

    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Container(
          alignment: Alignment.topRight,
          child: new InkWell(
            child: new Padding(
              padding: EdgeInsets.all(10.0),
              child: new Text(S.of(context).language,
                  style: TextStyle(color: Colors.white)),
            ),
            onTap: () => routePush(new LanguagePage()),
          ),
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: buttons,
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    init(context);
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GlobalModel>(context);

    var bodyMain = new Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bsc.webp'), fit: BoxFit.cover)),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: body(model),
    );

    return new Scaffold(body: bodyMain);
  }
}

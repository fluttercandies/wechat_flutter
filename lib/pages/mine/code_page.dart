import 'package:dim_example/ui/dialog/code_dialog.dart';
import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class CodePage extends StatefulWidget {
  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  @override
  Widget build(BuildContext context) {
    var rWidget = [
      new SizedBox(
        width: 60,
        child: new FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () => codeDialog(context),
          child: new Image.asset(contactAssets + 'ic_contacts_details.png'),
        ),
      )
    ];

    var body = [
      new Container(
        margin: EdgeInsets.only(
            left: 20.0, right: 20.0, top: winHeight(context) / 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        child: new Padding(
          padding: EdgeInsets.all(20.0),
          child: new Column(
            children: <Widget>[
              new SizedBox(
                width: winWidth(context) - 40.0,
                child: new CardPerson(
                  name: 'CrazyQ1',
                  area: '北京 海淀',
                  icon: 'assets/images/Contact_Male.webp',
                ),
              ),
              new Space(width: mainSpace),
              new CachedNetworkImage(
                imageUrl: myCode,
                width: winWidth(context) - 40,
              ),
              new Space(height: mainSpace * 2),
              new Text(
                '扫一扫上面的二维码图案，加我微信',
                style: TextStyle(color: mainTextColor),
              ),
            ],
          ),
        ),
      )
    ];
    return new Scaffold(
      backgroundColor: chatBg,
      appBar: new ComMomBar(title: '二维码名片', rightDMActions: rWidget),
      body: new SingleChildScrollView(child: new Column(children: body)),
    );
  }
}

class CardPerson extends StatelessWidget {
  final String name, icon, area;

  CardPerson({this.name, this.icon, this.area});

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: new ImageView(img: defAvatar, width: 45),
        ),
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Text(
                  name ?? '',
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600),
                ),
                new Space(width: mainSpace / 2),
                new Image.asset(
                  icon ?? '',
                  width: 18.0,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            new Space(height: mainSpace / 3),
            new Text(
              area ?? '',
              style: TextStyle(fontSize: 14.0, color: mainTextColor),
            ),
          ],
        )
      ],
    );
  }
}

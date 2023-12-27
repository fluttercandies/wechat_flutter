import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/theme/my_theme.dart';

class BuildSubWidget extends StatelessWidget {
  final String susTag;

  const BuildSubWidget(this.susTag, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      height: MyTheme.susItemHeight(),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Text(
            '$susTag',
            textScaleFactor: 1.2,
          ),
          Expanded(
              child: Divider(
            height: .0,
            indent: 10.0,
          ))
        ],
      ),
    );
  }
}

import 'package:wechat_flutter/pages/contacts/group_select_page.dart';
import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class LaunchGroupItem extends StatelessWidget {
  final item;

  LaunchGroupItem(this.item);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: lineColor, width: 0.3),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: new FlatButton(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        onPressed: () {
          if (item == '选择一个群') {
            routePush(new GroupSelectPage());
          } else {
            showToast(context, '敬请期待');
          }
        },
        child: new Container(
          width: winWidth(context),
          padding: EdgeInsets.only(left: 20.0),
          child: new Text(item),
        ),
      ),
    );
  }
}

class LaunchSearch extends StatelessWidget {
  final FocusNode searchF;
  final TextEditingController searchC;
  final ValueChanged<String> onChanged;
  final GestureTapCallback onTap;
  final ValueChanged<String> onSubmitted;
  final GestureTapCallback delOnTap;

  LaunchSearch({
    this.searchF,
    this.searchC,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.delOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: new Image.asset('assets/images/search_black.webp',
              color: mainTextColor),
        ),
        new Expanded(
          child: new TextField(
            focusNode: searchF,
            controller: searchC,
            style: TextStyle(textBaseline: TextBaseline.alphabetic),
            decoration: InputDecoration(
              hintText: '搜索',
              hintStyle: TextStyle(color: lineColor.withOpacity(0.7)),
              border: InputBorder.none,
            ),
            onChanged: onChanged,
            onTap: onTap ?? () {},
            textInputAction: TextInputAction.search,
            onSubmitted: onSubmitted,
          ),
        ),
        strNoEmpty(searchC.text)
            ? new InkWell(
                child: new Image.asset('assets/images/ic_delete.webp'),
                onTap: () {
                  searchC.text = '';
                  delOnTap();
                },
              )
            : new Container()
      ],
    );
  }
}

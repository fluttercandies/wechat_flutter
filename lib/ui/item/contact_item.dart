import 'package:dim_example/pages/contacts/contacts_details_page.dart';
import 'package:dim_example/pages/contacts/new_friend_page.dart';
import 'package:flutter/material.dart';
import 'package:dim_example/pages/chat/chat_page.dart';
import 'package:dim_example/tools/wechat_flutter.dart';

class ContactItem extends StatefulWidget {
  final String avatar;
  final String title;
  final String identifier;
  final String groupTitle;
  final bool isLine;

  ContactItem(
      {@required this.avatar,
      @required this.title,
      this.identifier,
      this.isLine = true,
      this.groupTitle});

  ContactItemState createState() => ContactItemState();
}

class ContactItemState extends State<ContactItem> {
  // ‘添加好友’ 横纵间距
  static const double MARGIN_VERTICAL = 6.0;
  static const double MARGIN_HORIZONTAL = 16.0;

  // ‘ABC...’ 高度
  static const double GROUP_TITLE_HEIGHT = 34.0;

  // items的高度 纵向高度*2+头像高度+分割线高度
  static double heightItem(bool hasGroupTitle) {
    final _buttonHeight = MARGIN_VERTICAL * 2 +
        Constants.ContactAvatarSize +
        Constants.DividerWidth;
    if (hasGroupTitle) return _buttonHeight + GROUP_TITLE_HEIGHT;

    return _buttonHeight;
  }

  Map<String, dynamic> mapData;

  bool isLine() {
    if (widget.isLine) {
      if (widget.title != '公众号') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    /// 定义左边图标Widget
    Widget _avatarIcon = new ImageView(
      img: widget.avatar,
      width: Constants.ContactAvatarSize,
      height: Constants.ContactAvatarSize,
      fit: BoxFit.cover,
    );

    /// 头像圆角
    _avatarIcon = _avatarIcon;

    var content = [
      _avatarIcon,

      ///  头像离名字的距离
      new Space(width: 15.0),
      new Expanded(
        child: new Container(
          padding: const EdgeInsets.only(right: MARGIN_HORIZONTAL),
          height: heightItem(false),

          /// 名字的显示位置
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: !isLine()
                ? null
                : Border(
                    bottom: BorderSide(

                        /// 下划线粗细及颜色
                        width: Constants.DividerWidth,
                        color: Color(AppColors.DividerColor)),
                  ),
          ),

          /// 姓名
          child: new Text(widget.title,
              style: TextStyle(fontWeight: FontWeight.w400), maxLines: 1),
        ),
      ),
    ];

    /// 列表项主体部分
    Widget button = new FlatButton(
      color: Colors.white,
      onPressed: () {
        if (widget.title == '新的朋友') {
          routePush(new NewFriendPage());
        } else {
          routePush(new ContactsDetailsPage(
              id: widget.identifier,
              avatar: widget.avatar,
              title: widget.title));
        }
      },
      child: new Row(children: content),
    );

    /// 定义分组标签（左边的ABC...）
    Widget itemBody;
    if (widget.groupTitle != null) {
      itemBody = new Column(
        children: <Widget>[
          new Container(
            height: GROUP_TITLE_HEIGHT,
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            decoration: BoxDecoration(
              color: const Color(AppColors.ContactGroupTitleBg),
              border: Border(
                top: BorderSide(color: lineColor, width: 0.2),
                bottom: BorderSide(color: lineColor, width: 0.2),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: new Text(widget.groupTitle,
                style: AppStyles.GroupTitleItemTextStyle),
          ),
          button,
        ],
      );
    } else {
      itemBody = button;
    }

    return itemBody;
  }
}

import 'package:dim_example/im/model/contacts.dart';
import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

import 'contact_item.dart';

class ContactView extends StatelessWidget {
  final ScrollController sC;
  final List<ContactItem> functionButtons;
  final List<Contact> contacts;

  ContactView({
    this.sC,
    this.functionButtons = const [],
    this.contacts = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: sC,
      itemBuilder: (BuildContext context, int index) {
        if (index < functionButtons.length) return functionButtons[index];

        int _contactIndex = index - functionButtons.length;
        bool _isGroupTitle = true;
        Contact _contact = contacts[_contactIndex];
        if (_contactIndex >= 1 &&
            _contact.nameIndex == contacts[_contactIndex - 1].nameIndex) {
          _isGroupTitle = false;
        }
        bool _isBorder = _contactIndex < contacts.length - 1 &&
            _contact.nameIndex == contacts[_contactIndex + 1].nameIndex;
        if (_contact.name != contacts[contacts.length - 1].name) {
          return new ContactItem(
            avatar: _contact.avatar,
            title: _contact.name,
            identifier: _contact.identifier,
            groupTitle: _isGroupTitle ? _contact.nameIndex : null,
            isLine: _isBorder,
          );
        } else {
          return new Column(children: <Widget>[
            new ContactItem(
              avatar: _contact.avatar,
              title: _contact.name,
              identifier: _contact.identifier,
              groupTitle: _isGroupTitle ? _contact.nameIndex : null,
              isLine: false,
            ),
            new HorizontalLine(),
            new Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: new Text(
                '${contacts.length}位联系人',
                style: TextStyle(color: mainTextColor, fontSize: 16),
              ),
            )
          ]);
        }
      },
      itemCount: contacts.length + functionButtons.length,
    );
  }
}

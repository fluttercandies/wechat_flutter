import 'package:dim_example/im/entity/i_contact_info_entity.dart';
import 'package:dim_example/im/entity/person_info_entity.dart';
import 'package:flutter/material.dart';
import 'package:dim_example/im/friend_handle.dart';
import 'package:dim_example/im/info_handle.dart';
import 'dart:convert';

import 'package:dim_example/tools/wechat_flutter.dart';
import 'package:dim/pinyin/pinyin_helper.dart';

class Contact {
  Contact({
    @required this.avatar,
    @required this.name,
    @required this.nameIndex,
    @required this.identifier,
  });

  final String avatar;
  final String name;
  final String nameIndex;
  final String identifier;
}

class ContactsPageData {
  Future<bool> contactIsNull() async {
    final user = await SharedUtil.instance.getString(Keys.account);
    final result = await getContactsFriends(user);
    List<dynamic> data = json.decode(result);
    return !listNoEmpty(data);
  }

  listFriend() async {
    List<Contact> contacts = new List<Contact>();
    String avatar;
    String nickName;
    String identifier;
    String remark;

    final contactsData = await SharedUtil.instance.getString(Keys.contacts);
    final user = await SharedUtil.instance.getString(Keys.account);
    final result = await getContactsFriends(user);

    getMethod(result) async {
      List<dynamic> dataMap = json.decode(result);
      int dLength = dataMap.length;
      for (int i = 0; i < dLength; i++) {
        if (Platform.isIOS) {
          IContactInfoEntity model = IContactInfoEntity.fromJson(dataMap[i]);
          avatar = model.profile.faceURL;
          identifier = model.identifier;
          remark = await getRemarkMethod(model.identifier, callback: (_) {});
          nickName = model.profile.nickname;
          nickName = !strNoEmpty(nickName) ? model.identifier : nickName;
          contacts.insert(
            0,
            new Contact(
              avatar: !strNoEmpty(avatar) ? defIcon : avatar,
              name: !strNoEmpty(remark) ? nickName : remark,
              nameIndex:
                  PinyinHelper.getFirstWordPinyin(nickName)[0].toUpperCase(),
              identifier: identifier,
            ),
          );
        } else {
          PersonInfoEntity model = PersonInfoEntity.fromJson(dataMap[i]);
          avatar = model.faceUrl;
          identifier = model.identifier;
          remark = await getRemarkMethod(model.identifier, callback: (_) {});
          nickName = model.nickName;
          nickName = !strNoEmpty(nickName) ? model.identifier : nickName;
          contacts.insert(
            0,
            new Contact(
              avatar: !strNoEmpty(avatar) ? defIcon : avatar,
              name: !strNoEmpty(remark) ? nickName : remark,
              nameIndex:
                  PinyinHelper.getFirstWordPinyin(nickName)[0].toUpperCase(),
              identifier: identifier,
            ),
          );
        }
      }
      return contacts;
    }

    if (strNoEmpty(contactsData) || contactsData != '[]') {
      if (result != contactsData) {
        await SharedUtil.instance.saveString(Keys.contacts, result);
        return await getMethod(result);
      } else {
        return await getMethod(contactsData);
      }
    } else {
      await SharedUtil.instance.saveString(Keys.contacts, result);
      return await getMethod(result);
    }
  }
}

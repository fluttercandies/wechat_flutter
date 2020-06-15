import 'package:wechat_flutter/im/entity/i_contact_info_entity.dart';
import 'package:wechat_flutter/im/entity/i_person_info_entity.dart';
import 'package:wechat_flutter/im/entity/person_info_entity.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/im/friend_handle.dart';
import 'package:wechat_flutter/im/info_handle.dart';
import 'dart:convert';

import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:dim/pinyin/pinyin_helper.dart';

class UserData {
  UserData({
    @required this.avatar,
    @required this.name,
    @required this.identifier,
    @required this.isAdd,
  });

  final String avatar;
  final String name;
  final String identifier;
  final bool isAdd;
}

class UserDataPageGet {
  List ids = [
    '1235888',
    '11222',
    '1352',
    '188',
    '1111',
    '1234',
    '2336',
    '256889',
    '166161',
    '12333333',
    '8183084562',
    '1212',
    '1156',
    '666666',
    '1111',
    '6666',
    '13623',
    '494646',
    '122',
    '233131',
    '1888',
    '156',
    '157',
    '158',
    '159',
    '160',
    '155',
    '123',
    '150',
    '151',
    '152',
    '153',
    '154',
    '131',
    '132',
    '133',
    '134',
    '139',
  ];

  listUserData() async {
    List<UserData> userData = new List<UserData>();
    for (int i = 0; i < ids.length; i++) {
      final profile = await getUsersProfile([ids[i]]);
      List<dynamic> profileData = json.decode(profile);
      for (int i = 0; i < profileData.length; i++) {
        String avatar;
        String name;
        String identifier;
        if (Platform.isIOS) {
          IPersonInfoEntity info = IPersonInfoEntity.fromJson(profileData[i]);
          identifier = info.identifier;
          if (strNoEmpty(info?.faceURL) && info?.faceURL != '[]') {
            avatar = info?.faceURL ?? defIcon;
          } else {
            avatar = defIcon;
          }
          name =
              strNoEmpty(info?.nickname) ? info?.nickname : identifier ?? '未知';
        } else {
          PersonInfoEntity info = PersonInfoEntity.fromJson(profileData[i]);
          identifier = info.identifier;
          if (strNoEmpty(info?.faceUrl) && info?.faceUrl != '[]') {
            avatar = info?.faceUrl ?? defIcon;
          } else {
            avatar = defIcon;
          }
          name =
              strNoEmpty(info?.nickName) ? info?.nickName : identifier ?? '未知';
        }

        final user = await SharedUtil.instance.getString(Keys.account);
        final result = await getContactsFriends(user);
        userData.insert(
          0,
          new UserData(
            avatar: avatar,
            name: name,
            identifier: identifier,
            isAdd: result.toString().contains(identifier),
          ),
        );
      }
    }
    return userData;
  }
}

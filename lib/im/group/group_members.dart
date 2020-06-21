import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wechat_flutter/im/fun_dim_group_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

/*
* 
* 
* */

class GMember {
  GMember(
      {@required this.groupId,
      @required this.groupName,
      @required this.getFaceUrl});

  final String groupId;
  final String groupName;
  final String getFaceUrl;
}

class GroupMemberData {
  getGMembers(Callback callback) {
    List<GMember> gMembers = new List<GMember>();
    String groupId;
    String groupName;
    String getFaceUrl;

    DimGroup.getGroupListModel((result) {
      List<dynamic> dataMap =
          json.decode(result.toString().replaceAll("'", '"'));
      int len = dataMap.length;
      for (int i = 0; i < len; i++) {
        groupId = dataMap[i]['groupId'];
        groupName = dataMap[i]['groupName'];
        getFaceUrl = dataMap[i]['getFaceUrl'];

        gMembers.insert(
            0,
            GMember(
              groupId: groupId,
              groupName: groupName,
              getFaceUrl: getFaceUrl == null || getFaceUrl == ''
                  ? 'http://www.flutterj.com/content/uploadfile/zidingyi/g.png'
                  : getFaceUrl,
            ));
      }
      callback(gMembers);
    });
  }
}

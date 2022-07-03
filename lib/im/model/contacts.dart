import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info.dart';

class Contact {
  Contact({
    @required this.nameIndex,
    @required this.showName,
    @required this.info,
  });

  final String nameIndex;
  final String showName;
  final V2TimFriendInfo info;

  String get avatar {
    return info?.userProfile?.faceUrl;
  }

  String get identifier {
    return info?.userProfile?.userID;
  }

  String get name {
    return showName;
  }
}

import 'package:lpinyin/lpinyin.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_friend_info.dart';
import 'package:wechat_flutter/im/model/contacts.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class ImInfoUtil {
  static List<Contact> friendListToContactList(
      List<V2TimFriendInfo> listFriendInfo) {
    return listFriendInfo?.map((e) {
          final String showName = strNoEmpty(e?.friendRemark)
              ? e?.friendRemark
              : strNoEmpty(e.userProfile.nickName)
                  ? e.userProfile.nickName
                  : e.userID;

          String pinyin = PinyinHelper.getFirstWordPinyin(
              strNoEmpty(showName) ? showName : "");
          String tag =
              strNoEmpty(pinyin) ? pinyin.substring(0, 1).toUpperCase() : "#";
          return Contact(
            nameIndex: tag,
            showName: showName,
            info: e,
          );
        })?.toList() ??
        [];
  }
}

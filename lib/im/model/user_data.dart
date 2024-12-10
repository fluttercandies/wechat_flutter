import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:wechat_flutter/im/friend_handle.dart';
import 'package:wechat_flutter/im/info_handle.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class UserData {
  UserData({
    required this.avatar,
    required this.name,
    required this.identifier,
    required this.isAdd,
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

  Future<List<UserData>> listUserData() async {
    List<UserData> userData = [];
    for (int i = 0; i < ids.length; i++) {
      final List<V2TimUserFullInfo> profileData =
          await getUsersProfile([ids[i]] as List<String>);
      for (int i = 0; i < profileData.length; i++) {
        String avatar;
        String? name;
        String? identifier;

        V2TimUserFullInfo info = profileData[i];
        identifier = info.userID!;
        if (strNoEmpty(info?.faceUrl) && info?.faceUrl != '[]') {
          avatar = info?.faceUrl ?? defIcon;
        } else {
          avatar = defIcon;
        }
        name = strNoEmpty(info?.nickName) ? info?.nickName : identifier ?? '未知';
        final String? user = await SharedUtil.instance.getString(Keys.account);
        final result = await getContactsFriends(user!);
        userData.insert(
          0,
          new UserData(
            avatar: avatar,
            name: name!,
            identifier: identifier,
            isAdd: result.toString().contains(identifier),
          ),
        );
      }
    }
    return userData;
  }
}

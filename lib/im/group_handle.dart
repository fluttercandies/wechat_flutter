import 'package:wechat_flutter/tools/wechat_flutter.dart';

Future<dynamic> getGroupInfoListModel(List<String> groupID,
    {Callback callback}) async {
  try {
    var result = await im.getGroupInfoList(groupID);
    callback(result);
    return result;
  } on PlatformException {
    print('获取群资料  失败');
  }
}

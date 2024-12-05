import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

import '../message_handle.dart';

class ChatDataRep {
  Future<List<V2TimMessage>> repData(String id, int type) async {
    return getDimMessages(id, type: type);
  }
}

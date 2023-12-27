import 'package:event_bus/event_bus.dart';

EventBus receivedMsgBus = EventBus();

class ReceivedMsgModel {
 final  msg;///EMMessage

  /// 是否只有首页刷新
  final bool isOnlyHomeRefresh;

  /*
  * 如果时个人聊天则为对方id，因为是接受消息
  * 如果是群则为群id
  * */
  String get conversationId {
    return msg.conversationId ?? "";
  }

  ReceivedMsgModel(this.msg, {this.isOnlyHomeRefresh = false});
}

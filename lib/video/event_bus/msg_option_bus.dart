import 'package:event_bus/event_bus.dart';

EventBus msgOptionBus = EventBus();

enum MsgOptionType {
  /// 自己发送消息
  selfSendMsg,

  /// 设置已读消息
  setReadMsg,
}

class MsgOptionParam {
  final MsgOptionType msgOptionType;
  final  chatType;///ChatType

  /// 消息内容，如果是发消息给目标必填
  /// 主要给会话列表显示的，所以如果特殊消息是需要转化之后的，比如图片消息：[图片]
  final String? msgContent;

  /// 发送对象
  final String targetId;

  /// 发送对象的显示标题
  final String title;
  final String msgId;

  MsgOptionParam({
    required this.msgOptionType,
    required this.chatType,
    required this.msgContent,
    required this.targetId,
    required this.title,
    required this.msgId,
  });
}

class MsgOptionModel {
  final MsgOptionParam param;

  MsgOptionModel(this.param);
}

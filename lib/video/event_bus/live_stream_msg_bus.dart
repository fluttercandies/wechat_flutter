import 'package:event_bus/event_bus.dart';

EventBus liveStreamMsgBus = EventBus();


class LiveStreamMsgModel {
  final int channelId;
  final String? msgContent;

  LiveStreamMsgModel(this.channelId,this.msgContent);
}

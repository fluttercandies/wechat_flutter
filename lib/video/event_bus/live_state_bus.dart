import 'package:event_bus/event_bus.dart';

enum LiveEventState {
  /// 被拒绝
  denied,

  /// 发送人取消【需要关闭可接听电话页面】
  senderCancel,

  /// 接收人正忙
  receiverBusy,
}

EventBus liveStateBus = EventBus();

class LiveStateBusModel {
  final LiveEventState liveEventState;

  LiveStateBusModel(this.liveEventState);
}

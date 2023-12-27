import 'package:event_bus/event_bus.dart';
import 'package:wechat_flutter/video/model/msg_entity.dart';

// enum LiveMsgEventState {
//   /// 【单人】【视频】对方未响应
//   singleVideoNotRsp,
//
//   /// 【单人】【音频】对方未响应
//   singleAudioNotRsp,
// }

EventBus liveStateToChatBus = EventBus();

class LiveMsgBusModel {
  final String targetId;
  final MsgEntity msgMap;

  LiveMsgBusModel({
    required this.targetId,
    required this.msgMap,
  });
}

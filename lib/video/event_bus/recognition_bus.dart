import 'package:event_bus/event_bus.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

EventBus recognitionBus = EventBus();

class RecognitionBusBusModel {
  final String userId;
  final String text;
  final String msgId;

  bool get isSelf {
    return Q1Data.loginUserId == userId;
  }

  RecognitionBusBusModel(this.userId, this.text, this.msgId);
}

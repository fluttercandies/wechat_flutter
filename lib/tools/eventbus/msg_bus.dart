import 'package:event_bus/event_bus.dart';

EventBus msgBus = EventBus();

class MsgBusModel {
  final String? toUserId;


  MsgBusModel(this.toUserId);
}

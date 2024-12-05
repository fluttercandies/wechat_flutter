import 'package:get/get.dart';

class EventBusNewMsg {
  final String covId;

  EventBusNewMsg(this.covId);
}

Rx<EventBusNewMsg> eventBusNewMsg = EventBusNewMsg("").obs;

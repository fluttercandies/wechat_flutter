import 'package:event_bus/event_bus.dart';

EventBus refreshCovBus = EventBus();

class RefreshCovModel {
  final bool isOnlyRefreshUI;

  RefreshCovModel({this.isOnlyRefreshUI = false});
}

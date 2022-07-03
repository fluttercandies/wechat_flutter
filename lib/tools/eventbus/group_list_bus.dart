import 'package:event_bus/event_bus.dart';

/// 群聊列表刷新
EventBus groupListBus = EventBus();

class GroupListModel {
  final String id;

  GroupListModel(this.id);
}

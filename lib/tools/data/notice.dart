import 'dart:async';

import 'package:flutter/material.dart';

class Notice {
  static final Map<String, List<Function>> _listeners = {};

  static void addListener(String event, Function callback) {
    _listeners.putIfAbsent(event, () => []).add(callback);
  }

  static void removeListener(String event, Function callback) {
    _listeners[event]?.remove(callback);
    if (_listeners[event]?.isEmpty ?? false) {
      _listeners.remove(event);
    }
  }

  static void send(String event, [dynamic data]) {
    if (_listeners.containsKey(event)) {
      for (var callback in _listeners[event]!) {
        callback(data);
      }
    }
  }

  static void clear() {
    _listeners.clear();
  }
}

mixin BusStateMixin<T extends StatefulWidget> on State<T> {
  final List<StreamSubscription> _subscriptions = [];

  void bus(String event, Function(dynamic) callback) {
    final subscription = StreamController.broadcast().stream.listen(callback);
    _subscriptions.add(subscription);
    Notice.addListener(event, callback);
  }

  void busDel(Function(dynamic) callback) {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    Notice.removeListener(callback.toString(), callback);
  }

  @override
  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }
}

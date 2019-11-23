import 'package:flutter/material.dart';

typedef Callback(data);

class Notice {
  Notice._();

  static final _eventMap = <String, List<Callback>>{};

  static Callback addListener(String event, Callback call) {
    var callList = _eventMap[event];
    if (callList == null) {
      callList = new List();
      _eventMap[event] = callList;
    }

    callList.add(call);

    return call;
  }

  static removeListenerByEvent(String event) {
    _eventMap.remove(event);
  }

  static removeListener(Callback call) {
    final keys = _eventMap.keys.toList(growable: false);
    for (final k in keys) {
      final v = _eventMap[k];

      final remove = v.remove(call);
      if (remove && v.isEmpty) {
        _eventMap.remove(k);
      }
    }
  }

  static once(String event, {data}) {
    final callList = _eventMap[event];

    if (callList != null) {
      for (final item in new List.from(callList, growable: false)) {
        removeListener(item);

        _errorWrap(event, item, data);
      }
    }
  }

  static send(String event, [data]) {
    var callList = _eventMap[event];

    if (callList != null) {
      for (final item in callList) {
        _errorWrap(event, item, data);
      }
    }
  }

  static _errorWrap(String event, Callback call, data) {
    try {
//      xlog(() => 'Bus>>>$event>>>$data');
      call(data);
    } catch (e) {
//      xlog(() => 'Bus>>>$event>>>$e');
//      xlog(() => 'Bus>>>$event>>>$s');
    }
  }
}

mixin BusStateMixin<T extends StatefulWidget> on State<T> {
  List<Callback> _listeners;

  void bus(String event, Callback call) {
    _listeners ??= new List();
    _listeners.add(Notice.addListener(event, call));
  }

  void busDel(Callback call) {
    if (_listeners.remove(call)) {
      Notice.removeListener(call);
    }
  }

  void busDelAll() {
    _listeners?.forEach(Notice.removeListener);
    _listeners?.clear();
  }

  @override
  void dispose() {
    busDelAll();

    super.dispose();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_flutter/tools/data/notice.dart';

typedef Widget StoreBuilder<T>(T? item);

final _storeMap = <String, dynamic>{};

class Store<T> {
  final String _action;

  const Store(this._action);

  T? get value => _storeMap[_action] as T?;

  set value(T? v) {
    if (!(v is List) && !(v is Set) && !(v is Map) && v == _storeMap[_action])
      return;

    _storeMap[_action] = v;

    Notice.send('Store::$_action', v);
  }

  void clear() => dispose(_action);

  void notifyListeners() => Notice.send('Store::$_action', _storeMap[_action]);

  static void dispose(String action) {
    for (final key in _storeMap.keys.toList(growable: false)) {
      if (key.startsWith(action)) {
        final v = _storeMap.remove(key);

        Notice.send('Store::$key', null);
        Notice.send('Store::$key::dispose', v);
      }
    }
  }
}

class CacheWidget<T> extends StatefulWidget {
  final String action;
  final StoreBuilder<T> builder;
  final T? data;

  const CacheWidget(this.action, this.builder, {Key? key, this.data})
      : super(key: key);

  @override
  _CacheWidgetState<T> createState() => _CacheWidgetState<T>();
}

class _CacheWidgetState<T> extends State<CacheWidget<T>> with BusStateMixin {
  T? item;

  void init() {
    final action = widget.action;

    item = _storeMap[action] as T?;

    bus('Store::$action', onData);
  }

  @override
  void initState() {
    super.initState();
    init();
    widget.builder(item);
  }

  @override
  void didUpdateWidget(CacheWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    busDel(onData);

    init();
  }

  void onData(dynamic _) {
    if (mounted) Timer.run(() => setState(() => item = _ as T?));
  }

  @override
  Widget build(BuildContext context) => widget.builder(item);
}

Future<void> storeString(String k, String v) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(k, v);
}

Future<String?> getStoreValue(String k) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(k);
}

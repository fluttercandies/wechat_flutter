import 'package:wechat_flutter/tools/data/notice.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

typedef Widget StoreBuilder<T>(T item);

final _storeMap = <String, dynamic>{};

class Store<T> {
  final String _action;

  const Store(this._action);

  T get value => _storeMap[_action];

  set value(T v) {
    if (!(v is List) && !(v is Set) && !(v is Map) && v == _storeMap[_action])
      return;

    _storeMap[_action] = v;

    Notice.send('Store::$_action', v);
  }

  clear() => dispose(_action);

  notifyListeners() => Notice.send('Store::$_action', _storeMap[_action]);

  static dispose(String action) {
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
  final data;

  CacheWidget(this.action, this.builder, {Key key,this.data}) : super(key: key);

  @override
  _CacheWidgetState createState() => new _CacheWidgetState<T>();
}

class _CacheWidgetState<T> extends State<CacheWidget<T>>
    with BusStateMixin {
  T item;

  void init() {
    final action = widget.action;

    item = _storeMap[action] as T;

    bus('Store::$action', onData);
  }

  @override
  void initState() {
    super.initState();
    init();
    widget.builder(item);
  }

  @override
  void didUpdateWidget(CacheWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    busDel(onData);

    init();
  }

  void onData(_) {
    if (mounted) Timer.run(() => setState(() => item = _));
  }

  @override
  Widget build(BuildContext context) => widget.builder(item);
}

storeString(String k,v) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(k, v);
}

Future<String> getStoreValue(String k) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.get(k);
}

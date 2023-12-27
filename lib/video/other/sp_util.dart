import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  //创建工厂方法
  static SpUtil? _instance;

  factory SpUtil() => _instance ??= SpUtil._initial();
  SharedPreferences? _preferences;

  //创建命名构造函数
  SpUtil._initial() {
    //为什么在这里需要新写init方法 主要是在命名构造中不能使用async/await
    init();
  }

  //初始化SharedPreferences
  void init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  //到这里还没有完 有时候会遇到使用时提示 SharedPreferences 未初始化,所以还需要提供一个static 的方法
  static Future<SpUtil?> perInit() async {
    if (_instance == null) {
      //静态方法不能访问非静态变量所以需要创建变量再通过方法赋值回去
      SharedPreferences preferences = await SharedPreferences.getInstance();
      _instance = SpUtil._pre(preferences);
    }
    return _instance;
  }

  SpUtil._pre(SharedPreferences prefs) {
    _preferences = prefs;
  }

  ///设置String类型的
  Future setString(key, String value) async {
    await _preferences?.setString(key, value);
  }

  ///设置setStringList类型的
  Future setStringList(key, List<String> value) async {
    await _preferences?.setStringList(key, value);
  }

  ///设置setBool类型的
  void setBool(key, value) {
    _preferences?.setBool(key, value);
  }

  ///设置setDouble类型的
  void setDouble(key, value) {
    _preferences?.setDouble(key, value);
  }

  ///设置setInt类型的
  void setInt(key, value) {
    _preferences?.setInt(key, value);
  }

  ///存储Json类型的
  void setJson(key, value) {
    value = jsonEncode(value);
    _preferences?.setString(key, value);
  }

  ///通过泛型来获取数据
  T? get<T>(key) {
    var result = _preferences?.get(key);
    if (result != null) {
      return result as T;
    }
    return null;
  }

  ///获取JSON
  Map<String, dynamic>? getJson(key) {
    String? result = _preferences?.getString(key);
    // if (StringUtil.isNotEmpty(result)) {
    //   return jsonDecode(result!);
    // }
    if (result != '' && result != null) {
      return jsonDecode(result);
    }

    return null;
  }

  ///文中的StringUtil中的isNotEmpty的判断
  ///  static isNotEmpty(String? str) {
  /// return str?.isNotEmpty ?? false;
  /// }
  ///清除全部
  void clean() {
    _preferences?.clear();
  }

  ///移除某一个
  void remove(key) {
    _preferences?.remove(key);
  }
}

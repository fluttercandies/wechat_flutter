import 'package:flutter/cupertino.dart';
import 'package:wechat_flutter/main.dart';

class LogUtil {
  static bool? _isDebug = true;
  static int _limitLength = 800;

  static void init({@required bool? isDebug, int? limitLength}) {
    _isDebug = isDebug;
    _limitLength = limitLength ??= _limitLength;
  }

  //仅Debug模式可见
  static void d(dynamic obj) {
    /// 方便输出，非debug也需要见
    _log(obj.toString());
  }

  static void v(dynamic obj) {
    _log(obj.toString());
  }

  static void vPrint(dynamic obj) {
    _logPrint(obj.toString());
  }

  static void _log(String msg) {
    if (msg.length < _limitLength) {
      q1Logger.info(msg);
    } else {
      segmentationLog(msg);
    }
    _logEmpyLine();
  }

  static void _logPrint(String msg) {
    if (msg.length < _limitLength) {
      debugPrint(msg);
    } else {
      segmentationLogPrint(msg);
    }
  }

  static void segmentationLog(String msg) {
    var outStr = StringBuffer();
    for (var index = 0; index < msg.length; index++) {
      outStr.write(msg[index]);
      if (index % _limitLength == 0 && index != 0) {
        q1Logger.info(outStr);

        outStr.clear();
        var lastIndex = index + 1;
        if (msg.length - lastIndex < _limitLength) {
          var remainderStr = msg.substring(lastIndex, msg.length);
          q1Logger.info(remainderStr);
          break;
        }
      }
    }
  }

  static void segmentationLogPrint(String msg) {
    var outStr = StringBuffer();
    for (var index = 0; index < msg.length; index++) {
      outStr.write(msg[index]);
      if (index % _limitLength == 0 && index != 0) {
        debugPrint(outStr.toString());

        outStr.clear();
        var lastIndex = index + 1;
        if (msg.length - lastIndex < _limitLength) {
          var remainderStr = msg.substring(lastIndex, msg.length);
          debugPrint(remainderStr);
          break;
        }
      }
    }
  }

  static void _logEmpyLine() {
    print("");
  }
}

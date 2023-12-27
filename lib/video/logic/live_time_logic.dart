
import 'package:wechat_flutter/tools/wechat_flutter.dart';

abstract class LiveTimeObs {
  Timer? timer;

  int timeValue = 0;
  RxString timeValueStr = "".obs;
}

mixin LiveTimeLogic on LiveTimeObs {
  void startTime() {
    LogUtil.d("音频计时");
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeValue++;
      LogUtil.d("音频计时 timeValue：$timeValue");

      setTimeStr();
    });
  }

  /// 接听电话之后计时
  void setTimeStr() {
    var remainingTimeMyDate = DateTime.now().add(Duration(seconds: timeValue));
    var def = remainingTimeMyDate.difference(DateTime.now());
    var inHour = doubleNum(def.inHours % 24);
    String inHours = inHour;
    var inMinute = doubleNum(def.inMinutes % 60);
    String inMinutes = inMinute;
    var inSecond = doubleNum(def.inSeconds % 60);
    String inSeconds = inSecond;
    if (inHours != "00") {
      timeValueStr.value = "$inHours:$inMinutes:$inSeconds";
    } else {
      timeValueStr.value = "$inMinutes:$inSeconds";
    }
  }

  void cancelTime() {
    timeValue = 0;
    timeValueStr.value = "00:00";
    timer?.cancel();
    timer = null;
  }
}

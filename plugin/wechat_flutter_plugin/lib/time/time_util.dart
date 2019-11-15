
import 'dart:async';

///timer callback.(millisUntilFinished 毫秒).
typedef void OnTimerTickCallback(int millisUntilFinished);

class TimerUtil {
  TimerUtil({this.mInterval = Duration.millisecondsPerSecond, this.mTotalTime});

  OnTimerTickCallback _onTimerTickCallback;

  /// Timer是否启动.
  bool _isActive = false;

  Timer _mTimer;

  /// Timer间隔 单位毫秒，默认1000毫秒(1秒).
  int mInterval;

  /// 倒计时总时间
  int mTotalTime; //单位毫秒

  /// 设置Timer间隔.
  void setInterval(int interval) {
    if (interval <= 0) interval = Duration.millisecondsPerSecond;
    mInterval = interval;
  }

  /// 设置倒计时总时间.
  void setTotalTime(int totalTime) {
    if (totalTime <= 0) return;
    mTotalTime = totalTime;
  }

  /// Timer是否启动.
  bool isActive() {
    return _isActive;
  }

  void _doCallback(int time) {
    if (_onTimerTickCallback != null) {
      _onTimerTickCallback(time);
    }
  }

  void startCountDown() {
    if (_isActive || mInterval <= 0 || mTotalTime <= 0) return;
    _isActive = true;
    Duration duration = Duration(milliseconds: mInterval);
    _doCallback(mTotalTime);
    _mTimer = Timer.periodic(duration, (Timer timer) {
      int time = mTotalTime - mInterval;
      mTotalTime = time;
      if (time >= mInterval) {
        _doCallback(time);
      } else if (time == 0) {
        _doCallback(time);
        cancel();
      } else {
        timer.cancel();
        Future.delayed(Duration(milliseconds: time), () {
          mTotalTime = 0;
          _doCallback(0);
          cancel();
        });
      }
    });
  }

  void cancel() {
    if (_mTimer != null) {
      _mTimer.cancel();
      _mTimer = null;
    }
    _isActive = false;
  }

  // set timer callback.
  void setOnTimerTickCallback(OnTimerTickCallback callback) {
    _onTimerTickCallback = callback;
  }
}

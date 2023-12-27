import 'dart:async';

import 'package:get/get.dart';
import 'package:wechat_flutter/video/float/float_window_impl.dart';
import 'package:wechat_flutter/video/impl/live_logic_impl.dart';
import 'package:wechat_flutter/video/impl/live_util.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

abstract class SingleNoRspAbs {
  /// 倒计时秒
  int noRspTimeValue = 0;

  /// 是否倒计时完毕
  /// 如果对方接听了则设置为ok，下次无论怎么转音频视频都不需要再倒计时了
  bool noRspIsOk = false;

  /// 倒计时计时器
  Timer? noRspTimer;

  /// 未接听最大秒
  /// 50秒
  final int noRspMaxTimerCount = 50;

  /*
  * 【未响应处理】开始倒计时
  * */
  void noRspStartTime(VoidCallback onNoRsp);

  /*
  * 【未响应处理】取消倒计时
  * */
  void noRspCancelTime();

  /*
  * 【未响应处理】接听
  * */
  void noRspReceive() {
    noRspIsOk = true;

    noRspCancelTime();
  }

  /*
  * 【未响应处理】方便视频转语音
  * */
  void noRspChangeToVoice(SingleNoRspAbs? value) {
    if (value == null) return;
    noRspTimeValue = value.noRspTimeValue;
    noRspIsOk = value.noRspIsOk;
    if (noRspIsOk) noRspCancelTime();
  }

  /*
  * 【未响应处理】重置值
  * */
  void noRspRestValue() {
    noRspTimeValue = 0;
  }
}

/*
* 单聊没有响应处理
*
* 现在多聊也要使用了
* */
mixin SingleNoRsp on SingleNoRspAbs, LiveCheckClose {
  @override
  void noRspStartTime(VoidCallback onNoRsp) {
    LogUtil.d("noRspStartTime::开始检测倒计时::noRspIsOk是$noRspIsOk");

    /// 已接听，直接返回
    if (noRspIsOk) {
      return;
    }

    noRspCancelTime();
    noRspTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (noRspTimeValue < noRspMaxTimerCount) {
        noRspTimeValue++;
        LogUtil.d("noRspTimeValue::$noRspTimeValue");
      } else {
        noRspCancelTime();

        /// 先等待，如果还未接听
        await Future.delayed(const Duration(milliseconds: 100));

        /// 如果是视频转语音有慢操作
        if (noRspIsOk) {
          return;
        }
        noRspRestValue();

        // 关闭页面，不显示小窗;
        setClosePage();

        /// 防止[setClosePage]没有响应过来
        await Future.delayed(const Duration(milliseconds: 100));

        /// 发送隐藏消息给对方【让其关闭等待接听的页面】
        /// 发送【对方无应答】可视消息
        onNoRsp();

        /// 关闭音视频且提示消息
        LiveUtil.closeAndTip("对方无响应");
      }
    });
  }

  @override
  void noRspCancelTime() {
    noRspTimer?.cancel();
    noRspTimer = null;
  }
}
